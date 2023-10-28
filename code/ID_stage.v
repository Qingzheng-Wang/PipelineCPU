module ID_stage(
    input clk,
    input rst,
    input [31:0] instr_in, 
    input RegWrite_in,
    input [4:0] wregnum,
    input [31:0] WD,
    output RegWrite_out,
    output [4:0] ALUOp_out,
    output [2:0] NPCOp_out,
    output ALUSrc_out,
    output mem_w_out,
    output [3:0] wea_out,
    output [1:0] WDSel_out,
    output [31:0] rs1_out,
    output [31:0] rs2_out,
    output [4:0] wregnum_out,
    output [31:0] ImmGen_out
);

assign wregnum_out = instr_in[11:7];

wire [5:0] EXTOp;
ctrl U_ctrl(
    .instr_in(instr_in),
    .RegWrite(RegWrite_out),
    .EXTOp(EXTOp),
    .ALUOp(ALUOp_out),
    .NPCOp(NPCOp_out),
    .ALUSrc(ALUSrc_out),
    .mem_w(mem_w_out),
    .wea(wea_out),
    .WDSel(WDSel_out)
);

RF U_RF(
    .clk(clk),
    .rst(rst),
    .RFWr(RegWrite_in),
    .instr_in(instr_in),
    .wregnum(wregnum),
    .WD(WD),
    .RD1(rs1_out),
    .RD2(rs2_out)
);

EXT U_EXT(
    .instr_in(instr_in),
    .EXTOp(EXTOp),
    .immout(ImmGen_out)
);
endmodule