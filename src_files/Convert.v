`timescale 1ns / 1ps
module Convert#(parameter ADDR_BITS=12, parameter  N = 10_000_000)(clk, SW, clk_N, go, rst, ram_display_addr, display_op);
  input clk;				//时钟信号输入
  input [15:0] SW;			//按键输入
  output reg clk_N = 0;				//分频后的时钟
  output go;				//暂停、运行
  output rst;				//为1时，复位
  output [ADDR_BITS-3:0] ram_display_addr;		//ram地址
  output [2:0] display_op;				//显示内容控制信号
  
  reg [1:0] i = 2'b00;
  wire clk_0, clk_1, clk_2, clk_3;


  assign go = SW[0];
  assign rst = SW[1];
  
  

  always @(posedge SW[2])
  begin
    i <= i+1;
  end
  
  always @(*)
  begin
    case (i)
      2'b00: clk_N <= clk_0;
      2'b01: clk_N <= clk_1;
      2'b10: clk_N <= clk_2;
      2'b11: clk_N <= clk_3;
      default: clk_N <= clk_N;
    endcase
  end
  
  assign display_op[2 : 0] = SW[5: 3];
  assign ram_display_addr[ADDR_BITS-3 : 0] = SW[ADDR_BITS + 3 : 6];

  Divider #(N) convert_divider_0(clk, clk_0);
  Divider #(N/2) convert_divider_1(clk, clk_1);
  Divider #(N/4) convert_divider_2(clk, clk_2);
  Divider #(N/16) convert_divider_3(clk, clk_3);
 endmodule

/*
SW[0]: 暂停、运行。=1, 运行；=0，暂停。
SW[1]: 复位。=1，归0；=0，正常运行。
SW[2]: 改变频率。上升沿时，频率=频率/2，有四种频率：1HZ, 0.5HZ, 0.25HZ, 0.125HZ，继续拨动会回调至1HZ
SW[5:3]: display_op[2:0]，显示内容控制
SW[15:6]: ram_display_addr[15:6]，显示信息的ram地址
*/
