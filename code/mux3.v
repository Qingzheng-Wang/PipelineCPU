module mux3(
    input [1:0] sel,
    input [31:0] in0, in1, in2, 
    output [31:0] out
);

    function [31:0] select;
        input [31:0] in0,in1,in2;
        input [1:0] sel;
        case (sel) 
            2'b00: select = in0;
            2'b01: select = in1;
            2'b10: select = in2;
            2'b11: select = in1;
            default: select = in0;
        endcase
    endfunction
    assign out = select(in0, in1, in2, sel);

endmodule