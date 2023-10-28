module WB_stage(
    input [31:0] ALU_result,
    input [31:0] DM_data,
    input [1:0] WDSel,
    input [31:0] PCPLUS4,
    output [31:0] WriteBackData
);

mux3 U_WB(
    .sel(WDSel),
    .in0(ALU_result),
    .in1(DM_data),
    .in2(PCPLUS4),
    .out(WriteBackData)
);

endmodule