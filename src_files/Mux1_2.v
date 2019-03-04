`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2019/03/04 20:39:12
// Design Name: 
// Module Name: MUX
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


module Mux1_2#(parameter DATA_BITS = 32)(mux_select,mux_data_in_0,mux_data_in_1,mux_data_out);
    input mux_select;
    input [DATA_BITS-1:0]mux_data_in_0;
    input [DATA_BITS-1:0]mux_data_in_1;
    output reg[DATA_BITS-1:0]mux_data_out;
        
    initial
    begin
        mux_data_out=0;
    end
    
    always@(*)
    begin
        if (mux_select)
            mux_data_out <= mux_data_in_1;
        else
            mux_data_out <= mux_data_in_0;
    end
    
    
endmodule
