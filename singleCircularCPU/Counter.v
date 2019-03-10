`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2019/03/04 20:39:12
// Design Name: 
// Module Name: Counter
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


module Counter(clk, rst, counter_enable, counter_data_out);
	parameter DATA_BITS = 32;
	input clk, rst, counter_enable;
	output reg[DATA_BITS-1:0] counter_data_out=0;


	always @(posedge clk or posedge rst) 
		begin
			if(rst)
				counter_data_out <= 0;
			else if(counter_enable)
				counter_data_out <= counter_data_out + 1;
		end
endmodule


