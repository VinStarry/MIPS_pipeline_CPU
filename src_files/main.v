`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2019/03/04 20:39:12
// Design Name: 
// Module Name: main
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


module main(clk,SW,SEG,AN);
    input clk;
    input [15:0]SW;
    output [7:0]SEG;
    output [7:0]AN;
    
    wire clk_N;
    wire start,pause,rst;
    wire ram_rw,led_cpu_enable;
    wire [2:0]display_op;
    wire [3:0]ram_sel;
    wire [9:0]rom_addr;
    wire [9:0]ram_addr;
    wire [9:0]ram_display_addr;
    wire [31:0]ram_data_in;
    wire [31:0]rom_data_out;
    wire [31:0]ram_data_out;
    wire [31:0]ram_display_data_out;
    wire [31:0]total_cycles;
    wire [31:0]uncondi_branch_num;
    wire [31:0]condi_branch_num;
    wire [31:0]led_data_in;
    
    
    
    Convert convert(.clk(clk),.SW(SW),.clk_N(clk_N),.start(start),.pause(pause),.rst(rst),
                    .ram_display_addr(ram_display_addr),.display_op(display_op));
    
    
    CPU cpu(.clk(clk_N), .rst(rst), .pause(pause), 
            .rom_data_out(rom_data_out), .ram_data_out(ram_data_out), .rom_addr(rom_addr), 
            .ram_addr(ram_addr),.ram_data_in(ram_data_in), .ram_sel(ram_sel), .ram_rw(ram_rw), 
			.total_cycles(total_cycles), .uncondi_branch_num(uncondi_branch_num), .condi_branch_num(condi_branch_num), 
			.led_cpu_enable(led_cpu_enable),.led_data_in(led_data_in));

    ROM rom(.rom_addr(rom_addr),.rom_data_out(rom_data_out));
    
    
    RAM ram(.clk(clk_N),.rst(rst),.ram_rw(ram_rw),
            .ram_sel(ram_sel),.ram_addr(ram_addr),.ram_data_in(ram_data_in),
            .ram_data_out(ram_data_out),.ram_display_addr(ram_display_addr),.ram_display_data_out(ram_display_data_out));
  
    
    LED led(.clk(clk),.led_cpu_enable(led_cpu_enable),.display_op(display_op),
            .led_data_in(led_data_in),.total_cycles(total_cycles),.uncondi_branch_num(uncondi_branch_num),
            .condi_branch_num(condi_branch_num),.ram_display_data_out(ram_display_data_out),
            .SEG(SEG),.AN(AN));
    
endmodule
