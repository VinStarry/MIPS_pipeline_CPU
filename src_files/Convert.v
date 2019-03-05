`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2019/03/04 20:39:12
// Design Name: 
// Module Name: Convert
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


module Convert(clk,SW,clk_N,start,pause,rst,ram_display_addr,display_op);
    input clk;
    input [15:0]SW;
    output clk_N;
    output start;
    output pause;
    output rst;
    output [9:0]ram_display_addr;
    output [2:0]display_op;
    
    
    
endmodule
