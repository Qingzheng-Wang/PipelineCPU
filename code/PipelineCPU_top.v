module PipelineCPU_top(
    input Clk_CPU,
    input rst,
    //input clk_100mhz,
    input MIO_ready,
    input [31:0] inst_in,
    input [31:0] Data_in,
    output mem_w,
    output [31:0] PC_out,
    output [31:0] Addr_out,
    output [31:0] Data_out,
    //output [31:0] DOUTA,
    output CPU_MIO,
    output [3:0] wea,
	//output [31:0] PC_out,
	//output [31:0] instr_out,
    input INT
);

assign we = 1'b1;
assign clr = 1'b0;
wire [31:0] NPC_out;
wire [31:0] PC_IF;
wire [31:0] BranchAddr;
wire [31:0] ALU_result_EXE;
wire [2:0] NPCOp_new;
wire [31:0] PCPLUS4_IF;
wire [31:0] PCPLUS4_ID;
wire [31:0] instr_IF;
wire [31:0] instr_ID;
wire [31:0] PC_ID;
wire stall;

PC_reg_NEW PC(
    .clk(Clk_CPU),
    .we(~stall),
    .clr(clr),
    .NPC(NPC_out),
    .PC(PC_IF)
);

assign PC_out = PC_IF;
IF_stage IF(
    .PC(PC_IF),
    .PC_b(BranchAddr),
    .PC_jal(BranchAddr),
    .PC_jalr(ALU_result_EXE),
    .NPCOp(NPCOp_new),
    .NPC(NPC_out),
    .PCPLUS4(PCPLUS4_IF)
    //.instr(instr_IF)
);

assign instr_IF = inst_in;
wire Flush_IF_ID;

IF_ID_NEW IF_ID(
    .clk(Clk_CPU),
    .instr_in(instr_IF),
    .PCPLUS4_in(PCPLUS4_IF),
    .PC_in(PC_IF),
    .we(~stall),
    .clr(Flush_IF_ID),
    .instr_out(instr_ID),
    .PCPLUS4_out(PCPLUS4_ID),
    .PC_out(PC_ID)
);

wire RegWrite_from_WB;
wire RegWrite_from_ID;
wire [31:0] WriteBackData;
wire [4:0] ALUOp_ID; //命名成ID是因为ALUOp既要在ID阶段有线，又要在EXE阶段有，ID用以区分
wire [2:0] NPCOp_ID;
wire ALUSrc_ID;
wire mem_w_ID;
wire [3:0] wea_ID;
wire [1:0] WDSel_ID;
wire [31:0] rs1_ID;
wire [31:0] rs2_ID;
wire [4:0] wregnum_ID;
wire [4:0] wregnum_from_WB;
wire [31:0] ImmGen_ID;

ID_stage ID(
    .clk(Clk_CPU),
    .rst(rst),
    .instr_in(instr_ID),
    .RegWrite_in(RegWrite_from_WB),
    .wregnum(wregnum_from_WB),
    .WD(WriteBackData),
    .RegWrite_out(RegWrite_from_ID),
    .ALUOp_out(ALUOp_ID),
    .NPCOp_out(NPCOp_ID),
    .ALUSrc_out(ALUSrc_ID),
    .mem_w_out(mem_w_ID),
    .wea_out(wea_ID),
    .WDSel_out(WDSel_ID),
    .rs1_out(rs1_ID),
    .rs2_out(rs2_ID),
    .wregnum_out(wregnum_ID),
    .ImmGen_out(ImmGen_ID)
);

wire RegWrite_EXE;
wire [4:0] ALUOp_EXE;
wire [2:0] NPCOp_EXE;
wire ALUSrc_EXE;
wire mem_w_EXE;
wire [3:0] wea_EXE;
wire [1:0] WDSel_EXE;
wire [31:0] rs1_EXE;
wire [31:0] rs2_EXE;
wire [4:0] wregnum_EXE;
wire [31:0] ImmGen_EXE;
wire [31:0] PCPLUS4_EXE;
wire [31:0] PC_EXE;
wire [1:0] rs1_fwd_sel_ID;
wire [1:0] rs2_fwd_sel_ID;
wire [1:0] rs1_fwd_sel_EXE;
wire [1:0] rs2_fwd_sel_EXE;
wire Flush_ID_EXE;

ID_EXE_NEW ID_EXE(
    .clk(Clk_CPU),
    .we(we),
    .clr(Flush_ID_EXE),
    .RegWrite_in(RegWrite_from_ID),
    .ALUOp_in(ALUOp_ID),
    .NPCOp_in(NPCOp_ID),
    .ALUSrc_in(ALUSrc_ID),
    .mem_w_in(mem_w_ID),
    .wea_in(wea_ID),
    .WDSel_in(WDSel_ID),
    .rs1_in(rs1_ID),
    .rs2_in(rs2_ID),
    .wregnum_in(wregnum_ID),
    .ImmGen_in(ImmGen_ID),
    .PCPLUS4_in(PCPLUS4_ID),
    .PC_in(PC_ID),
    .rs1_fwd_sel_in(rs1_fwd_sel_ID),
    .rs2_fwd_sel_in(rs2_fwd_sel_ID),
    .RegWrite_out(RegWrite_EXE),
    .ALUOp_out(ALUOp_EXE),
    .NPCOp_out(NPCOp_EXE),
    .ALUSrc_out(ALUSrc_EXE),
    .mem_w_out(mem_w_EXE),
    .wea_out(wea_EXE),
    .WDSel_out(WDSel_EXE),
    .rs1_out(rs1_EXE),
    .rs2_out(rs2_EXE),
    .wregnum_out(wregnum_EXE),
    .ImmGen_out(ImmGen_EXE),
    .PCPLUS4_out(PCPLUS4_EXE),
    .PC_out(PC_EXE),
    .rs1_fwd_sel_out(rs1_fwd_sel_EXE),
    .rs2_fwd_sel_out(rs2_fwd_sel_EXE)
);

