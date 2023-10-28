module LEDcontrol(
    input [15:0] sw,
    input clk,
    input reset,
    output reg led_do,
    output led_pen,
    output led_clk,
    ouput led_clr
);
wire Clk_50M;
reg [15:0] sw_dl;
parameter piso_shift = 16;
reg [piso_shift-2:0] sw_shift ;
reg [16:0] counter = 17'h0;
wire [15:0] shift_load;
SWORD_LED_CLK ClkGen50M(
    .CLK_IN1(clk),
    .CLK_OUT1(Clk_50M),
    .RESET(RESET),
    .LOCKED(LOCKED)
);
always@(posedge Clk_50M)
    if(!reset) sw_dl <= 16'h0;
    else sw_dl <= sw;
assign shift_load = sw^sw_dl;
always@(posedge Clk_50M)
    if (shift_load)
    begin
        sw_shift <= sw[piso_shift-2:0];
        led_do <= ~sw[15];
        counter <= 17'h1ffff;
    end
    else 
    begin
        sw_shift <= (sw_shift[piso_shift-3:0], 1'b0);
        led_do <= ~sw_shift[4];
        counter <= {1'b0,counter[16:1]};
    end
assign led_clk = Clk_50M & counter[0];
assign led_clr = reset;
assign led_pen = 1'b1;
endmodule