`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2019/02/25 15:26:22
// Design Name: 
// Module Name: ID_EX
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



// clk input   时钟信号
// Enable  input   使能信号 为1的时候无效
// rst input   清0信号(产生气泡)
// Effective_in    input   有效信息传递
// Effective_out   output  有效信息传递
// IR_in   input[31:0] IR传递
// IR_out  output[31:0]    IR传递
// PC_in   input[31:0] PC传递
// PC_out  output[31:0]    PC传递



module IF_ID(
	input clk,
	input Enable,
	input rst,
	input Effective_in,
	input [31:0]PC_in,
	input [31:0]IR_in,
	output reg [31:0]PC_out,
	output reg [31:0]IR_out,
	output reg Effective_out
	// input pre_jmp_in,
	// input hit_in,
	// output reg pre_jmp_out,
	// output reg hit_out
	);
	
	initial begin
		PC_out <= 0;
		IR_out <= 0;
		Effective_out <= 0;
		// pre_jmp_out <= 0;
		// hit_out <= 0;
		end
	
	
	always@ (posedge clk) begin
		if (!Enable && !rst) begin
			PC_out <= PC_in;
			IR_out <= IR_in;
			Effective_out <= Effective_in;
			// pre_jmp_out <= pre_jmp_in;
			// hit_out <= hit_in;
			end
		else if (!Enable && rst) begin
			PC_out <= 0;
			IR_out <= 0;
			Effective_out <= 0;
			// pre_jmp_out <= 0;
			// hit_out <= 0;
			end
	end
	   
endmodule