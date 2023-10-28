module ID_EXE_NEW(
    input clk,
    input we,
    input clr,
    input RegWrite_in,
    input [4:0] ALUOp_in,
    input [2:0] NPCOp_in,
    input ALUSrc_in,
    input mem_w_in,
    input [3:0] wea_in,
    input [1:0] WDSel_in,
    input [31:0] rs1_in,
    input [31:0] rs2_in,
    input [4:0] wregnum_in,
    input [31:0] ImmGen_in,
    input [31:0] PCPLUS4_in,
    input [31:0] PC_in,
    input [1:0] rs1_fwd_sel_in,
    input [1:0] rs2_fwd_sel_in,
    output reg RegWrite_out,
    output reg [4:0] ALUOp_out,
    output reg [2:0] NPCOp_out,
    output reg ALUSrc_out,
    output reg mem_w_out,
    output reg [3:0] wea_out,
    output reg [1:0] WDSel_out,
    output reg [31:0] rs1_out,
    output reg [31:0] rs2_out,
    output reg [4:0] wregnum_out,
    output reg [31:0] ImmGen_out,
    output reg [31:0] PCPLUS4_out,
    output reg [31:0] PC_out,
    output reg [1:0] rs1_fwd_sel_out,
    output reg [1:0] rs2_fwd_sel_out
);

initial 
begin
    RegWrite_out = 1'b0;
    ALUOp_out = 5'b0;
    NPCOp_out = 3'b0;
    ALUSrc_out = 1'b0;
    mem_w_out = 1'b0;
    wea_out = 4'b0;
    WDSel_out = 2'b0;
    rs1_out = 32'b0;
    rs2_out = 32'b0;
    wregnum_out = 5'b0;
    ImmGen_out = 32'b0;
    PCPLUS4_out = 32'b0;
    PC_out = 32'b0;
    rs1_fwd_sel_out = 2'b0;
    rs2_fwd_sel_out = 2'b0;    
end

always @(posedge clk)
begin
    if(clr)
        begin
            RegWrite_out <= 1'b0;
            ALUOp_out <= 5'b0;
            NPCOp_out <= 3'b0;
            ALUSrc_out <= 1'b0;
            mem_w_out <= 1'b0;
            wea_out <= 4'b0;
            WDSel_out <= 2'b0;
            rs1_out <= 32'b0;
            rs2_out <= 32'b0;
            wregnum_out <= 5'b0;
            ImmGen_out <= 32'b0;
            PCPLUS4_out <= 32'b0;
            PC_out <= 32'b0;
            rs1_fwd_sel_out <= 2'b0;
            rs2_fwd_sel_out <= 2'b0;
        end
    else
        if(we)
            begin
            RegWrite_out <= RegWrite_in;
            ALUOp_out <= ALUOp_in;
            NPCOp_out <= NPCOp_in;
            ALUSrc_out <= ALUSrc_in;
            mem_w_out <= mem_w_in;
            wea_out <= wea_in;
            WDSel_out <= WDSel_in;
            rs1_out <= rs1_in;
            rs2_out <= rs2_in;
            wregnum_out <= wregnum_in;
            ImmGen_out <= ImmGen_in;
            PCPLUS4_out <= PCPLUS4_in;
            PC_out <= PC_in;
            rs1_fwd_sel_out <= rs1_fwd_sel_in;
            rs2_fwd_sel_out <= rs2_fwd_sel_in;
            end
            
end

endmodule