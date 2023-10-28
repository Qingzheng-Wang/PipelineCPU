`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    16:01:47 06/21/2022 
// Design Name: 
// Module Name:    IP2SOC_Top 
// Project Name: 
// Target Devices: 
// Tool versions: 
// Description: 
//
// Dependencies: 
//
// Revision: 
// Revision 0.01 - File Created
// Additional Comments: 
//
//////////////////////////////////////////////////////////////////////////////////
module IP2SOC_Top(
input RSTN,
input [3:0] BTN_y,
input [15:0] SW,
input clk_100mhz,
output CR,
output seg_clk,
output seg_sout,
output SEG_PEN,
output seg_clrn,
output led_clk,
output led_sout,
output LED_PEN,
output led_clrn,
output RDY,
output readn,
output [4:0] BTN_x
    );
	 
//name regulation: the wire is named by the port which the data output

//wire for U9_out
wire [4:0] Key_out;
wire [3:0] Pulse;
wire [3:0] BTN_OK;
wire [15:0] SW_OK;
wire rst;
SAnti_jitter U9(
.clk(clk_100mhz),
.RSTN(RSTN),
.readn(readn),
.Key_y(BTN_y[3:0]),
.Key_x(BTN_x[4:0]),
.SW(SW),
.Key_out(Key_out),
.Key_ready(RDY),
.pulse_out(Pulse),
.BTN_OK(BTN_OK),
.SW_OK(SW_OK),
.CR(CR),
.rst(rst)
);

//wire for U8_out
wire [31:0] clkdiv;
wire Clk_CPU;
clk_div U8(
.clk(clk_100mhz),
.rst(rst),
.SW2(SW_OK[2]),
.clkdiv(clkdiv),
.Clk_CPU(Clk_CPU)
);

//wire for U1
wire [31:0] spo;
wire [31:0] PC_out;
wire [31:0] Data_in;
wire mem_w;
wire [3:0] wea;
wire [31:0] Addr_out;
wire [31:0] Data_out;
wire CPU_MIO;
wire INT;
wire counter0_out;
wire [31:0] ram_data_out;
PipelineCPU_top U1(
.Clk_CPU(Clk_CPU),
.rst(rst),
//.clk_100mhz(~clk_100mhz),
.MIO_ready(),
.inst_in(spo),
.Data_in(Data_in),
.mem_w(mem_w),
.PC_out(PC_out),
.Addr_out(Addr_out),
.Data_out(Data_out),
.CPU_MIO(CPU_MIO),
.wea(wea),
.INT(counter0_out)
);

//U3
wire [9:0] ram_addr;
wire [31:0] ram_data_in;
D_mem U3(
.ADDRA(ram_addr),
.DINA(ram_data_in),
.WEA(wea),
.CLKA(~clk_100mhz),
.DOUTA(ram_data_out)
);

//U2
IP1 U2(
.a(PC_out[11:2]),
.spo(spo)
);

//M4
wire [7:0] blink;
SEnter_2_32 M4(
.clk(clk_100mhz),
.BTN(BTN_OK[2:0]),
.Ctrl({SW_OK[7:5],SW_OK[15],SW_OK[0]}),
.D_ready(RDY),
.Din(Key_out),
.readn(readn),
.Ai(),
.Bi(),
.blink(blink)
);

//U4
wire [15:0] led_out;
wire [31:0] counter_out;
wire counter2_out;
wire counter1_out;
wire counter_we;
wire [31:0] Peripheral_in;
wire GPIOf0000000_we;
wire GPIOe0000000_we;
MIO_BUS U4(
.clk(clk_100mhz),
.rst(rst),
.BTN(BTN_OK),
.SW(SW_OK),
.mem_w(mem_w),
.Cpu_data2bus(Data_out),
.addr_bus(Addr_out),
.ram_data_out(ram_data_out),
.led_out(led_out),
.counter_out(counter_out),
.counter0_out(counter0_out),
.counter1_out(counter1_out),
.counter2_out(counter2_out),

.Cpu_data4bus(Data_in),
.ram_data_in(ram_data_in),
.ram_addr(ram_addr),
.data_ram_we(),
.GPIOf0000000_we(GPIOf0000000_we),
.GPIOe0000000_we(GPIOe0000000_we),
.counter_we(counter_we),
.Peripheral_in(Peripheral_in)
);
//U10
wire [1:0] counter_set;
Counter_x U10(
.clk(~Clk_CPU),
.rst(rst),
.clk0(clkdiv[6]),
.clk1(clkdiv[9]),
.clk2(clkdiv[11]),
.counter_we(counter_we),
.counter_val(Peripheral_in),
.counter_ch(counter_set),
.counter0_OUT(counter0_out),
.counter1_OUT(counter1_out),
.counter2_OUT(counter2_out),
.counter_out(counter_out)
);

//U6
wire [31:0] disp_num;
wire [7:0] point_out;
wire [7:0] LE_out;
SSeg7_Dev U6(
.clk(clk_100mhz),
.rst(rst),
.Start(clkdiv[20]),
.SW0(SW_OK[0]),
.flash(clkdiv[25]),
.Hexs(disp_num[31:0]),
.point(point_out),
.LES(LE_out),
.seg_clk(seg_clk),
.seg_sout(seg_sout),
.SEG_PEN(SEG_PEN),
.seg_clrn(seg_clrn)
);
 
//U5
Multi_8CH32 U5(
.clk(~Clk_CPU),
.rst(rst),
.EN(GPIOe0000000_we),
.Test(SW_OK[7:5]),
.point_in({clkdiv[31:0],clkdiv[31:0]}),
.LES({64'b0}),
.Data0(Peripheral_in),
.data1({1'b0,1'b0,PC_out[31:2]}),
.data2(spo[31:0]),
.data3(counter_out[31:0]),
.data4(Addr_out[31:0]),
.data5(Data_out[31:0]),
.data6(Data_in[31:0]),
.data7(PC_out[31:0]),
.point_out(point_out),
.LE_out(LE_out),
.Disp_num(disp_num)
);


//U7
SPIO U7(
.clk(~Clk_CPU),
.rst(rst),
.Start(clkdiv[20]),
.EN(GPIOf0000000_we),
.P_Data(Peripheral_in),
.counter_set(counter_set),
.LED_out(led_out),
.led_clk(led_clk),
.led_sout(led_sout),
.led_clrn(led_clrn),
.LED_PEN(LED_PEN),
.GPIOf0()
);



























endmodule



















