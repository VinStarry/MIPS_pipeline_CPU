`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2019/03/04 20:39:12
// Design Name: 
// Module Name: RAM
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


module RAM(clk,rst,ram_rw,ram_sel,ram_addr,ram_data_in,ram_data_out,ram_display_addr,ram_display_data_out);
    input clk,rst,ram_rw;
    input [3:0]ram_sel;
    input [9:0]ram_addr;
    input [31:0]ram_data_in;
    output reg [31:0]ram_data_out;
    input [9:0]ram_display_addr;
    output reg [31:0]ram_display_data_out;
    
    integer i;
    reg [31:0]data[(1<<10)-1:0];
    
    initial
    begin
        ram_data_out=0;
        ram_display_data_out=0;
        for (i=0;i<(1<<12-1);i=i+1)
        begin
            data[i]=0;
        end
    end
    
    always@(posedge clk or posedge rst)
    begin
        if (rst)
        begin
            for (i=0;i<(1<<12-1);i=i+1)
            begin
                data[i]<=0;
            end
        end
        else
        begin
            if (ram_rw)
            begin
                data[ram_addr][7:0]<=ram_sel[0]?ram_data_in[7:0]:data[ram_addr][7:0];
                data[ram_addr][15:8]<=ram_sel[1]?ram_data_in[15:8]:data[ram_addr][15:8];
                data[ram_addr][23:16]<=ram_sel[2]?ram_data_in[23:16]:data[ram_addr][23:16];
                data[ram_addr][31:24]<=ram_sel[3]?ram_data_in[31:24]:data[ram_addr][31:24];
            end
            else
            begin
                case(ram_sel[3:0])
                    4'b0000:ram_data_out<=0;
                    4'b0001:ram_data_out<={24'b0,data[ram_addr][7:0]};
                    4'b0010:ram_data_out<={24'b0,data[ram_addr][15:8]};
                    4'b0100:ram_data_out<={24'b0,data[ram_addr][23:16]};
                    4'b1000:ram_data_out<={24'b0,data[ram_addr][31:24]};
                    4'b0011:ram_data_out<={16'b0,data[ram_addr][15:0]};
                    4'b1100:ram_data_out<={16'b0,data[ram_addr][31:16]};
                    4'b1111:ram_data_out<=data[ram_addr];
                    default:ram_data_out<=0;
                endcase
            end
            ram_display_data_out<=data[ram_display_addr];
        end
    end
    
endmodule
