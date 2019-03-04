`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2019/03/05 01:11:33
// Design Name: 
// Module Name: Mux2_4
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


module Mux2_4#(parameter DATA_BITS = 32)(mux_select,mux_data_in_0,mux_data_in_1,mux_data_in_2,mux_data_in_3,mux_data_out);
    input [1:0]mux_select;
    input [DATA_BITS-1:0]mux_data_in_0;
    input [DATA_BITS-1:0]mux_data_in_1;
    input [DATA_BITS-1:0]mux_data_in_2;
    input [DATA_BITS-1:0]mux_data_in_3;
    output reg[DATA_BITS-1:0]mux_data_out;
        
    initial
    begin
        mux_data_out=0;
    end
    
    always@(*)
    begin
        case(mux_select)
            2'b00:mux_data_out <= mux_data_in_0;
            2'b01:mux_data_out <= mux_data_in_1;
            2'b10:mux_data_out <= mux_data_in_2;
            2'b11:mux_data_out <= mux_data_in_3;
            default:mux_data_out <= 0;
        endcase
    end
    
endmodule
