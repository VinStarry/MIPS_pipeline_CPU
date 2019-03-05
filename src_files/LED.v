`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2019/03/04 20:39:12
// Design Name: 
// Module Name: LED
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


module LED(
    input clk,  //系统时钟周期
    input led_cpu_enable,   //syscall 34信号，高电平有效
    input [2:0] display_op,     //显示内容控制信号
    input [31:0] led_data_in,   //程序显示内容
    input [31:0] total_cycles,  //总周期数
    input [31:0] uncondi_branch_num,    //无条件周期数
    input [31:0] condi_branch_num,  //有条件分支数
    input [31:0] ram_display_data_out,  //内存数据输出
    output reg [7:0] SEG,   //选择显示输出
    output reg [7:0] AN     //显示内容输出
    );

    wire clk_p;     //分频为100hz
    reg [3:0] seg_cnt = 0;
    reg [31:0] cnt = 0;
    reg [31:0] data = 0;
    wire [31:0] total_cycles_bcd;   //总周期数的bcd码
    wire [31:0] uncondi_branch_num_bcd; //无条件周期数的bcd码
    wire [31:0] condi_branch_num_bcd;   //有条件分支数的bcd码
    
    Divider #(10_000_000) d1(clk,clk_p); //分频为100hz
    Bcd b1(total_cycles,total_cycles_bcd);  //总周期数bcd模块
    Bcd b2(uncondi_branch_num,uncondi_branch_num_bcd);  //无条件周期数bcd模块
    Bcd b3(condi_branch_num,condi_branch_num_bcd);  //有条件分支数bcd模块
    always@(posedge clk_p)
        begin
        cnt = cnt + 1;
        if(cnt == 8) cnt = 0;

        
        case(display_op)
                3'b000: 
                begin
                if(led_cpu_enable == 0) data <= led_data_in;
                end
                
                3'b001: data <= total_cycles_bcd;
                
                3'b011: data <= uncondi_branch_num_bcd;
 
                3'b101: data <= condi_branch_num_bcd;

                3'b010: data <= ram_display_data_out;
                
                default:data <= 0;
                endcase
        end
     
    always@(cnt) //
    begin
    case (cnt)
                    
                    3'h0: seg_cnt <= data[3:0]; 
                    
                    3'h1: seg_cnt <= data[7:4];
                    
                    3'h2: seg_cnt <= data[11:8];
                    
                    3'h3: seg_cnt <= data[15:12];
                    
                    3'h4: seg_cnt <= data[19:16];
                    
                    3'h5: seg_cnt <= data[23:20];
                    
                    3'h6: seg_cnt <= data[27:24];
                    
                    3'h7: seg_cnt <= data[31:28];
                    
                    default:    seg_cnt <= 4'b0000;
                    endcase
    end  
        
    always @(seg_cnt) //译码
        begin
        
        case (seg_cnt)
        
        4'h0: SEG <= 8'b11000000; //显示0~F
        
        4'h1: SEG <= 8'b11111001;
        
        4'h2: SEG <= 8'b10100100;
       
        4'h3: SEG <= 8'b10110000;
        
        4'h4: SEG <= 8'b10011001;
        
        4'h5: SEG <= 8'b10010010;
        
        4'h6: SEG <= 8'b10000010;
        
        4'h7: SEG <= 8'b11111000;
        
        4'h8: SEG <= 8'b10000000;
        
        4'h9: SEG <= 8'b10011000;
        
        4'hA: SEG <= 8'b10001000;
        
        4'hB: SEG <= 8'b10000011;
        
        4'hC: SEG <= 8'b10100111;
        
        4'hD: SEG <= 8'b10100001;
        
        4'hE: SEG <= 8'b10000110;
        
        4'hF: SEG <= 8'b10001110;
        
        default: SEG <= 8'b11111111;
        endcase
        
        end 
    
    always @(cnt) //数码管选择
                begin
                
                case (cnt)
                
                3'h0: AN <= 8'b11111110; //显示第0～7个数码管
                
                3'h1: AN <= 8'b11111101;
                
                3'h2: AN <= 8'b11111011;
                
                3'h3: AN <= 8'b11110111;
                
                3'h4: AN <= 8'b11101111;
                
                3'h5: AN <= 8'b11011111;
                
                3'h6: AN <= 8'b10111111;
                
                3'h7: AN <= 8'b01111111;
                
                default:    AN <= 8'b11111111;
                
                endcase
                
                end     
                
    
endmodule



module Bcd
(
    input [31:0] binary,
    output reg [31:0] data_bcd
);
    
    reg [3:0] bit [7:0];

    integer i;
    integer j;
    always @(binary)
    begin
        data_bcd = 0;
        for(j = 0;j<8;j = j +1)
                    begin
                        bit[j] = 0;
                    end
        for(i=31;i>=0;i = i -1)
        begin
            for(j = 0;j<8;j = j +1)
            begin
                if(bit[j]>=5)   bit[j] = bit[j] + 3;
            end
            for(j = 0;j<7;j = j +1)
            begin
                bit[j] = bit[j] << 1;
                bit[j][0] = bit[j+1][3];                
            end
            bit[7] = bit[7] <<1;
            bit[7][0] = binary[i];
        end
        data_bcd[31:28] = bit[0];
        data_bcd[27:24] = bit[1];
        data_bcd[23:20] = bit[2];
        data_bcd[19:16] = bit[3];
        data_bcd[15:12] = bit[4];
        data_bcd[11:8] = bit[5];
        data_bcd[7:4] = bit[6];
        data_bcd[3:0] = bit[7];
    end
endmodule
