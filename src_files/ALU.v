`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2019/03/04 20:39:12
// Design Name: 
// Module Name: ALU
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


module ALU(
	input[31:0] alu_a_data,
	input[31:0] alu_b_data,
	input[3:0] alu_op,
	input[4:0] alu_shmat,
	output alu_equal,
	output reg[31:0] alu_result1,
	output reg[31:0] alu_result2
    );

assign alu_equal = ((alu_a_data == alu_b_data) ? 1 :0);

always @(alu_a_data or alu_b_data or alu_op or alu_shmat)
begin
case(alu_op[3:0])
	4'b0000: 
	/* alu_op == 0, logical shift left, tested */
	begin
		alu_result1 = alu_b_data << alu_shmat;
		alu_result2 = 0;
	end
 	4'b0001: 
 	/* alu_op == 1, arithmetic shift right, tested */
 	begin
 		alu_result1 = (($signed(alu_b_data)) >>> alu_shmat);
 		alu_result2 = 0;
 	end
 	4'b0010:
 	/* alu_op == 2, logical shift right, tested */
	begin
		alu_result1 = alu_b_data >> alu_shmat;
		alu_result2 = 0;
	end 
 	4'b0011:
 	/* alu_op == 3, unsigned multiply, tested */
	begin
		{alu_result2, alu_result1} = alu_a_data * alu_b_data;
	end 
	4'b0100:
 	/* alu_op == 4, unsigned dividison, tested */
	begin
<<<<<<< HEAD
		alu_result1 = $unsigned(alu_a_data) / $unsigned(alu_b_data);
		alu_result2 = $unsigned(alu_a_data) % $unsigned(alu_b_data);
=======
		alu_result1 <= (alu_a_data) / (alu_b_data);
		alu_result2 <= (alu_a_data) % (alu_b_data);
>>>>>>> 60e9299e5cd03edac40d2b732ad370a7970e4905
	end
 	4'b0101: 
 	/* alu_op == 5, Addition */
	begin
		alu_result1 = alu_a_data + alu_b_data;
		alu_result2 = 0;
	end 
 	4'b0110:
 	/* alu_op == 6, subtraction */
	begin
		alu_result1 = alu_a_data - alu_b_data;
		alu_result2 = 0;
	end 
 	4'b0111:
 	/* alu_op == 7, bit and */
	begin
		alu_result1 = alu_a_data & alu_b_data;
		alu_result2 = 0;
	end 
 	4'b1000:
 	/* alu_op == 8, bit or */
	begin
		alu_result1 = alu_a_data | alu_b_data;
		alu_result2 = 0;
	end 
 	4'b1001:
 	/* alu_op == 9, bit exclusive or */
	begin
		alu_result1 = alu_a_data ^ alu_b_data;
		alu_result2 = 0;
	end 
 	4'b1010:
 	/* alu_op == 10, bit negative or */
	begin
		alu_result1 = ~(alu_a_data | alu_b_data);
		alu_result2 = 0;
	end 
 	4'b1011:
 	/* alu_op == 11, signed comparison, tested */
	begin
	alu_result1 = ($signed(alu_a_data) < $signed(alu_b_data)) ? 1 : 0;
    alu_result2 = 0;
	end 
 	4'b1100:
 	/* alu_op == 12, unsigned comparison, tested */
	begin
		alu_result1 = (alu_a_data < alu_b_data) ? 1 : 0;
		alu_result2 = 0;
	end 
 	default:  
 	begin
 		alu_result1 = 0;
 		alu_result2 = 0;
 	end
endcase
end


endmodule
