`timescale 1ns / 1ps

module Register #(parameter DATA_BITS = 32)(clk, rst, reg_enable, reg_data_in, reg_data_out);
  input clk;                    				      //上升沿有效
  input rst;                    				      //为1时，清空为0
  input reg_enable;  							            //为1时，时钟有效，将reg_data_in存入寄存器中
  input [DATA_BITS - 1: 0] reg_data_in;			  //写入数据
  output reg [DATA_BITS - 1: 0] reg_data_out;	//读出数据
  reg [DATA_BITS - 1: 0] reg_data;				    //寄存器值

  initial
  begin
    reg_data <= 0;
  end

  always @(posedge clk)
  begin
  	if (rst == 1)
  	begin
  		reg_data <= 0;
  	end
  	else if (reg_enable == 1)
  	begin
  	  reg_data <= reg_data_in;
  	end
  end

  always @(*)
  begin
  	reg_data_out <= reg_data;
  end
endmodule
