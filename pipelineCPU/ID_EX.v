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


module ID_EX(
    input clk,
    input Enable,
    input rst,
    input Effective_in,
    input [31:0]PC_in,
    input [31:0]IR_in,
    input Syscall_in,
    input JAL_in,
    input RegWrite_in,
    input MemToReg_in,
    input MemWrite_in,
    input JR_in,
    input JMP_in,
    input Beq_in,
    input Bne_in,
    input [3:0]AluOP_in,
    input AluSrcB_in,
    input [1:0]My_A_Signal_in,
    input My_B_Signal_in,
    input [31:0]R1_in,
    input [31:0]R2_in,
    input [4:0]Rd_no_in,
    input [31:0]Imm_in,
    input [4:0]Shamt_in,
    input [25:0]J_Addr_in,
    input[1:0] R1_forward_in,
    input[1:0] R2_forward_in,	
    // input pre_jmp_in,
    // input hit_in,
    
    /* output */
    output reg Effective_out,
    output reg [31:0]PC_out,
    output reg [31:0]IR_out,
    output reg Syscall_out,
    output reg JAL_out,
    output reg RegWrite_out,
    output reg MemToReg_out,
    output reg MemWrite_out,
    output reg JR_out,
    output reg JMP_out,
    output reg Beq_out,
    output reg Bne_out,
    output reg [3:0]AluOP_out,
    output reg AluSrcB_out,
    output reg [1:0]My_A_Signal_out,
    output reg My_B_Signal_out,
    output reg [31:0]R1_out,
    output reg [31:0]R2_out,
    output reg [4:0]Rd_no_out,
    output reg [31:0]Imm_out,
    output reg [4:0]Shamt_out,
    output reg [25:0]J_Addr_out,
    output reg [1:0]R1_forward_out,	
    output reg [1:0]R2_forward_out
    // output reg pre_jmp_out,
    // output reg hit_out

    );
    
    initial begin
        PC_out <= 0;
        IR_out <= 0;
        Effective_out <= 0;
        Syscall_out <= 0;
   		JAL_out <= 0;
    	RegWrite_out <= 0;
    	MemToReg_out <= 0;
    	MemWrite_out <= 0;
    	JR_out <= 0;
    	JMP_out <= 0;
    	Beq_out <= 0;
    	Bne_out <= 0;
    	AluOP_out <= 0;
    	AluSrcB_out <= 0;
    	My_A_Signal_out <= 0;
   	    My_B_Signal_out <= 0;
    	R1_out <= 0;
    	R2_out <= 0;
    	Rd_no_out <= 0;
    	Imm_out <= 0;
   	    Shamt_out <= 0;
    	J_Addr_out <= 0;
    	R1_forward_out <= 0;
    	R2_forward_out <= 0;
        // pre_jmp_out <= 0;
        // hit_out <= 0;
        end
    
    
    always@ (posedge clk) begin
        if (!Enable && !rst) begin
            PC_out <= PC_in;
            IR_out <= IR_in;
            Effective_out <= Effective_in;
            Syscall_out <= Syscall_in;
   			JAL_out <= JAL_in;
    		RegWrite_out <= RegWrite_in;
    		MemToReg_out <= MemToReg_in;
    		MemWrite_out <= MemWrite_in;
    		JR_out <= JR_in;
    		JMP_out <= JMP_in;
    		Beq_out <= Beq_in;
    		Bne_out <= Bne_in;
    		AluOP_out <= AluOP_in;
    		AluSrcB_out <= AluSrcB_in;
    		My_A_Signal_out <= My_A_Signal_in;
   	    	My_B_Signal_out <= My_B_Signal_in;
    		R1_out <= R1_in;
    		R2_out <= R2_in;
    		Rd_no_out <= Rd_no_in;
    		Imm_out <= Imm_in;
   	    	Shamt_out <= Shamt_in;
    		J_Addr_out <= J_Addr_in;	
    		R1_forward_out <= R1_forward_in;
    		R2_forward_out <= R2_forward_in;
            // pre_jmp_out <= pre_jmp_in;
            // hit_out <= hit_in;
            end
        else if (!Enable && rst) begin
            PC_out <= 0;
            IR_out <= 0;
            Effective_out <= 0;
            Syscall_out <= 0;
   			JAL_out <= 0;
    		RegWrite_out <= 0;
    		MemToReg_out <= 0;
    		MemWrite_out <= 0;
    		JR_out <= 0;
    		JMP_out <= 0;
    		Beq_out <= 0;
         	Bne_out <= 0;
    		AluOP_out <= 0;
    		AluSrcB_out <= 0;
    		My_A_Signal_out <= 0;
   	    	My_B_Signal_out <= 0;
    		R1_out <= 0;
    		R2_out <= 0;
    		Rd_no_out <= 0;
    		Imm_out <= 0;
   	    	Shamt_out <= 0;
    		J_Addr_out <= 0;
    		R1_forward_out <= 0;
    		R2_forward_out <= 0;
            // pre_jmp_out <= 0;
            // hit_out <= 0;
            end
    	end
    
    
    
endmodule
