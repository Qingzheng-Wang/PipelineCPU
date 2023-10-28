module IF_stage(
    input [31:0] PC, PC_b, PC_jal, PC_jalr,
    input [2:0] NPCOp,
    output [31:0] NPC, PCPLUS4, instr
);

adder32 U_PCPLUS4(
    .in0(PC),
    .in1(32'b0000_0000_0000_0000_0000_0000_0000_0100),
    .out(PCPLUS4)
);

mux4 U_NPC(
    .sel(NPCOp),
    .in0(PCPLUS4),
    .in1(PC_b),
    .in2(PC_jal),
    .in3(PC_jalr),
    .out(NPC)
);

IP1 U_Instrmem(
    .a(PC[11:2]),
    .spo(instr)
);

endmodule