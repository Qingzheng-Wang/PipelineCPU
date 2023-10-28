module PC_reg_NEW(
    input clk,
    input we,
    input clr,
    input [31:0] NPC,
    output reg [31:0] PC
);

initial PC = 32'b0;

always @(posedge clk)
begin
    if(clr)
        begin
            PC <= 32'b0;
        end
    else
        if(we)
        begin
            PC <= NPC;
        end
end

endmodule