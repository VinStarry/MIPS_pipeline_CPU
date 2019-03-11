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
    wire Rst1,Rst2,Rst3,Rst4;
    wire Enable1,Enable2,Enable3,Enable4;
    wire IF_Effective,ID_Effective,EX_Effective,MEM_Effective;
    wire [31:0]IF_IR,ID_IR,EX_IR,MEM_IR,WB_IR;
    wire [31:0]IF_PC,ID_PC,EX_PC,MEM_PC,WB_PC;
    
    
    /*IF:Instruction decoding stage*/
    wire pc_enable;
    wire [1:0]pc_select;
    wire [31:0]next_pc,b_pc,j_pc,jr_pc,right_pc,cur_pc;
    
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
    wire [1:0]ID_R1_Forward,ID_R2_Forward;
    wire [31:0]ID_R1_Data,ID_R2_Data,WB_RD_Data;
    
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
       
    Controller controller(OP,Func,ID_Beq,ID_Bne,ID_MemToReg,ID_MemWrite,
                          ID_AluOP,ID_RegWrite,RegDst,SignedExt,ID_JAL,
                          ID_JMP,ID_JR,ID_MemAccess,ID_Syscall,ID_My_B_Signal);  
                          
    Mux1_2 #(5)selRS(ID_Syscall,RS,5'b00010,R1_no);
    Mux1_2 #(5)selRT(ID_Syscall,RT,5'b00100,R2_no);
    Mux1_2 #(5)selRD(RegDst,RT,RD,Dst_no);
    Mux1_2 #(5)selID_RD(ID_JAL,Dst_no,5'b11111,ID_RD_no);
    
    RegFile regfile(clk,R1_no, R2_no, WB_RD_no,ID_RegWrite,WB_RD_Data,ID_R1_Data,ID_R2_Data);
    
    Extender #(16,32,0)unsignedExt(Imm,unsignedImm);
    Extender #(16,32,1)signedExt(Imm,signedImm);
    
    Mux1_2 #(32)(SignedExt,unsignedImm,signedImm,ID_Imm);
    
    
    assign LoadUse=EX.MemToReg&(R1_EX_Related|R2_EX_Related);
    assign ID_R1_Forward={R1_EX_Related,R1_MEM_Related};
    assign ID_R2_Forward={R2_EX_Related,R2_MEM_Related};
    assign Rst2=rst|con_if|uncon_if|LoadUse;
    assign Enable2=(~go)&HALT;
    
                                  
    /*EX:Execution stage*/



    /*MEM:Access memory stage*/


    
    /*WB:Write back stage*/


    /*Pipeline*/
    IF_ID if_id(clk,Enable1,Rst1,IF_Effective,IF_PC,IF_IR,ID_Effective,ID_PC,ID_IR);
    
    ID_EX id_ex(clk,Enable2,Rst2,
                ID_Effective,ID_PC,ID_IR,ID_Syscall,ID_JAL,ID_RegWrite,ID_MemToReg,ID_MemWrite,ID_JR,ID_JMP,
                ID_Beq,ID_Bne,ID_AluOP,ID_AluSrcB,ID_MemAccess,ID_My_B_Signal,ID_R1_Data,ID_R2_Data,
                ID_RD_no,ID_Imm,ID_Shamt,ID_J_Addr,ID_R1_Forward,ID_R2_Forward,
                EX_Effective,EX_PC,EX_IR,EX_Syscall,EX_JAL,EX_RegWrite,EX_MemToReg,EX_MemWrite,EX_JR,EX_JMP,
                EX_Beq,EX_Bne,EX_AluOP,EX_AluSrcB,EX_MemAccess,EX_My_B_Signal,EX_R1_Data,EX_R2_Data,
                EX_RD_no,EX_Imm,EX_Shamt,EX_J_Addr,EX_R1_Forward,EX_R2_Forward);
    


endmodule