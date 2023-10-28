`include "ctrl_encode_def.v"
module EXT( 
	input [31:0] instr_in,
	input [5:0] EXTOp,
	output reg [31:0] immout
	);

	wire [4:0] iimm_shamt;
	wire [11:0] iimm,simm,bimm;
	wire [19:0] uimm,jimm;
   
	assign iimm_shamt=instr_in[24:20];
	assign iimm=instr_in[31:20];
	assign simm={instr_in[31:25],instr_in[11:7]};
	assign bimm={instr_in[31],instr_in[7],instr_in[30:25],instr_in[11:8]};
	assign uimm=instr_in[31:12];
	assign jimm={instr_in[31],instr_in[19:12],instr_in[20],instr_in[30:21]};

	always  @(*)
	 case (EXTOp)
		`EXT_CTRL_ITYPE_SHAMT:   immout<={27'b0,iimm_shamt[4:0]};
		`EXT_CTRL_ITYPE:	immout <= {{20{iimm[11]}}, iimm[11:0]};
		`EXT_CTRL_STYPE:	immout <= {{20{simm[11]}}, simm[11:0]};
		`EXT_CTRL_BTYPE:  immout <= {{20{bimm[11]}}, bimm[11:0]};
		`EXT_CTRL_UTYPE:	immout <= {uimm[19:0], 12'b0}; 
		`EXT_CTRL_JTYPE:	immout <= {{12{jimm[19]}}, jimm[19:0]};
		default:	        immout <= 32'b0;
	 endcase

       
endmodule
