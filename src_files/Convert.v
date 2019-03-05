`timescale 1ns / 1ps
module Convert(clk, SW, clk_N, go, rst, ram_display_addr, display_op)
  input clk;				//时钟信号输入
  input [15:0] SW;			//按键输入
  output clk_N;				//分频后的时钟
  output go;				//暂停、运行
  output rst;				//为1时，复位
  output [9:0] ram_display_addr;		//ram显示地址
  output [2:0] display_op;				//显示内容控制信号






endmodule

  
拨动翻倍时钟频率
