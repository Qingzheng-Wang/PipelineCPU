module MEM_WB_NEW(
   input clk,
    input we,
    input clr,
    input RegWrite_in,
    input [1:0] WDSel_in,
    input [31:0] ALU_result_in,
    input [31:0] dout_in,
    input [4:0] wregnum_in,
    input  [31:0] PCPLUS4_in, 
    output reg RegWrite_out,
    output reg [1:0] WDSel_out,
    output reg [31:0] ALU_result_out,
    output reg [31:0] dout_out,
    output reg [4:0] wregnum_out,
    output reg [31:0] PCPLUS4_out
);

initial
begin
    RegWrite_out = 1'b0;
    WDSel_out = 2'b0;
    ALU_result_out = 32'b0;
    dout_out = 32'b0;
    wregnum_out = 5'b0;
    PCPLUS4_out = 32'b0;
end

always @(posedge clk)
begin
    if(clr)
        begin
            RegWrite_out <= 1'b0;
            WDSel_out <= 2'b0;
            ALU_result_out <= 32'b0;
            dout_out <= 32'b0;
            wregnum_out <= 5'b0;
            PCPLUS4_out <= 32'b0;
        end
    else
        if(we)
        begin
            RegWrite_out <= RegWrite_in;
            WDSel_out <= WDSel_in;
            ALU_result_out <= ALU_result_in;
            dout_out <= dout_in;
            wregnum_out <= wregnum_in;
            PCPLUS4_out <= PCPLUS4_in;
        end
end

endmodule