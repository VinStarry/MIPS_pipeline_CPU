`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2019/02/26 08:44:51
// Design Name: 
// Module Name: BHT
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




module BHT(
    input clk,
    input rst,
    input [31:0]IF_PC,
    input [31:0]EX_PC,
    input [31:0]PC_des_in,
    input EX_Branch,
    input Branch_Success,
    
    output IF_PC_hit,
    output EX_PC_hit,
    output [31:0]PC_des_out,
    output Pred_Jump
    );
    
    
    wire[31:0] out0, out1, out2, out3, out4, out5, out6, out7;
    wire IF_hit0, IF_hit1, IF_hit2, IF_hit3, IF_hit4, IF_hit5, IF_hit6, IF_hit7;
    wire EX_hit0, EX_hit1, EX_hit2, EX_hit3, EX_hit4, EX_hit5, EX_hit6, EX_hit7;
    wire j0, j1, j2, j3, j4, j5, j6, j7;
    wire[15:0] l0, l1, l2, l3, l4, l5, l6, l7;
    

    //LRU
    wire[18:0] max0_0, max0_1, max0_2, max0_3, max1_0, max1_1, max2; //valid鍚堝苟姣旇緝
    assign max0_0 = (l0 > l1)? {3'h0, l0}:{3'h1, l1};
    assign max0_1 = (l2 > l3)? {3'h2, l2}:{3'h3, l3};
    assign max0_2 = (l4 > l5)? {3'h4, l4}:{3'h5, l5};
    assign max0_3 = (l6 > l7)? {3'h6, l6}:{3'h7, l7};

    assign max1_0 = (max0_0[15:0] > max0_1[15:0])? max0_0:max0_1;
    assign max1_1 = (max0_2[15:0] > max0_3[15:0])? max0_2:max0_3;

    assign max2 = (max1_0[15:0] > max1_1[15:0])? max1_0:max1_1;
    
    wire [7:0] WriteRow;
    reg [7:0] Wdecode;
    always@ (max2) begin
        case (max2[18:16])
            3'b000: Wdecode = 8'b00000001;
            3'b001: Wdecode = 8'b00000010;
            3'b010: Wdecode = 8'b00000100;
            3'b011: Wdecode = 8'b00001000;
            3'b100: Wdecode = 8'b00010000;
            3'b101: Wdecode = 8'b00100000;
            3'b110: Wdecode = 8'b01000000;
            3'b111: Wdecode = 8'b10000000;
            default: Wdecode = 8'b00000000;
        endcase
    end
    assign WriteRow = (!EX_PC_hit && EX_Branch) ? Wdecode : 0;
    
    
    //output
    assign IF_PC_hit = IF_hit0 | IF_hit1 | IF_hit2 | IF_hit3 | IF_hit4 | IF_hit5 | IF_hit6 | IF_hit7;
    assign EX_PC_hit = EX_hit0 | EX_hit1 | EX_hit2 | EX_hit3 | EX_hit4 | EX_hit5 | EX_hit6 | EX_hit7;
    assign PC_des_out = out0 | out1 | out2 | out3 | out4 | out5 | out6 | out7;
    assign Pred_Jump = j0 | j1 | j2 | j3 | j4 | j5 | j6 | j7;
    


    //BHT rows
    BHTRow row0(.clk(clk), .rst(rst), .WriteRow(WriteRow[0]), .EX_Branch(EX_Branch), .Branch_Success(Branch_Success),
        .IF_PC(IF_PC), .EX_PC(EX_PC), .data_in(PC_des_in), .data_out(out0), .count(l0), 
        .IF_PC_hit(IF_hit0), .EX_PC_hit(EX_hit0), .Pred_Jump(j0) );

    BHTRow row1(.clk(clk), .rst(rst), .WriteRow(WriteRow[1]), .EX_Branch(EX_Branch), .Branch_Success(Branch_Success),
        .IF_PC(IF_PC), .EX_PC(EX_PC), .data_in(PC_des_in), .data_out(out1), .count(l1), 
        .IF_PC_hit(IF_hit1), .EX_PC_hit(EX_hit1), .Pred_Jump(j1) );

    BHTRow row2(.clk(clk), .rst(rst), .WriteRow(WriteRow[2]), .EX_Branch(EX_Branch), .Branch_Success(Branch_Success),
        .IF_PC(IF_PC), .EX_PC(EX_PC), .data_in(PC_des_in), .data_out(out2), .count(l2), 
        .IF_PC_hit(IF_hit2), .EX_PC_hit(EX_hit2), .Pred_Jump(j2) );

    BHTRow row3(.clk(clk), .rst(rst), .WriteRow(WriteRow[3]), .EX_Branch(EX_Branch), .Branch_Success(Branch_Success),
        .IF_PC(IF_PC), .EX_PC(EX_PC), .data_in(PC_des_in), .data_out(out3), .count(l3), 
        .IF_PC_hit(IF_hit3), .EX_PC_hit(EX_hit3), .Pred_Jump(j3) );

    BHTRow row4(.clk(clk), .rst(rst), .WriteRow(WriteRow[4]), .EX_Branch(EX_Branch), .Branch_Success(Branch_Success),
        .IF_PC(IF_PC), .EX_PC(EX_PC), .data_in(PC_des_in), .data_out(out4), .count(l4), 
        .IF_PC_hit(IF_hit4), .EX_PC_hit(EX_hit4), .Pred_Jump(j4) );

    BHTRow row5(.clk(clk), .rst(rst), .WriteRow(WriteRow[5]), .EX_Branch(EX_Branch), .Branch_Success(Branch_Success),
        .IF_PC(IF_PC), .EX_PC(EX_PC), .data_in(PC_des_in), .data_out(out5), .count(l5), 
        .IF_PC_hit(IF_hit5), .EX_PC_hit(EX_hit5), .Pred_Jump(j5) );

    BHTRow row6(.clk(clk), .rst(rst), .WriteRow(WriteRow[6]), .EX_Branch(EX_Branch), .Branch_Success(Branch_Success),
        .IF_PC(IF_PC), .EX_PC(EX_PC), .data_in(PC_des_in), .data_out(out6), .count(l6), 
        .IF_PC_hit(IF_hit6), .EX_PC_hit(EX_hit6), .Pred_Jump(j6) );

    BHTRow row7(.clk(clk), .rst(rst), .WriteRow(WriteRow[7]), .EX_Branch(EX_Branch), .Branch_Success(Branch_Success),
        .IF_PC(IF_PC), .EX_PC(EX_PC), .data_in(PC_des_in), .data_out(out7), .count(l7), 
        .IF_PC_hit(IF_hit7), .EX_PC_hit(EX_hit7), .Pred_Jump(j7) );
    
    
    
endmodule

