# zynq7020-function-generator-lcd-1024x600
FPGA-based function generator on Zynq-7020 with 1024x600 RGB888 TFT-LCD waveform display (DDS core, key-controlled frequency and waveform selection). 基于 Zynq-7020 和 1024×600 RGB888 LCD 的数字函数发生器工程。
# Zynq-7020 函数发生器（1024×600 RGB888）

本工程基于 **Zynq-7020** + **1024×600 RGB888 TFT-LCD** 实现一个简单的数字函数发生器，整体分为三部分：

1. **按键与频率控制**（切换频率、波形）
2. **DDS 波形产生**（正弦/方波/三角/锯齿等）
3. **波形缓冲与 LCD 显示**（双缓冲 + 网格/坐标/文字）

下面只简单说明各模块的功能及它们之间的关系，方便阅读源码。

---

## 顶层结构

### `function_generator_top.v`
- **功能**：整个工程的顶层模块。
- **主要连接**：
  - 连接外部：`clk`、`rst_n`、按键输入、LCD 接口引脚。
  - 例化：
    - `freq_sel_top`：按键 → 频率控制字/波形选择。
    - `dds_top`：根据频率控制字产生数字波形。
    - `lcd_top`：负责波形缓冲和 LCD 显示。
- 可以把它理解为“把所有子模块串起来”的地方。

---

## 按键与频率控制

### `freq_sel_top.v`
- **功能**：按键频率/模式控制顶层。
- **主要连接**：
  - 输入：`freq_up_key_i` / `freq_down_key_i` 等实际按键信号。
  - 内部例化：
    - `switch_debounce`：按键去抖。
    - `edge_detect`：产生单周期触发脉冲。
    - `freq_sel`：根据触发脉冲调整频率控制字、波形编号等。
  - 输出：
    - `frequency_o`：给 `dds_core` / `dds_top` 用的频率控制字。
    - `freq_num`、可能还有波形选择信息：传给 `wave_sel` 和 `lcd_top` 用于显示。

### `switch_debounce.v`
- **功能**：对机械按键进行去抖，输出稳定的按键电平。
- **使用场景**：被 `freq_sel_top` 调用，对 `freq_up_key` / `freq_down_key` 做预处理。

### `edge_detect.v`
- **功能**：检测按键电平的上升沿或下降沿，输出单周期脉冲。
- **使用场景**：在 `freq_sel_top` 中用于产生“单击”事件，用来增加/减小频率或切换波形。

### `freq_sel.v`
- **功能**：根据按键触发，更新当前**频率控制字**和**频率编号**。
- **主要逻辑**：
  - 内部保存当前频率寄存器。
  - 接收到“向上/向下”脉冲后，按固定步进加/减频率控制字。
- **输出**：
  - `frequency_o`：提供给 DDS 的 32-bit 控制字。
  - `freq_num`：提供给显示模块，用文字显示当前频率档位。

---

## DDS 波形产生链路

### `dds_core.v`
- **功能**：封装 Xilinx DDS Compiler IP 或自写 DDS，产生基础波形和相位。
- **主要接口**：
  - 输入：`clk_i`、`rst_n_i`、`frequency_i`（来自 `freq_sel`）。
  - 输出：
    - `dds_wave`：8-bit 数字波形数据（正弦等）。
    - `dds_phase`：DDS 相位数据（供后级生成其他波形形状或调试）。

### `wave_sel.v`
- **功能**：根据模式选择输出不同波形（正弦、方波、三角波、锯齿波等）。
- **主要连接**：
  - 输入：
    - 来自 `dds_core` 的基础正弦波 / 相位信息。
    - 波形模式（可能来自 `freq_sel_top` 或额外按键）。
  - 输出：
    - `wave_data`：最终 8-bit 波形数据。
    - `wave_data_valid`：数据有效标志。
- **作用**：
  - 用 DDS 相位简单组合/运算得到三角、锯齿等波形；
  - 再根据当前模式输出其中一种到后级。

### `dds_down_sample.v`
- **功能**：对 DDS 输出进行**抽样/降采样**，控制在屏幕上显示的点数和更新速度。
- **主要连接**：
  - 输入：`wave_data`、`wave_data_valid`。
  - 通过内部计数器降低有效点率，输出较慢的 `sample_data` 和 `wr_en`。
