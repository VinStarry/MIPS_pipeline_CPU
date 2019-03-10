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



endmodule



