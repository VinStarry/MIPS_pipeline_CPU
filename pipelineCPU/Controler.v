`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// company: 
// engineer: 
// 
// create date: 2019/03/04 20:39:12
// design name: 
// module name: controler
// project name: 
// target devices: 
// tool versions: 
// description: 
// 
// dependencies: 
// 
// revision:
// revision 0.01 - file created
// additional comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module Controller(
	input[5:0] op,
	input[5:0] func,
	output beq,
	output bne,
	output mem_to_reg,
	output mem_write,
	output[3:0] alu_op,
	output alu_src_b,
	output reg_write,
	output reg_dst,
	output signed_ext,
	output jal,
	output jmp,
	output jr,
	output [1:0]my_A_signal,
	output syscall,
	output my_B_signal
    );
    
	assign my_B_signal = 0;	// reserved for change
	assign my_A_signal = 2'b00;	
	/* reserved for change, ramsel = 2'b00 --> 32-bit rw, 2'b01 --> 16-bit rw, 2'b11 --> 8-bit rw*/

    wire SLL, SRA, SRL, ADD, ADDU, SUB, AND, OR, NOR, SLT, SLTU, JR, SYSCALL;
	wire J, JAL, BEQ, BNE, ADDI, ADDIU, SLTI, ANDI, ORI, LW, SRAV, SLTIU, SW;
	wire S3, S2, S1, S0;

/* R-type */
	assign SLL = (op == 6'd0) & (func == 6'd0);
	assign SRA = (op == 6'd0) & (func == 6'd3);
	assign SRL = (op == 6'd0) & (func == 6'd2);
	assign ADD = (op == 6'd0) & (func == 6'd32);
	assign ADDU = (op == 6'd0) & (func == 6'd33);
	assign SUB = (op == 6'd0) & (func == 6'd34);
	assign AND = (op == 6'd0) & (func == 6'd36);
	assign OR = (op == 6'd0) & (func == 6'd37);
	assign NOR = (op == 6'd0) & (func == 6'd39);
	assign SLT = (op == 6'd0) & (func == 6'd42);
	assign SLTU = (op == 6'd0) & (func == 6'd43);
	assign JR = (op == 6'd0) & (func == 6'd8);
	assign SYSCALL = (op == 6'd0) & (func == 6'd12);

/* J-type */
	assign J = (op == 6'd2);

/* I-type */
	assign JAL = (op == 6'd3);
	assign BEQ = (op == 6'd4);
	assign BNE = (op == 6'd5);
	assign ADDI = (op == 6'd8);
	assign ANDI = (op == 6'd12);
	assign ADDIU = (op == 6'd9);
	assign SLTI = (op == 6'd10);
	assign ORI = (op == 6'd13);
	assign LW = (op == 6'd35);
	assign SW = (op == 6'd43);

/* Control points (output) */
	assign mem_to_reg = LW;
	assign mem_write = SW;

	assign alu_src_b = ADDI | ANDI | ADDIU | SLTI | ORI | LW | SW;
	assign reg_write = SLL | SRA | SRL | ADD | ADDU | SUB | AND | OR | NOR | SLT | SLTU | JAL | ADDI | ANDI | ADDIU | SLTI | ORI | LW;
	assign syscall = SYSCALL;
	assign signed_ext = BEQ | BNE | ADDI | SLTI | LW | SW;
	assign reg_dst = SLL | SRA | SRL | ADD | ADDU | SUB | AND | OR | NOR | SLT | SLTU ;
	assign beq = BEQ;
	assign bne = BNE;
	assign jr = JR;
	assign jmp = J;
	assign jal = JAL;

	assign S3 = OR | NOR | SLT | SLTU | SLTI | ORI;
	assign S2 = ADD | ADDU | SUB | AND | SLTU | ADDI | ANDI | ADDIU | LW | SW;
	assign S1 = SRL | SUB | AND | NOR | SLT | ANDI | SLTI;
	assign S0 = SRA | ADD | ADDU | AND | SLT | ADDI | ANDI | ADDIU | SLTI | LW | SW;
	assign alu_op = {S3,S2,S1,S0};
    
endmodule