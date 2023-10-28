module mux2(
    input sel,
    input [31:0] in0, in1,
    output [31:0] out
);
    function [31:0] select;
        input [31:0] in0,in1;
        input sel;
        case (sel) 
            1'b0: select = in0;
            1'b1: select = in1;
            default: select = in0;
        endcase
    endfunction
    assign out = select(in0, in1, sel);
endmodule