wire [31:0] ALU_result_MEM;
wire [31:0] ALU_B_EXE;

EXE_stage EXE(
    .ALUOp_in(ALUOp_EXE),
    .NPCOp_in(NPCOp_EXE),
    .ALUSrc_in(ALUSrc_EXE),
    .rs1_in(rs1_EXE),
    .rs2_in(rs2_EXE),
    .ImmGen(ImmGen_EXE),
    .PC(PC_EXE),
    .WriteBackData_Fwd(WriteBackData),
    .ALU_result_Fwd(ALU_result_MEM),
    .rs1_fwd_sel(rs1_fwd_sel_EXE),
    .rs2_fwd_sel(rs2_fwd_sel_EXE),
    .ALU_B(ALU_B_EXE),
    .NPCOp_new(NPCOp_new),
    .ALU_result(ALU_result_EXE),
    .BranchAddr(BranchAddr)
);

wire RegWrite_MEM;
wire [1:0] WDSel_MEM;
wire mem_w_MEM;
wire [3:0] wea_MEM;
wire [31:0] rs2_MEM;
wire [4:0] wregnum_MEM;
wire [31:0] PCPLUS4_MEM;

EXE_MEM_NEW EXE_MEM(
    .clk(Clk_CPU),
    .we(we),
    .clr(clr),
    .RegWrite_in(RegWrite_EXE),
    .mem_w_in(mem_w_EXE),
    .wea_in(wea_EXE),
    .WDSel_in(WDSel_EXE),
    .ALU_result_in(ALU_result_EXE),
    .ALU_B_in(ALU_B_EXE),
    .wregnum_in(wregnum_EXE),
    .PCPLUS4_in(PCPLUS4_EXE),
    .RegWrite_out(RegWrite_MEM),
    .mem_w_out(mem_w_MEM),
    .wea_out(wea_MEM),
    .WDSel_out(WDSel_MEM),
    .ALU_result_out(ALU_result_MEM),
    .ALU_B_out(rs2_MEM),
    .wregnum_out(wregnum_MEM),
    .PCPLUS4_out(PCPLUS4_MEM)
);

wire [31:0] ReadData_MEM;
/*MEM_stage MEM(
    .clk(clk_100mhz),
    .mem_w(mem_w_MEM),
    .ALU_result(ALU_result_MEM),
    .WriteData(rs2_MEM),
    .ReadData(ReadData_MEM)
);*/
assign mem_w = mem_w_MEM;
assign wea = wea_MEM;
assign Addr_out = ALU_result_MEM;
assign Data_out = rs2_MEM;
assign ReadData_MEM = Data_in;

wire [1:0] WDSel_WB;
wire [31:0] ALU_result_WB;
wire [31:0] dout_WB;
wire [31:0] PCPLUS4_WB;

MEM_WB_NEW MEM_WB(
    .clk(Clk_CPU),
    .we(we),
    .clr(clr),
    .RegWrite_in(RegWrite_MEM),
    .WDSel_in(WDSel_MEM),
    .ALU_result_in(ALU_result_MEM),
    .dout_in(ReadData_MEM),
    .wregnum_in(wregnum_MEM),
    .PCPLUS4_in(PCPLUS4_MEM),
    .RegWrite_out(RegWrite_from_WB),
    .WDSel_out(WDSel_WB),
    .ALU_result_out(ALU_result_WB),
    .dout_out(dout_WB),
    .wregnum_out(wregnum_from_WB),
    .PCPLUS4_out(PCPLUS4_WB)
);

WB_stage WB(
    .ALU_result(ALU_result_WB),
    .DM_data(dout_WB),
    .WDSel(WDSel_WB),
    .PCPLUS4(PCPLUS4_WB),
    .WriteBackData(WriteBackData)
);

HazardCtrl U_HazardCtrl(
    .instr(instr_ID),
    .RegWrite_EXE(RegWrite_EXE),
    .wregnum_EXE(wregnum_EXE),
    .NPCOp_new_EXE(NPCOp_new),
    .WDSel_EXE(WDSel_EXE),
    .RegWrite_MEM(RegWrite_MEM),
    .wregnum_MEM(wregnum_MEM),
    .stall(stall),
    .rs1_fwd_sel(rs1_fwd_sel_ID),
    .rs2_fwd_sel(rs2_fwd_sel_ID),
    .Flush_IF_ID(Flush_IF_ID),
    .Flush_ID_EXE(Flush_ID_EXE)
);

endmodule