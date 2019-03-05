`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2019/03/04 20:39:12
// Design Name: 
// Module Name: LED
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module LED(
    input clk,  //系统时钟周期
    input led_cpu_enable,   //syscall 34信号，高电平有效
    input [2:0] display_op,     //显示内容控制信号
    input [31:0] led_data_in,   //程序显示内容
    input [31:0] total_cycles,  //总周期数
    input [31:0] uncondi_branch_num,    //无条件周期数
    input [31:0] condi_branch_num,  //有条件分支数
    input [31:0] ram_display_data_out,  //内存数据输出
    output reg [7:0] SEG,   //选择显示输出
    output reg [7:0] AN     //显示内容输出
    );

    
endmodule
