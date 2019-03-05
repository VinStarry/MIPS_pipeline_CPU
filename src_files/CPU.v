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
clk	input	时钟信号输入
rst	input	复位信号输入
pause	input	暂停信号输入
rom_data_out	input[31:0]	指令输入
ram_data_out	input[31:0]	内存数据输入

<<<<<<< HEAD
output:
rom_addr	output[9:0]	指令地址输出
ram_addr	output[9:0]	内存地址输出
ram_data_in	output[31:0]	内存数据输入(保存)
ram_sel	output[3:0]	内存读取方式输出(字节、字、双字)
ram_rw	output	内存读写访问方式输出
total_cycles	output[31:0]	总周期数
uncondi_branch_num	output[31:0]	无条件周期数
condi_branch_num	output[31:0]	有条件分指数
led_data_in	output[31:0]	数码管输出数据
led_cpu_enable 系统调用控制display
*/

 //attention: ram_addr [11:0]


 //添加 led_cpu_enable syscall 34

module CPU(clk, rst, pause, rom_data_out, ram_data_out, rom_addr, ram_addr,
			ram_data_in, ram_sel, ram_rw, total_cycles, uncondi_branch_num, condi_branch_num, led_data_in, led_cpu_enable);

	input clk, rst, pause;
	input[31:0] rom_data_out, ram_data_out;
	output[9:0] ram_addr, rom_addr;
	output[31:0] ram_data_in;
	output[31:0] uncondi_branch_num, total_cycles, condi_branch_num;
	output[31:0] led_data_in;
	output[3:0] ram_sel; 
	output ram_rw, led_cpu_enable;
    
    reg go_state;

    //解释指令
    wire[5:0] op, func;
    wire[4:0] rs, rt, rd, shamt;
    wire[15:0] imm;
    wire[25:0] j_addr;

    assign op = rom_data_out[31:26];
    assign func = rom_data_out[5:0];
    assign rs = rom_data_out[25:21];
    assign rt = rom_data_out[20:16];
    assign rd = rom_data_out[15:11];
    assign imm = rom_data_out[15:0];
    assign shamt = rom_data_out[10:6];
    assign j_addr = rom_data_out[25:0];



    /*Controler*/
    wire beq, bne, mem_to_reg, mem_write, alu_src_b, reg_write, reg_dst, signed_ext, jal, jmp, jr, syscall;
    wire bgez; //my signal
    wire[3:0] alu_op;
    wire[1:0] my_A_signal;
    Controler controler(.op(op), .func(func),
    					.beq(beq), .bne(bne), .mem_to_reg(mem_to_reg), .mem_write(mem_write),
    					.alu_op(alu_op), .alu_src_b(alu_src_b), .reg_write(reg_write), .reg_dst(reg_dst),
    					.signed_ext(signed_ext), .jal(jal), .jmp(jmp), .jr(jr),
    					.my_A_signal(my_A_signal), .syscall(syscall), .my_B_signal(bgez));
    assign ram_rw = mem_write;
    
    /*RegFile*/
    wire[4:0] reg1_no, reg2_no, reg_no_in;
    wire[4:0] reg_no_in_mid;
    wire[31:0] reg_data_in;
    wire[31:0] reg1_data, reg2_data;

    /*Extender*/
    wire[31:0] imm_unsigned_extend, imm_signed_extend, jaddr_unsigned_extend;
    wire[31:0] imm_extend, alu_srcb_data
    Extender #(16,32,0) imm_unsigned_extender(.ext_data_in(imm), .ext_data_out(imm_unsigned_extend));
    Extender #(16,32,1) imm_signed_extender(.ext_data_in(imm), .ext_data_out(imm_signed_extend));
    Extender #(26,32,0) jaddr_unsigned_extender(.ext_data_in(j_addr), .ext_data_out(jaddr_unsigned_extend));
    Mux1_2 #(32) imm_extend_mux(.mux_select(signed_ext), .mux_data_in_0(imm_unsigned_extend), .mux_data_in_1(imm_signed_extend), .mux_data_out(imm_extend));

    RegFile reg_file(.clk(clk), .reg1_no(reg1_no), .reg2_no(reg2_no), .reg_no_in(reg_no_in), .reg_write(reg_write), .reg_data_in(reg_data_in),
    			.reg1_data(reg1_data), .reg2_data(reg2_data));

    Mux1_2 #(5) reg1_no_mux(.mux_select(syscall), .mux_data_in_0(rs), .mux_data_in_1(2), .mux_data_out(reg1_no));
   	Mux1_2 #(5) reg2_no_mux(.mux_select(syscall), .mux_data_in_0(rt), .mux_data_in_1(4), .mux_data_out(reg2_no));
   	Mux1_2 #(5) reg_no_in_mux_1(.mux_select(reg_dst), .mux_data_in_0(rt), .mux_data_in_1(rd), .mux_data_out(reg_no_in_mid));
   	Mux1_2 #(5) reg_no_in_mux_2(.mux_select(jal), .mux_data_in_0(reg_no_in_mid), .mux_data_in_1(5'b11111), .mux_data_out(reg_no_in_mid));
   	Mux1_2 #(32) alu_srcb_mux(.mux_select(alu_src_b), .mux_data_in_0(reg2_data), .mux_data_in_1(imm_signed_extend), .mux_data_out(alu_srcb_data));
    
    

    
    /*ALU*/
    wire[31:0] alu_a_data, alu_b_data;
    wire alu_equal;
    wire[31:0] alu_result1, alu_result2;
    ALU alu(.alu_a_data(alu_a_data), .alu_b_data(alu_b_data), .alu_op(alu_op), .alu_shmat(shmat),
    		.alu_equal(alu_equal), .alu_result1(alu_result1), alu_result2(alu_result2));
    //bgez
   	//Mux1_2 #(32) alu_bgez_mux(.mux_select(bgez), .mux_data_in_0(alu_srcb_data), .mux_data_in_1(0), .mux_data_out(alu_b_data));
    assign alu_a_data = reg1_data;
    assign alu_b_data = alu_srcb_data;
    


    /*PC register*/
    wire pc_enable;
    wire[31:0] pc_data_in;
    wire[31:0] pc_data_out;
    Register #(32) pc(.clk(clk), .rst(rst), .reg_enable(pc_enable), .reg_data_in(pc_data_in), .reg_data_out(pc_data_out));
    assign rom_addr = pc_data_out[11:2];

    wire[31:0] to_reg_data, din_jal;
    wire[31:0] next_pc, jr_pc, jal_pc;
    assign next_pc = pc_data_out + 4;
    Mux1_2 #(32) mem_to_reg_mux(.mux_select(mem_to_reg), .mux_data_in_0(alu_result1), .mux_data_in_1(ram_data_out), .mux_data_out(to_reg_data));
    Mux1_2 #(32) din_jal_mux(.mux_select(jal), .mux_data_in_0(to_reg_data), .mux_data_in_1(next_pc), .mux_data_out(din_jal));
    assign reg_data_in = din_jal;
    //左移2位
    assign jr_pc = jaddr_unsigned_extend << 2;
    assign jal_pc = imm_extend << 2 + next_pc;

    //pc_enable  
    wire halt；
    assign halt = ((reg1_data != 34) & syscall);
    assign led_cpu_enable = ((reg1_data == 34) & syscall);
    assign led_data_in = reg2_data;
    assign pc_enable = go_state | (!halt);

    //pc_select 
    wire[1:0] pc_select
    assign pc_select[1] = uncon_if | jal;
    assign pc_select[0] = con_if | jr;

    Mux2_4 #(32) pc_mux(.mux_select(pc_select), .mux_data_in_0(next_pc), .mux_data_in_1(jal_pc), .mux_data_in_2(jr_pc), .mux_data_in_3(reg1_data), .mux_data_out(pc_data_in));



    /*counter*/
    wire con_if, uncon_if;
    Counter #(32) total_cycles_counter(.clk(clk), .rst(rst), .counter_enable(pc_enable), .counter_data_out(total_cycles));
	Counter #(32) condi_branch_num_counter(.clk(clk), .rst(rst), .counter_enable(con_if), .counter_data_out(condi_branch_num));
	Counter #(32) uncondi_branch_num_counter(.clk(clk), .rst(rst), .counter_enable(uncon_if), .counter_data_out(uncondi_branch_num));
    

    //缺少
    //ram ram_addr, ram_data_in, ram_sel
    assign ram_data_in = reg2_data;
    //conif uncon_if
   
    initial begin
    	go_state <= 0;
    end



    always @(posedge rst or posedge pause) begin
    	if (rst) begin
    		go_state <= 0;

    	end
    	else if (pause) begin
    		go_state <= ! go_state;
    	end
    end

endmodule




