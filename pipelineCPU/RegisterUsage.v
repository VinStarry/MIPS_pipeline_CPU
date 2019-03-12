`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2019/03/10 17:58:31
// Design Name: 
// Module Name: RegisterUsage
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



module RegisterUsage(
	input [5:0]OP,
	input [5:0]Func,
	output R1_Used,
	output R2_Used);
	
	//可根据附加指令添加
	assign R1_Used = (OP == 0)? (Func == 8 || Func == 12 || Func == 32 || Func == 33 || Func == 34 ||
                                 Func == 36 || Func == 37 || Func == 39 || Func == 42 || Func == 43 || Func == 35):
                    (OP == 4 || OP == 5 || OP == 8 || OP == 12 || OP == 9 || OP == 10 || OP == 13 || OP == 35 || OP == 43 || OP == 14 || OP==33 || OP == 1);
    
    assign R2_Used = (OP == 0)? (Func == 0 || Func == 2 || Func == 3 || Func == 32 || Func == 33 || Func == 34 ||
                                 Func == 36 || Func == 37 || Func == 39 || Func == 42 || Func == 43 || Func == 12 || Func == 35):         
                     (OP == 4 || OP == 5 || OP == 43 || OP == 1);
	
endmodule
