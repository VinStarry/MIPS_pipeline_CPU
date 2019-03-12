



module BHTRow(
    input clk,
    input rst,
    input WriteRow,
    input EX_Branch,
    input Branch_Success,
    input [31:0]IF_PC,
    input [31:0]EX_PC,
    input [31:0]data_in,
    output [31:0]data_out,
    output [15:0]count,
    output IF_PC_hit,
    output EX_PC_hit,
    output Pred_Jump
    );
    

    wire [31:0]IF_PC_tag = {20'H0, IF_PC[11:0]};
    wire [31:0]EX_PC_tag = {20'H0, EX_PC[11:0]};
    reg [31:0] BHTRow_tag;
    reg [31:0] data;
    reg valid;
    reg [14:0]count_num;
    reg [1:0]state;
    
    initial begin
        BHTRow_tag = 0;
        data = 0;
        valid = 0;
        count_num = 0;
        state = 2'b11;
    end
    
    assign IF_PC_hit = (IF_PC_tag == BHTRow_tag && valid);
    assign EX_PC_hit = (EX_PC_tag == BHTRow_tag && valid);
    assign data_out = IF_PC_hit ? data : 0;
    assign count = {!valid, count_num};
    assign Pred_Jump = state[1] & IF_PC_hit;
    
    always @(posedge clk) begin
        if (WriteRow || IF_PC_hit) begin
            count_num = 0;
        end
        else begin
            if (count_num != 15'b111111111111111)
                count_num = count_num + 1;
        end
        if (WriteRow) begin
            valid = 1;
            BHTRow_tag = EX_PC_tag;
            data = data_in;
            state = 2'b11;
        end
        if (EX_Branch && (EX_PC_hit || WriteRow)) begin
            case (state) 
                2'b00: state = (Branch_Success)?01:00;
                2'b01: state = (Branch_Success)?10:00;
                2'b10: state = (Branch_Success)?10:11;
                2'b11: state = (Branch_Success)?10:00;
                default: state = 2'b11;
            endcase
        end
        if (rst) begin
            BHTRow_tag = 0;
            data = 0;
            valid = 0;
            count_num = 0;
            state = 2'b11;
        end
    end

endmodule