- **作用**：
  - 避免每个时钟都写入 RAM/更新屏幕导致“粒子”/模糊效果；
  - 和 `scope_buffer` 配合，生成每帧固定数量的采样点。

### `dds_top.v`
- **功能**：DDS 部分的子系统顶层。
- **内部例化**：
  - `dds_core`：产生基础 DDS 波形。
  - `wave_sel`：产生多种波形。
  - `dds_down_sample`：对波形数据抽样。
- **输出**：
  - 提供给 `scope_buffer` 或 `lcd_top` 的**抽样后的 8-bit 波形数据**和写使能。

---

## 波形缓冲与 LCD 显示

### `scope_buffer.v`
- **功能**：波形双缓冲 / 显示缓冲模块，类似简易“示波器存储器”。
- **主要接口**：
  - 输入：
    - 抽样波形数据 `wave_data`、写使能 `wave_data_valid`（来自 `dds_top`）。
    - 当前像素坐标 `x_pos`, `y_pos`（来自 `lcd_driver`）。
  - 输出：
    - `data`：根据当前显示 RAM 内容给出对应 X 位置的波形点（映射为 0~255 高度）。
- **内部逻辑（典型做法）**：
  - 两块 RAM 交替：
    - 一块用于写入新采样的 1024 点波形；
    - 另一块用于当前 LCD 帧显示；
  - 一帧结束后交换角色，实现**显示稳定**又能不断更新。

### `lcd_driver.v`
- **功能**：面向 1024×600 RGB888 的 LCD 时序驱动。
- **主要接口**：
  - 输出：`lcd_clk`、`lcd_de`、`lcd_hs`、`lcd_vs`、`lcd_bl`、像素坐标 `pixel_xpos`、`pixel_ypos` 等。
  - 输入：来自 `lcd_display` 的 `pixel_data`。
- **作用**：
  - 产生行/列时序与 DE 信号；
  - 输出像素坐标给上层绘图逻辑。

### `lcd_display.v`
- **功能**：根据像素坐标、波形数据、文本信息，生成最终像素颜色。
- **主要输入**：
  - `pixel_xpos`, `pixel_ypos`：当前像素坐标。
  - `dds_wave_data` 或来自 `scope_buffer` 的数据。
  - `freq_num`：用于显示当前频率。
  - 可能还包括 `text_on` 等字体叠加信号。
- **主要输出**：
  - `pixel_data[23:0]`：RGB888 颜色。
- **绘制内容**（典型）：
  - 背景色 + 网格线 + 坐标轴；
  - 在波形区域根据 `scope_buffer` 给出的位置绘制波形；
  - 在固定位置调用 `text_display` 显示当前频率/波形信息。

### `text_display.v`
- **功能**：字符显示模块，用点阵字体在指定区域显示频率值等字符串。
- **主要接口**：
  - 输入：`x_pos`, `y_pos`, `freq_num`；
  - 内部查表：调用 `freq_front_5x7`（点阵 ROM）。
  - 输出：`text_on` / 字符像素信息，供 `lcd_display` 叠加。

### `freq_front_5x7.v`
- **功能**：5×7 点阵字体 ROM。
- **作用**：
  - 根据字符编码（数字/字母）和行号输出 5-bit 像素列；
  - 被 `text_display` 调用，实现 `FREQ: XX` 等字样。

### `lcd_top.v`
- **功能**：显示子系统顶层。
- **内部例化**：
  - `lcd_driver`：生成坐标与基本时序。
  - `scope_buffer`：提供每个 X 对应的波形数据。
  - `lcd_display`：组合波形 + 字符 + 网格生成颜色。
  - `text_display`：给 `lcd_display` 提供字符像素信息。
- **输出**：所有面向 LCD 的信号。

---

## 各部分之间的关系（简要数据流）

```text
按键 ----> switch_debounce -> edge_detect -> freq_sel_top
                                      |
                                      |--> frequency_o ----+
                                                           |
                                                           v
                                                    dds_core (DDS)
                                                           |
                                  +------------------------+ 
                                  |                        |
                             wave_sel (选波形)             |
                                  |                        |
                             dds_down_sample (抽样)        |
                                  |                        |
                                  v                        |
                             scope_buffer (双缓冲)         |
                                  |                        |
                                  v                        |
LCD_driver 提供像素坐标 --> lcd_display <--- text_display (freq_num)
                                  |
                                  v
                              lcd_top -> LCD RGB888 输出
