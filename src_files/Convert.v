`timescale 1ns / 1ps
module Convert(clk, SW, clk_N, go, rst, ram_display_addr, display_op);
  input clk;				//时钟信号输入
  input [15:0] SW;			//按键输入
  output clk_N;				//分频后的时钟
  output go;				//暂停、运行
  output rst;				//为1时，复位
  output [9:0] ram_display_addr;		//ram地址
  output [2:0] display_op;				//显示内容控制信号
  
  integer N = 100000000;		//分频频率
  integer i = 0;

  assign go = SW[0];
  assign rst = SW[1];

  always @(posedge SW[2])
  begin
    i = i + 1;
    if (i % 4 == 0) 
    begin
      N = 100000000;
    end
    else
    begin
      N = N / 2;
    end
  end

  assign display_op[2 : 0] = SW[5: 3];
  assign ram_display_addr[9 : 0] = SW[15 : 6];

  Divider #(N) convert_divider(clk, clk_N);
 endmodule
/*
SW[0]: 暂停、运行。=1, 运行；=0，暂停。
SW[1]: 复位。=1，归0；=0，正常运行。
SW[2]: 改变频率。上升沿时，频率=频率/2，有四种频率：1HZ, 0.5HZ, 0.25HZ, 0.125HZ，继续拨动会回调至1HZ
SW[5:3]: display_op[2:0]，显示内容控制
SW[15:6]: ram_display_addr[15:6]，显示信息的ram地址
*/
