module shift(
    input [31:0] ImmGen_in,
    output [31:0] ImmGen_out
);
assign ImmGen_out = ImmGen_in << 1;
endmodule