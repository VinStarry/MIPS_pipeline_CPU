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

    wire [BIT_WIDTH_OUT-1:0]signed_ext;
    wire [BIT_WIDTH_OUT-1:0]unsigned_ext;
    
    assign signed_ext=({{( BIT_WIDTH_OUT - BIT_WIDTH_IN){ ext_data_in[BIT_WIDTH_IN-1] } }, ext_data_in });
    assign unsigned_ext=({{( BIT_WIDTH_OUT - BIT_WIDTH_IN){ 1'b0 } }, ext_data_in });

    assign ext_data_out = TYPE?signed_ext:unsigned_ext;
    
endmodule
