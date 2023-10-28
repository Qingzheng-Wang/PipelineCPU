module EXE_stage(
    input [4:0] ALUOp_in,
    input [2:0] NPCOp_in,
    input ALUSrc_in,
    input [31:0] rs1_in,
    input [31:0] rs2_in,
    input [31:0] ImmGen,
    input [31:0] PC,
    input [31:0] WriteBackData_Fwd,
    input [31:0] ALU_result_Fwd,
    input [1:0] rs1_fwd_sel,
    input [1:0] rs2_fwd_sel,
    output [31:0] ALU_B,
    output [2:0] NPCOp_new,
    output [31:0] ALU_result,
    output [31:0] BranchAddr
);

wire [31:0] ALU_A;
mux3 rs1_fwd_mux(
    .sel(rs1_fwd_sel),
    .in0(rs1_in),
    .in1(ALU_result_Fwd),
    .in2(WriteBackData_Fwd),
    .out(ALU_A)
);

mux3 rs2_fwd_mux(
    .sel(rs2_fwd_sel),
    .in0(rs2_in),
    .in1(ALU_result_Fwd),
    .in2(WriteBackData_Fwd),
    .out(ALU_B)
);

wire [31:0] ALUSrc2;
mux2 U_ALUSrc(
    .sel(ALUSrc_in),
    .in0(ALU_B),
    .in1(ImmGen),
    .out(ALUSrc2)
);

wire Zero;
alu U_ALU(
    .A(ALU_A),
    .B(ALUSrc2),
    .ALUOp(ALUOp_in),
    .PC(PC),
    .C(ALU_result),
    .Zero(Zero)
);

AND U_AND(
    .NPCOp_in(NPCOp_in),
    .Zero(Zero),
    .NPCOp_new(NPCOp_new)
);

wire [31:0] ImmGen_out;
shift U_shift(
    .ImmGen_in(ImmGen),
    .ImmGen_out(ImmGen_out)
);

adder32 adder_branch(
    .in0(ImmGen_out),
    .in1(PC),
    .out(BranchAddr)
);

endmodule