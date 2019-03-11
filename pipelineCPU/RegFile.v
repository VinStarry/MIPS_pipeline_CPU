`timescale 1ns / 1ps
module RegFile(clk, reg1_no, reg2_no, reg_no_in,
reg_write, reg_data_in, reg1_data, reg2_data);
  input clk;                    //时钟信号，上升沿有效
  input [4:0] reg1_no;          //第一个读寄存器的编号
  input [4:0] reg2_no;          //第二个读寄存器的编号
  input [4:0] reg_no_in;        //写入寄存器编号
  input reg_write;              //写使能信号，为1时，在上升沿，将reg_data_in写入reg_no_in
  input [31:0] reg_data_in;     //写入数据
  output reg [31:0] reg1_data = 0;  //R1寄存器值
  output reg [31:0] reg2_data = 0;  //R2寄存器值

  reg [31:0] register [31:0];   //寄存器堆
  integer i;

  initial
  begin
    for (i = 0; i <= 5'b11111; i = i + 1)
    begin
      register[i] <= 0;
    end
  end


  always @(negedge clk)       //写使能，上升沿，非0号寄存器
  begin
    if (reg_write == 1 && reg_no_in != 0)
    begin
      register[reg_no_in] <= reg_data_in;
    end
  end
  
  always @(*)
  begin
    reg1_data <= register[reg1_no];
    reg2_data <= register[reg2_no];
  end

endmodule
