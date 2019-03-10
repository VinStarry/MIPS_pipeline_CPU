`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2019/03/10 17:58:31
// Design Name: 
// Module Name: EX_MEM
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


module EX_MEM(
    //input
    input clk,  //时钟信号
    input Enable,   //使能信号 为1的时候无效
    input rst,  //清0信号(产生气泡)
    input Effective_in,     //有效信息传递
    input [31:0]IR_in,      //IR传递
    input [31:0]PC_in,      //PC传递
    input Syscall_in,       //Syscall控制信号传递
    input JAL_in,           //JAL控制信号传递
    input RegWrite_in,      //RegWrite控制信号传递
    input MemToReg_in,      //MemToReg控制信号传递
    input MemWrite_in,      //MemWrite控制信号传递
    input [1:0]My_A_SIgnal_in,      //My_A_SIgnal控制信号传递(内存访问方式)
    input [31:0]Alu_Result_in,      //Alu计算结果数据传递
    input [31:0]R1_in,              //R1数据传输
    input [31:0]R2_in,              //R2数据传输
    input [4:0]Rd_no_in,            //Rd写回寄存器编号传输
    //output
    output reg Effective_out,
    output reg [31:0]IR_out,
    output reg [31:0]PC_out,
    output reg Syscall_out,
    output reg JAL_out,
    output reg RegWrite_out,
    output reg MemToReg_out,
    output reg MemWrite_out,
    output reg [1:0]My_A_SIgnal_out,
    output reg [31:0]Alu_Result_out,
    output reg [31:0]R1_out,
    output reg [31:0]R2_out,
    output reg [4:0]Rd_no_out

    );
   
    initial begin
    Effective_out=0;
    IR_out=0;
    PC_out=0;
    Syscall_out=0;
    JAL_out=0;
    RegWrite_out=0;
    MemToReg_out=0;
    MemWrite_out=0;
    My_A_SIgnal_out=0;
    Alu_Result_out=0;
    R1_out=0;
    R2_out=0;
    Rd_no_out=0;
    end
    
    
    always@ (posedge clk) begin
        if (!Enable && !rst) begin      //不产生气泡情况下使能端为0时传递信号
        Effective_out=Effective_in;
        IR_out=IR_in;
        PC_out=PC_in;
        Syscall_out=Syscall_in;
        JAL_out=JAL_in;
        RegWrite_out=RegWrite_in;
        MemToReg_out=MemToReg_in;
        MemWrite_out=MemWrite_in;
        My_A_SIgnal_out=My_A_SIgnal_in;
        Alu_Result_out=Alu_Result_in;
        R1_out=R1_in;
        R2_out=R2_in;
        Rd_no_out=Rd_no_in;
        end
        else if (rst) begin     //清0信号(产生气泡)
        Effective_out=0;
        IR_out=0;
        PC_out=0;
        Syscall_out=0;
        JAL_out=0;
        RegWrite_out=0;
        MemToReg_out=0;
        MemWrite_out=0;
        My_A_SIgnal_out=0;
        Alu_Result_out=0;
        R1_out=0;
        R2_out=0;
        Rd_no_out=0;
        end
    end
    
    
    
endmodule
