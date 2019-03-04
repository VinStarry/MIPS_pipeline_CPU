`timescale 1ns / 1ps

module Extender 
#(  parameter BIT_WIDTH_IN=16,
    parameter BIT_WIDTH_OUT = 32,
    parameter TYPE=0
 )
(
    input [BIT_WIDTH_IN-1:0] ext_data_in,
    output [BIT_WIDTH_OUT-1:0] ext_data_out
); 
    assign ext_data_out = TYPE?$signed(ext_data_in):$unsigned(ext_data_in);
endmodule
