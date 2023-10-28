module AND(
    input [2:0] NPCOp_in,
    input Zero,
    output [2:0] NPCOp_new
);

assign NPCOp_new = {NPCOp_in[2:1], NPCOp_in[0]&Zero};

endmodule