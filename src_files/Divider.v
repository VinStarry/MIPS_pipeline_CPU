`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2019/03/04 20:39:12
// Design Name: 
// Module Name: Divider
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

module Divider #(parameter N = 100_000_000)(
	input clk, 
	output reg clk_N
	);

reg [31:0] counter;

initial begin
    clk_N <= 0;
    counter <= 0;
end
          
always @(posedge clk)  begin 
    if (counter == N / 2 - 1)
    begin
        clk_N <= !clk_N;
        counter <= 0;
    end
    else 
    begin 
        counter <= counter + 1;
    end
end                           
endmodule
