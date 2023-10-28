module EXE_MEM_NEW(
    input clk,
    input we,
    input clr,
    input RegWrite_in,
    input mem_w_in,
    input [3:0] wea_in,
    input [1:0] WDSel_in,
    input [31:0] ALU_result_in,
    input [31:0] ALU_B_in,
    input [4:0] wregnum_in,
    input [31:0] PCPLUS4_in,
    output reg RegWrite_out,
    output reg mem_w_out,
    output reg [3:0] wea_out,
    output reg [1:0] WDSel_out,
    output reg [31:0] ALU_result_out,
    output reg [31:0] ALU_B_out,
    output reg [4:0] wregnum_out,
    output reg [31:0] PCPLUS4_out
);

initial
begin
    RegWrite_out = 1'b0;
    mem_w_out = 1'b0;
    wea_out = 4'b0;
    WDSel_out = 2'b0;
    ALU_result_out = 32'b0;
    ALU_B_out = 32'b0;
    wregnum_out = 5'b0;
    PCPLUS4_out = 32'b0;
end

always @(posedge clk)
begin
    if(clr)
        begin
            RegWrite_out <= 1'b0;
            mem_w_out <= 1'b0;
            wea_out <= 4'b0;
            WDSel_out <= 2'b0;
            ALU_result_out <= 32'b0;
            ALU_B_out <= 32'b0;
            wregnum_out <= 5'b0;
            PCPLUS4_out <= 32'b0;
        end
    else
        if(we)
        begin
            RegWrite_out <= RegWrite_in;
            mem_w_out <= mem_w_in;
            wea_out <= wea_in;
            WDSel_out <= WDSel_in;
            ALU_result_out <= ALU_result_in;
            ALU_B_out <= ALU_B_in;
            wregnum_out <= wregnum_in;
            PCPLUS4_out <= PCPLUS4_in;
        end
end

endmodule