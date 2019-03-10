`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2019/03/04 20:39:12
// Design Name: 
// Module Name: CPU
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

/*
input:
clk	input	
rst	input	
go	input	
rom_data_out	input[31:0]	
ram_data_out	input[31:0]

<<<<<<< HEAD
output:
rom_addr	output[9:0]	
ram_addr	output[9:0]	
ram_data_in	output[31:0]	
ram_sel	output[3:0]	
ram_rw	output	
total_cycles	output[31:0]	
uncondi_branch_num	output[31:0]	
condi_branch_num	output[31:0]	
led_data_in	output[31:0]	
led_cpu_enable 
*/

 //attention: ram_addr [11:0]


 //my_B_signal :bgez

module CPU#(parameter ADDR_BITS=12)(clk, rst, go, rom_data_out, ram_data_out, rom_addr, ram_addr,
            ram_data_in, ram_sel, ram_rw, ram_extend_type, total_cycles, uncondi_branch_num, condi_branch_num, bubble_num, led_data_in, led_cpu_enable);
	input clk, rst, go;
	input [31:0]rom_data_out;
	input [31:0]ram_data_out;
	output [9:0]rom_addr;
	output [ADDR_BITS-3:0]ram_addr;
	output [31:0]ram_data_in;
	output [31:0]total_cycles;
	output [31:0]condi_branch_num;
    output [31:0]uncondi_branch_num;
    output [31:0]bubble_num;
	output [31:0]led_data_in;
	output [3:0]ram_sel; 
	output ram_rw, ram_extend_type ,led_cpu_enable;

    /*wire*/
    wire JR;
    wire HALT;
    wire LoadUse;
    wire con_if,uncon_if;
    wire pc_enable;
    wire [1:0]pc_select;
    wire [31:0]next_pc,b_pc,j_pc,jr_pc,right_pc,cur_pc;
    wire rst1,rst2,rst3,rst4;
    wire enable1,enable2,enable3,enable4;
    wire effective1,effective2,effective3,effective4;
    wire [31:0]IR1,IR2,IR3,IR4;
    wire [31:0]PC1,PC2,PC3,PC4;
        
    
    /*ID:Instruction fetch stage*/
    assign pc_select = {uncon_if,{con_if|JR}};
    assign pc_enable = (~LoadUse)&(go|(~HALT));
    
    Mux2_4 #(32)pc_mux(pc_select,next_pc,b_pc,j_pc,jr_pc,right_pc);                                                                                                                    
    
    Register #(32)PC(clk, rst, pc_enable, right_pc, cur_pc);
    
    assign rom_data_out = cur_pc[11:2];
    assign next_pc = cur_pc+8'h00000004;
    assign rst1=rst|con_if|uncon_if;
    assign enable1=HALT|LoadUse;
    
    
    IF_ID if_id(clk,enable1,rst,1'b1,effective1,effective2,rom_data_out,IR1,next_pc,PC1);
    
    
    /*IF:Instruction decoding stage*/
    wire [5:0]OP;
    wire [5:0]Func;
    wire [4:0]RS,RT,RD,ID_Shamt,R1_no,R2_no;
    wire [15:0]Imm;
    wire [15:0]J_Addr;
    wire R1_Used,R2_Used;
    wire EX_RegWrite,MEM_RegWrite;
    wire [4:0]EX_WriteReg,MEM_WriteReg;
    wire R1_EX_Related,R2_EX_Related,R1_MEM_Related,R2_MEM_Related;
    wire EX_MemTOReg;
    wire SignedExt,RegDst;
    wire ID_RegWrite,ID_MemToReg,ID_MemWrite,ID_JMP,ID_JR,ID_Beq,ID_Bne,ID_JAL,ID_AluSrcB,ID_Syscall;
    wire [1:0]ID_My_A_Signal;
    wire [3:0]ID_AluOP;
    
    assign OP=IR1[31:26];
    assign Func=IR1[5:0];
    assign RS=IR1[25:21];
    assign RT=IR1[20:16];
    assign RD=IR1[15:11];
    assign Imm=IR1[15:0];
    assign J_Addr=IR1[25:0];
    
    RegisterUsage usage(OP,Func,R1_Used,R2_Used);
    CorrelationDetec detec(R1_Used,R2_Used,EX_RegWrite,MEM_RegWrite,R1_no,R2_no,EX_WriteReg,MEM_WriteReg,
                           R1_EX_Related,R1_MEM_Related,R2_EX_Related,R2_MEM_Related);
    
    assign LoadUse=EX.MemToReg&(R1_EX_Related|R2_EX_Related);
    
                                                             
                                                             
    /*EX:Execution stage*/



    /*MEM:Access memory stage*/


    
    /*WB:Write back stage*/


    


endmodule



