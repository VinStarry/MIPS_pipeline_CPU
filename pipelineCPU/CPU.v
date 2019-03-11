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
    wire Rst1,Rst2,Rst3,Rst4;
    wire Enable1,Enable2,Enable3,Enable4;
    wire IF_Effective,ID_Effective,EX_Effective,MEM_Effective;
    wire [31:0]IF_IR,ID_IR,EX_IR,MEM_IR,WB_IR;
    wire [31:0]IF_PC,ID_PC,EX_PC,MEM_PC,WB_PC;
    
    
    /*IF:Instruction decoding stage*/
    /*ID:Instruction fetch stage*/
    assign pc_select = {uncon_if,{con_if|JR}};
    assign pc_enable = (~LoadUse)&(go|(~HALT));
    
    Mux2_4 #(32)pc_mux(pc_select,next_pc,b_pc,j_pc,jr_pc,right_pc);                                                                                                                    
    
    Register #(32)PC(clk, rst, pc_enable, right_pc, cur_pc);
    
    assign rom_data_out = cur_pc[11:2];
    assign next_pc = cur_pc+8'h00000004;
    assign Rst1=rst|con_if|uncon_if;
    assign Enable1=HALT|LoadUse;
    assign IF_Effective=1'b1;
    assign IF_PC=next_pc;
    assign IF_IR=rom_data_out;
    
    IF_ID if_id(clk,Enable1,Rst1,IF_Effective,IF_PC,IF_IR,ID_Effective,ID_PC,ID_IR);
    
    
    /*ID:Instruction fetch stage*/
    wire [5:0]OP;
    wire [5:0]Func;
    wire [4:0]RS,RT,RD,ID_Shamt,R1_no,R2_no;
    wire [15:0]Imm;
    wire [25:0]ID_J_Addr;
    
    wire R1_Used,R2_Used;
    wire EX_RegWrite,MEM_RegWrite;
    wire [4:0]EX_WriteReg,MEM_WriteReg;
    wire R1_EX_Related,R2_EX_Related,R1_MEM_Related,R2_MEM_Related;
    wire EX_MemTOReg;
    
    //ID_My_B_Signal ID_MemAccess
    wire SignedExt,RegDst;
    wire ID_RegWrite,ID_MemToReg,ID_MemWrite,ID_JMP,ID_JR,ID_Beq,ID_Bne,ID_My_B_Signal,ID_AluSrcB,ID_JAL,ID_Syscall;
    wire [1:0]ID_MemAccess;
    wire [3:0]ID_AluOP;
    
    wire [5:0]Dst_no,ID_RD_no,WB_RD_no;
    wire [31:0]signedImm,unsignedImm,ID_Imm;
    
    assign OP=ID_IR[31:26];
    assign Func=ID_IR[5:0];
    assign RS=ID_IR[25:21];
    assign RT=ID_IR[20:16];
    assign RD=ID_IR[15:11];
    assign Imm=ID_IR[15:0];
    assign ID_Shamt=ID_IR[10:6];
    assign ID_J_Addr=ID_IR[25:0];
    
    RegisterUsage usage(OP,Func,R1_Used,R2_Used);
    CorrelationDetec detec(R1_Used,R2_Used,EX_RegWrite,MEM_RegWrite,R1_no,R2_no,EX_WriteReg,MEM_WriteReg,
                           R1_EX_Related,R1_MEM_Related,R2_EX_Related,R2_MEM_Related);
    
    assign LoadUse=EX.MemToReg&(R1_EX_Related|R2_EX_Related);
    
                                                             
                                                             
    /*EX:Execution stage*/



    /*MEM:Access memory stage*/


    
    /*WB:Write back stage*/


    


endmodule