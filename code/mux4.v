module mux4(
    input [2:0] sel,
    input [31:0] in0, in1, in2, in3, 
    output [31:0] out
);
    function [31:0] select;
        input [31:0] in0,in1,in2,in3;
        input [2:0] sel;
        case (sel) 
            3'b000: select = in0;
            3'b001: select = in1;
            3'b010: select = in2;
            3'b100: select = in3;
            default: select = in0;
        endcase
    endfunction
    assign out = select(in0, in1, in2, in3, sel);
    
endmodule