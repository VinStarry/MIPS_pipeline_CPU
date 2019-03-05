`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2019/03/04 20:39:12
// Design Name: 
// Module Name: ROM
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


module ROM(rom_addr,rom_data_out);
    input [9:0] rom_addr;			    //指令地址
    output reg [31:0]rom_data_out;	    //机器指令值
    
    reg [31:0]data[1023: 0];            //寄存器值

    initial
    begin
        rom_data_out=0;
        $readmemh("code.hex",data,0,1<<9-1);
    end


    always @(rom_addr)
    begin
        rom_data_out <= data[rom_addr];
    end
    
endmodule
