`timescale 1ns / 1ps

module CorrelationDetec(
    input R1_Used,
    input R2_Used,
    input EX_RegWrite,
    input MEM_RegWrite,
    input [4:0]R1_no,
    input [4:0]R2_no,
    input [4:0]EX_WriteReg,
    input [4:0]MEM_WriteReg,
    output R1_EX_Related,
    output R1_MEM_Related,
    output R2_EX_Related,
    output R2_MEM_Related
    );
    assign R1_EX_Related = R1_Used && (~(R1_no==0)) && (EX_RegWrite && (R1_no==EX_WriteReg));
    assign R1_MEM_Related = R1_Used && (~(R1_no==0)) && (MEM_RegWrite && (R1_no==MEM_WriteReg));
    assign R2_EX_Related = R2_Used && (~(R2_no==0)) && (EX_RegWrite && (R2_no==EX_WriteReg));
    assign R2_MEM_Related = R2_Used && (~(R2_no==0)) && (MEM_RegWrite && (R2_no==MEM_WriteReg));
endmodule
