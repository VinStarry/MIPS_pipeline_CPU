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
	reg[DATA_BITS-1:0] counter_reg;
	output[DATA_BITS-1:0] counter_data_out;

	initial 
		begin
			counter_reg <= 0;
		end

	always @(posedge clk) 
		begin
			if(rst)
				counter_reg <= 0;
			else if(counter_enable)
				counter_reg <= counter_reg + 1;
            	counter_data_out <= counter_reg;
		end
endmodule


