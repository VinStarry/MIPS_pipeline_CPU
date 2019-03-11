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
    wire IF_Effective,ID_Effective,EX_Effective,MEM_Effective,WB_Effective;
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
    
    assign rom_addr=cur_pc[11:2];
    assign next_pc = cur_pc+4;
    assign Rst1=rst|con_if|uncon_if;
    assign Enable1=LoadUse|((~go)&HALT);
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
    wire EX_MemToReg;
    
    //ID_My_B_Signal ID_MemAccess
    wire SignedExt,RegDst;
    wire ID_RegWrite,ID_MemToReg,ID_MemWrite,ID_JMP,ID_JR,ID_Beq,ID_Bne,ID_My_B_Signal,ID_AluSrcB,ID_JAL,ID_Syscall;
    wire [1:0]ID_MemAccess;
    wire [3:0]ID_AluOP;
    
    wire [4:0]Dst_no,ID_RD_no,WB_RD_no;
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
                          ID_AluOP,ID_AluSrcB,ID_RegWrite,RegDst,SignedExt,ID_JAL,
                          ID_JMP,ID_JR,ID_MemAccess,ID_Syscall,ID_My_B_Signal);  
                          
    Mux1_2 #(5)selRS(ID_Syscall,RS,5'b00010,R1_no);
    Mux1_2 #(5)selRT(ID_Syscall,RT,5'b00100,R2_no);
    Mux1_2 #(5)selRD(RegDst,RT,RD,Dst_no);
    Mux1_2 #(5)selID_RD(ID_JAL,Dst_no,5'b11111,ID_RD_no);
    
    RegFile regfile(clk,R1_no, R2_no, WB_RD_no,ID_RegWrite,WB_RD_Data,ID_R1_Data,ID_R2_Data);
    
    Extender #(16,32,0)unsignedExt(Imm,unsignedImm);
    Extender #(16,32,1)signedExt(Imm,signedImm);
    
    Mux1_2 #(32)selExt(SignedExt,unsignedImm,signedImm,ID_Imm);
    
    
    assign LoadUse=EX_MemToReg&(R1_EX_Related|R2_EX_Related);
    assign ID_R1_Forward={R1_EX_Related,R1_MEM_Related};
    assign ID_R2_Forward={R2_EX_Related,R2_MEM_Related};
    assign Rst2=rst|con_if|uncon_if|LoadUse;
    assign Enable2=(~go)&HALT;
    
                                  
    /*EX:Execution stage*/
    wire EX_Syscall, EX_JAL, EX_MemWrite, EX_JR, EX_JMP, EX_Beq, EX_Bne, EX_AluSrcB, EX_My_B_Signal;
    wire [1:0] EX_MemAccess;
    wire [1:0] EX_R1_Forward;
    wire [1:0] EX_R2_Forward;
    wire [31:0] EX_R1_Data;
    wire [31:0] EX_R2_Data;
    wire [4:0] EX_RD_no;
    wire [31:0] EX_Imm;
    wire [4:0] EX_Shamt;
    wire [25:0] EX_J_Addr;
    wire [3:0] EX_AluOP;
    wire EX_Enable;
    
    wire [31:0]MEM_Redirect;
    wire [31:0]EX_Redirect;
    wire [31:0]EX_jump_addr_extend;
   
    wire [31:0]EX_alu_a_input;
    wire [31:0]EX_alu_b_input;
    wire [31:0]EX_alu_b_final_input;
    wire EX_alu_equal;
    wire [31:0]EX_alu_result1;
    wire [31:0]EX_alu_result2;

    Mux2_4 #(32)alu_src_a_mux(EX_R1_Forward, EX_R1_Data, MEM_Redirect, EX_Redirect, EX_Redirect, EX_alu_a_input);
    Mux2_4 #(32)alu_src_b_mux(EX_R2_Forward, EX_R2_Data, MEM_Redirect, EX_Redirect, EX_Redirect, EX_alu_b_input);
    Mux1_2 #(32)alu_src_b_final_mux(EX_AluSrcB, EX_alu_b_input, EX_Imm, EX_alu_b_final_input);
   
    ALU EX_alu(.alu_a_data(EX_alu_a_input), .alu_b_data(EX_alu_b_final_input), 
    .alu_op(EX_AluOP), .alu_shmat(EX_Shamt), .alu_equal(EX_alu_equal), .alu_result1(EX_alu_result1), .alu_result2(EX_alu_result2));
    
    assign con_if = (EX_Beq & EX_alu_equal) | (EX_Bne & (~EX_alu_equal)) /* | (B - instruction)*/;
    assign uncon_if = EX_JAL | EX_JR | EX_JMP;
    
    assign b_pc = (EX_Imm << 2) + EX_PC;  
    Extender #(26, 32, 0)j_addr_ext
            (.ext_data_in(EX_J_Addr), .ext_data_out(EX_jump_addr_extend));
    assign j_pc = EX_jump_addr_extend << 2;

    assign Enable3 = (~go) & HALT;
    assign Rst3 = rst;

    /*MEM:Access memory stage*/
    wire MEM_Syscall;
    wire MEM_JAL;
    wire MEM_MemWrite;
    wire MEM_MemToReg;
    wire [31:0]MEM_Alu_Result;
    wire [31:0]MEM_R1_data;
    wire [31:0]MEM_R2_data;
    wire [4:0]MEM_Rd_no;
    wire MEM_ram_sel;
    wire [1:0]MEM_MemAccess;
    
    assign ram_addr = MEM_Alu_Result[11:2];
    assign ram_data_in = MEM_R2_data;
    assign ram_sel = (MEM_MemAccess == 2'b00) ? (4'b1111) :
                         (MEM_MemAccess == 2'b01) ? (MEM_Alu_Result[1] ? 4'b0011 : 4'b1100) :
                         (MEM_MemAccess == 2'b10) ? (4'b0001 << MEM_Alu_Result[1:0])
                         : 4'b0000;
    assign ram_rw = MEM_MemWrite;
    assign ram_extend_type = 1'b0; // 0-extend
    
    Mux1_2 #(32)MEM_result(MEM_MemToReg, MEM_Alu_Result, ram_data_out, EX_Redirect);
    
    assign Enable4 = (~go) & HALT;
    assign Rst4 = rst;
    
    /*WB:Write back stage*/
    wire WB_Syscall,WB_JAL,WB_RegWrite;
    wire [31:0]WB_R1_Data,WB_R2_Data;
    
    Mux1_2 #(32)selWBData(WB_JAL,MEM_Redirect,WB_IR,WB_RD_Data);

    /*HALT & LED*/
    assign HALT=(~(WB_R1_Data==22))&(WB_Syscall);
    assign led_cpu_enable=(WB_R1_Data==22)&WB_Syscall;
    
    Register #(32)ledData(clk, rst, led_cpu_enable, WB_R2_Data, led_data_in);

    /*Count*/
    wire bubbleEnable;
    wire conifEnable;
    wire unconifEnable;
    wire totalEnable;
    
    assign bubbleEnable=LoadUse&(~HALT);
    assign conifEnable=con_if;
    assign unconifEnable=uncon_if;
    assign totalEnable=go|(~HALT);
    
    Counter totalCyclesNum(clk, rst, totalEnable, total_cycles);
    Counter bubbleNum(clk, rst, bubbleEnable, bubble_num);
    Counter condiBranchNum(clk, rst, conifEnable, condi_branch_num);
    Counter uncondiBranchNum(clk, rst, unconifEnable, uncondi_branch_num);

    /*Pipeline*/
    IF_ID if_id(clk,Enable1,Rst1,IF_Effective,IF_PC,IF_IR,ID_Effective,ID_PC,ID_IR);
    
    ID_EX id_ex(clk,Enable2,Rst2,
                ID_Effective,ID_PC,ID_IR,ID_Syscall,ID_JAL,ID_RegWrite,ID_MemToReg,ID_MemWrite,ID_JR,ID_JMP,
                ID_Beq,ID_Bne,ID_AluOP,ID_AluSrcB,ID_MemAccess,ID_My_B_Signal,ID_R1_Data,ID_R2_Data,
                ID_RD_no,ID_Imm,ID_Shamt,ID_J_Addr,ID_R1_Forward,ID_R2_Forward,
                EX_Effective,EX_PC,EX_IR,EX_Syscall,EX_JAL,EX_RegWrite,EX_MemToReg,EX_MemWrite,EX_JR,EX_JMP,
                EX_Beq,EX_Bne,EX_AluOP,EX_AluSrcB,EX_MemAccess,EX_My_B_Signal,EX_R1_Data,EX_R2_Data,
                EX_RD_no,EX_Imm,EX_Shamt,EX_J_Addr,EX_R1_Forward,EX_R2_Forward);
    
    EX_MEM ex_mem(clk, Enable3, Rst3,
                  EX_Effective, EX_IR, EX_PC, EX_Syscall, EX_JAL, EX_RegWrite, EX_MemToReg, EX_MemWrite,
                  EX_MemAccess, EX_alu_result1, EX_alu_a_input, EX_alu_b_input, EX_RD_no, 
                  MEM_Effective, MEM_IR, MEM_PC, MEM_Syscall, MEM_JAL, MEM_RegWrite, MEM_MemToReg, MEM_MemWrite,
                  MEM_MemAccess, MEM_Alu_Result, MEM_R1_data, MEM_R2_data, MEM_Rd_no);
    
    MEM_WB mem_wb(clk, Enable4, Rst4,
                  MEM_Effective, MEM_IR, MEM_PC, MEM_Syscall, MEM_JAL, MEM_RegWrite, EX_Redirect,
                  MEM_R1_data, MEM_R2_data, MEM_Rd_no, 
                  WB_Effective, WB_IR, WB_PC, WB_Syscall, WB_JAL, WB_RegWrite, MEM_Redirect, 
                  WB_R1_Data, WB_R2_Data, WB_RD_no);

endmodule