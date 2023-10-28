module IF_ID_NEW(
    input clk,
    input [31:0] instr_in,
    input [31:0] PCPLUS4_in,
    input [31:0] PC_in,
    input we,
    input clr,
    output reg [31:0] instr_out,
    output reg [31:0] PCPLUS4_out,
    output reg [31:0] PC_out
);

initial 
begin
    instr_out = 32'b0;
    PCPLUS4_out = 32'b0;
    PC_out = 32'b0;
end

always @(posedge clk)
begin
    if(clr)
        begin
            instr_out <= 32'b0;
            PCPLUS4_out <= 32'b0;
            PC_out <= 32'b0;
        end
    else
        if(we)
        begin
            instr_out <= instr_in;
            PCPLUS4_out <= PCPLUS4_in;
            PC_out <= PC_in;
        end
end

endmodule