# DigitalClock_Design

# 项目简介

该项目是基于Nexys4 DDR开发板的Verilog实现的数字钟项目，数字钟可以实现计时、闹钟等功能



# 功能介绍

该数字钟包含以下功能：

1. 显示当前时间（支持12小时与24小时制）
2. 修改时间
3. 设定闹钟
4. 正点报时



# 使用方法

## 创建工程

1. 下载Vivado平台（测试使用版本为Vivado2021.2），并将文件导入工程中，注意同时导入源文件和约束文件。
2. 点击Generate Bitstream，等待生成完后，点击Auto connected与开发板连接，再点击Program device将程序下载到开发板上即可



## 控件说明

此处介绍时将用各控件在开发板上标注的名称来指代



拨动控件：

- V10：清零信号。为0时时钟关机，为1时正常启动
- U11：模式信号。为0时显示时钟，为1时显示闹钟
- U12：时制信号。为0时显示12小时进制，为1时显示24小时进制
- H6：调整信号。为0时关闭调整，为1时开启调整
- T13：响铃信号。为0时闹钟不工作，为1时闹钟开始工作

注意：当调整拨动控件切换模式时，最好将不必要的控件拨至0，以免产生错误



脉冲控件：

- P18：向下调整位
- M17：向右调整位
- P17：向左调整位
- M18：向上调整位
- N17：应用更改



显示控件：

- J17、J18、T9 、J14、P14、T14、K2 、U13用于七段数码管的显示
- H17、K15、J13、N14、R18、V17、U17、U16、V16、T15、U14、T16、V15、V14、V12、V11用于显示LED灯



# 模块简介

## 1. clock

该模块为主模块，负责协调各个模块之间的输入输出关系

接口如下：

```verilog
	input CP,                   // 100MHz输入时钟信号
	input _CR,                  // 置零信号
	input mode,                 // 模式切换信号
	input adjust,               // 调整模式信号
	input time_mode,            // 时制切换信号
	input active_alarm,         // 闹钟激活信号
	input left,                 // 左移信号
	input right,                // 右移信号
	input up,                   // 上移信号 
	input down,                 // 下移信号
	input apply,                // 应用信号
	    
	output [15:0] start_light,  // 控制LED信号
	output [7:0] select_light,  // 控制数码管亮的位置
	output [7:0] display_char   // 控制显示的字符
```

## 2. divider

该模块为分频器模块，作用是将输入信号（已固定为100MHz）分频为需要的信号

接口如下：

```verilog
	input CP,           // 输入时钟信号
	input _CR,          // 置零信号
	
	output reg CP_1Hz,  // 输出1Hz信号
	output reg CP_10Hz, // 输出10Hz信号
	output reg CP_1KHz  // 输出1KHz信号
```

## 3. counter

该模块为计数器模块，因为三个模块均为计数器，其中原理相似，因此我们放在一起介绍。

秒计数器和分计数器均为模60计数器，时计数器为模24计数器

这三个模块的功能是实现时钟的内置的计时器，即作为时钟

接口如下（此处以秒计数器为例）：

```verilog
	input CP_1Hz,			//输入计数信号，即1秒计一次数（另外两个计数器则以前一个计数器的进位作为计数信号）
	input adjust,			//当处于调整模式时，计数器应该停止计数，防止出现冲突
	input _CR,			//置零信号
	input mode,			//闹钟信号，用于确保闹钟在设置时，计数器可以正常运行
	input PE,			//预置信号，用于将修改后的时间应用到计时器上
	input [7:0] pre_sec,		//预置时间，计数器应该被修改的值
	
	output reg [7:0] show_sec,	//当前计数器的值
	output reg cin_sec		//进位信号，满60进1（时计数器为满24进1）
```

注：mode和adjust信号是秒计数器特有的信号，因为秒计数器是串行计数器的起始，当秒计数器暂停计数时，后续计数器都会暂停

## 4. alarm

该模块为闹钟模块，作用是控制闹钟的所有响应

接口如下：

```verilog
	input _CR,			//置零信号
	input PE,			//置数信号，将设定好的闹钟时间写入内部
	input [7:0] pre_min,		//预置闹钟的时
	input [7:0] pre_hour,		//预置闹钟的分
	input active_alarm,		//开启闹钟，当为0时闹钟不工作
	input [7:0] show_hour,		//输入当前的时，用于判断是否该响铃
	input [7:0] show_min,		//输入当前的分，用于判断是否该响铃
	input [7:0] show_sec,		//输入当前的秒，用于判断是否该响铃
	
	output reg start_light_alarm,	//响铃信号，当到达了闹钟设定的时间则输出响铃信号
	output reg [31:0] alarm_time	//输出内部设定的闹钟时间
```

## 5. select_control

该模块为选择中控器，作用是依据模式输出数码管应该输出的信号，依据外部输入调整中控器的临时信号

接口如下

```verilog
	input _CR,				//清零信号
	input mode,				//模式信号
	input CP_10Hz,				//用于接受和处理用户的输入以及内部的选择
	input adjust,				//调整模式
	input [31:0] show_time,			//计数器当前的时间
	input [31:0] alarm_time,		//闹钟当前的时间
	input left,				//左移信号
	input right,				//右移信号
	input up,				//上移信号
	input down,				//下移信号
	input apply,				//应用信号
	input time_mode,			//时制信号
	output reg [63:0] display_time,		//输出给显示器应该显示的信号
	output reg [31:0] set_time,		//用户修改后的时间
	output reg [3:0]index,			//当前用户选择的位
	output reg PE				//置数信号，当用户按下apply后激活拆分器
```

## 6. splitter

该模块为拆分器，用于将中控器输入的用户确认后的时间信号拆分并传入计数器或闹钟中

接口如下：

```verilog
    input _CR,				//置零信号
    input [31:0] display_time,		//中控器传入的待确认信号
    input time_mode,			//时制信号
    input mode,				//模式信号
    input PE,				//置数信号，激活拆分器
    output reg [7:0] pre_sec,		//被拆分为秒的部分
    output reg [7:0] pre_min,		//被拆分为分的部分
    output reg [7:0] pre_hour,		//被拆分为时的部分
    output reg PE_alarm,		//将修改应用至闹钟
    output reg PE_counter		//将修改应用至计数器
```

## 7. decoder

该模块为显示器，用于将传入的显示时间在数码管上显示出来

接口如下：

```verilog
    input _CR,				//清零信号
    input [63:0] display_time,		//显示时间
    input [3:0]index,    		//需要闪烁的位
    input adjust,			//开启闪烁
    input CP_1KHz,			//刷新屏幕时钟

    output reg [7:0] select_light,	//选择哪一位数码管亮
    output reg [7:0] display_char,	//此时应该显示的字符
```

## 8. reminder

该模块为亮灯器，用于展示闹钟的响铃和正点报时

接口如下：

```Verilog
    input _CR,					//清零信号
    input CP_1Hz,				//亮灯频率
    input start_light_hour,			//开始正点报时
    input start_light_alarm,			//开始响闹钟
    input [7:0] show_sec,			//用于结束正点报时
    input[7:0] show_hour,			//当前时，确定正点报时次数
    input active_alarm,				//确定闹钟处于工作模式
    
    output reg [15:0] start_light   //前14位为闹钟的灯  后两位为正点报时的灯
```

