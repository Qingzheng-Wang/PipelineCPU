module HazardCtrl(
    input [31:0] instr,
    input RegWrite_EXE,
    input [4:0] wregnum_EXE, // store in ID_EXE
    input [2:0]  NPCOp_new_EXE, // store in ID_EXE
    input [1:0] WDSel_EXE, // store in ID_EXE
    input RegWrite_MEM, // store in EXE_MEM
    input [4:0] wregnum_MEM, // store in EXE_MEM
    output reg stall,
    output [1:0] rs1_fwd_sel,
    output [1:0] rs2_fwd_sel,
    output Flush_IF_ID,
    output Flush_ID_EXE
);

wire [6:0] Op;
wire [4:0] rs1;
wire [4:0] rs2;

assign Op = instr[6:0];
assign rs1 = instr[19:15];
assign rs2 = instr[24:20];

wire jtype = Op[6]&Op[5]&~Op[4]&~Op[3]&Op[2]&Op[1]&Op[0]; // 1100111
wire btype = Op[6]&Op[5]&~Op[4]&~Op[3]&~Op[2]&Op[1]&Op[0]; // 1100011
wire itype_load = ~Op[6]&~Op[5]&~Op[4]&~Op[3]&~Op[2]&Op[1]&Op[0]; // 0000011
wire stype = ~Op[6]&Op[5]&~Op[4]&~Op[3]&~Op[2]&Op[1]&Op[0]; // 0100011
wire itype_register = ~Op[6]&~Op[5]&Op[4]&~Op[3]&~Op[2]&Op[1]&Op[0]; // 0010011
wire rtype = ~Op[6]&Op[5]&Op[4]&~Op[3]&~Op[2]&Op[1]&Op[0]; // 0110011

wire rs1_used = jtype | btype | itype_load | stype | itype_register | rtype;
wire rs2_used = btype | stype | rtype;

assign rs1_fwd_sel[0] = (rs1 == wregnum_EXE) & (wregnum_EXE != 5'b00000);
assign rs1_fwd_sel[1] = (rs1 == wregnum_MEM) & (wregnum_MEM != 5'b00000);
assign rs2_fwd_sel[0] = (rs2 == wregnum_EXE) & (wregnum_EXE != 5'b00000); 
assign rs2_fwd_sel[1] = (rs2 == wregnum_MEM) & (wregnum_MEM != 5'b00000);

wire load_use;
assign load_use = (rs1_used & (rs1 != 5'b00000) & WDSel_EXE[0] & (rs1 == wregnum_EXE)) | 
                (rs2_used & (rs2 != 5'b00000) & WDSel_EXE[0] & (rs2 == wregnum_EXE));//use is in the EXE, judge if rs1 equals to wregnum_EXE


assign Flush_IF_ID = NPCOp_new_EXE[0] + NPCOp_new_EXE[1] + NPCOp_new_EXE[2];//jump also needs flush
assign Flush_ID_EXE = NPCOp_new_EXE[0] + NPCOp_new_EXE[1] + NPCOp_new_EXE[2] + load_use;

always @*
begin 
    if(load_use == 1)
        stall = load_use;
    else
        stall = 0;
end

endmodule