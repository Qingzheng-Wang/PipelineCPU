// `include "ctrl_encode_def.v"

//123
module ctrl(
   input [31:0] instr_in,
   output       RegWrite, // control signal for register write
   output [5:0] EXTOp,    // control signal to signed extension
   output [4:0] ALUOp,    // ALU opertion
   output [2:0] NPCOp,    // next pc operation
   output ALUSrc,         // ALU source for A 1-imm 0-rs2
	output mem_w,
   output [3:0] wea,
   output [1:0] WDSel     // (register) write data selection   
);

   wire [6:0]  Op;          // opcode
   wire [6:0]  Funct7;      // funct7
   wire [2:0]  Funct3;      // funct3

   assign Op = instr_in[6:0];  // instruction
   assign Funct7 = instr_in[31:25]; // funct7
   assign Funct3 = instr_in[14:12]; // funct3

	// r format
   wire rtype  = ~Op[6]&Op[5]&Op[4]&~Op[3]&~Op[2]&Op[1]&Op[0]; //0110011
   wire i_add  = rtype& ~Funct7[6]&~Funct7[5]&~Funct7[4]&~Funct7[3]&~Funct7[2]&~Funct7[1]&~Funct7[0]&~Funct3[2]&~Funct3[1]&~Funct3[0]; // add 0000000 000
   wire i_sub  = rtype& ~Funct7[6]& Funct7[5]&~Funct7[4]&~Funct7[3]&~Funct7[2]&~Funct7[1]&~Funct7[0]&~Funct3[2]&~Funct3[1]&~Funct3[0]; // sub 0100000 000
   wire i_or   = rtype& ~Funct7[6]&~Funct7[5]&~Funct7[4]&~Funct7[3]&~Funct7[2]&~Funct7[1]&~Funct7[0]& Funct3[2]& Funct3[1]&~Funct3[0]; // or 0000000 110
	wire i_xor	= rtype& ~Funct7[6]&~Funct7[5]&~Funct7[4]&~Funct7[3]&~Funct7[2]&~Funct7[1]&~Funct7[0]& Funct3[2]&~Funct3[1]&~Funct3[0]; // xor 0000000 100
   wire i_and  = rtype& ~Funct7[6]&~Funct7[5]&~Funct7[4]&~Funct7[3]&~Funct7[2]&~Funct7[1]&~Funct7[0]& Funct3[2]& Funct3[1]& Funct3[0]; // and 0000000 111
	wire i_sll	= rtype& ~Funct7[6]&~Funct7[5]&~Funct7[4]&~Funct7[3]&~Funct7[2]&~Funct7[1]&~Funct7[0]&~Funct3[2]&~Funct3[1]& Funct3[0]; // sll 0000000 001
	wire i_sra	= rtype& ~Funct7[6]& Funct7[5]&~Funct7[4]&~Funct7[3]&~Funct7[2]&~Funct7[1]&~Funct7[0]& Funct3[2]&~Funct3[1]& Funct3[0]; // sra 0100000 101
	wire i_srl	= rtype& ~Funct7[6]&~Funct7[5]&~Funct7[4]&~Funct7[3]&~Funct7[2]&~Funct7[1]&~Funct7[0]& Funct3[2]&~Funct3[1]& Funct3[0]; // srl 0000000 101
	wire i_slt	= rtype& ~Funct7[6]&~Funct7[5]&~Funct7[4]&~Funct7[3]&~Funct7[2]&~Funct7[1]&~Funct7[0]&~Funct3[2]& Funct3[1]&~Funct3[0]; // slt 0000000 010
	wire i_sltu	= rtype& ~Funct7[6]&~Funct7[5]&~Funct7[4]&~Funct7[3]&~Funct7[2]&~Funct7[1]&~Funct7[0]&~Funct3[2]& Funct3[1]& Funct3[0]; // sltu 0000000 011
	
	// i format load
   wire itype_l= ~Op[6]&~Op[5]&~Op[4]&~Op[3]&~Op[2]&Op[1]&Op[0]; //0000011
	wire i_lw	= itype_l&~Funct3[2]& Funct3[1]&~Funct3[0]; // lw 010
	wire i_lh	= itype_l&~Funct3[2]&~Funct3[1]& Funct3[0]; // lh 001
	wire i_lhu	= itype_l& Funct3[2]&~Funct3[1]& Funct3[0]; // lhu 101
	wire i_lb	= itype_l&~Funct3[2]&~Funct3[1]&~Funct3[0]; // lb 000
	wire i_lbu	= itype_l& Funct3[2]&~Funct3[1]&~Funct3[0]; // lbu 100

	// i format r
	wire itype_r= ~Op[6]&~Op[5]&Op[4]&~Op[3]&~Op[2]&Op[1]&Op[0]; //0010011
	wire i_addi	= itype_r&~Funct3[2]&~Funct3[1]&~Funct3[0]; // addi 000
	wire i_ori	= itype_r& Funct3[2]& Funct3[1]&~Funct3[0]; // ori 110
	wire i_xori	= itype_r& Funct3[2]&~Funct3[1]&~Funct3[0]; // xoi 100
	wire i_andi	= itype_r& Funct3[2]& Funct3[1]& Funct3[0]; // andi 111
	wire i_srai	= itype_r& Funct3[2]&~Funct3[1]& Funct3[0]&~Funct7[6]& Funct7[5]&~Funct7[4]&~Funct7[3]&~Funct7[2]&~Funct7[1]&~Funct7[0]; // srai 101 0100000
	wire i_slti	= itype_r&~Funct3[2]& Funct3[1]&~Funct3[0]; // slti 010
	wire i_sltiu= itype_r&~Funct3[2]& Funct3[1]& Funct3[0]; // sltiu 011
	wire i_slli	= itype_r&~Funct3[2]&~Funct3[1]& Funct3[0]&~Funct7[6]&~Funct7[5]&~Funct7[4]&~Funct7[3]&~Funct7[2]&~Funct7[1]&~Funct7[0]; // slli 001 0000000
	wire i_srli	= itype_r& Funct3[2]&~Funct3[1]& Funct3[0]&~Funct7[6]&~Funct7[5]&~Funct7[4]&~Funct7[3]&~Funct7[2]&~Funct7[1]&~Funct7[0]; // srli 101 0000000
 
	//i format jalr
	wire i_jalr = Op[6]&Op[5]&~Op[4]&~Op[3]&Op[2]&Op[1]&Op[0];//jalr 1100111

  // s format
   wire stype  = ~Op[6]&Op[5]&~Op[4]&~Op[3]&~Op[2]&Op[1]&Op[0];//0100011
   wire i_sw   = stype&~Funct3[2]& Funct3[1]&~Funct3[0]; // sw 010
	wire i_sh 	= stype&~Funct3[2]&~Funct3[1]& Funct3[0]; // sh 001
	wire i_sb	= stype&~Funct3[2]&~Funct3[1]&~Funct3[0]; // sb 000

	// sb format
   wire sbtype = Op[6]&Op[5]&~Op[4]&~Op[3]&~Op[2]&Op[1]&Op[0];//1100011 /
   wire i_beq  = sbtype&~Funct3[2]&~Funct3[1]&~Funct3[0]; // beq 000 /
	wire i_bne 	= sbtype&~Funct3[2]&~Funct3[1]& Funct3[0]; // bne 001 /
	wire i_blt	= sbtype& Funct3[2]&~Funct3[1]&~Funct3[0]; // blt 100 /
	wire i_bge	= sbtype& Funct3[2]&~Funct3[1]& Funct3[0]; // bge 101 /
	wire i_bltu	= sbtype& Funct3[2]& Funct3[1]&~Funct3[0]; // bltu 110 /
	wire i_bgeu	= sbtype& Funct3[2]& Funct3[1]& Funct3[0]; // bgeu 111 /
	
	//u format
	wire i_lui	= ~Op[6]&Op[5]&Op[4]&~Op[3]&Op[2]&Op[1]&Op[0]; // 0110111
	wire i_auipc= ~Op[6]&~Op[5]&Op[4]&~Op[3]&Op[2]&Op[1]&Op[0]; // 0010111
	
	// j format
   wire i_jal  = Op[6]&Op[5]&~Op[4]&Op[3]&Op[2]&Op[1]&Op[0];// jal 1101111

	// generate control signals
	assign RegWrite   = rtype | itype_r | | itype_l | i_jalr | i_jal | i_lui | i_auipc; // register write
	assign ALUSrc     = itype_r | itype_l | stype | i_jal | i_jalr | i_lui | i_auipc;   // ALU B is from instruction immediate

  // signed extension
  // EXT_CTRL_ITYPE_SHAMT 6'b100000
  // EXT_CTRL_ITYPE	      6'b010000
  // EXT_CTRL_STYPE	      6'b001000
  // EXT_CTRL_BTYPE	      6'b000100
  // EXT_CTRL_UTYPE	      6'b000010
  // EXT_CTRL_JTYPE	      6'b000001
  assign EXTOp[5] = i_srai | i_slli | i_srli;
  assign EXTOp[4] = i_ori | i_andi | i_jalr | i_addi | i_xori | i_slti | i_sltiu | itype_l;  
  assign EXTOp[3] = stype; 
  assign EXTOp[2] = sbtype; 
  assign EXTOp[1] = i_lui | i_auipc;   
  assign EXTOp[0] = i_jal;         
  
  assign wea[3] = i_sw;
  assign wea[2] = i_sw;
  assign wea[1] = i_sw | i_sh;
  assign wea[0] = i_sw | i_sh | i_sb;

  assign mem_w = i_sw | i_sh | i_sb;
  
  // WDSel_FromALU 2'b00
  // WDSel_FromMEM 2'b01
  // WDSel_FromPC  2'b10 
  assign WDSel[0] = itype_l;
  assign WDSel[1] = i_jal | i_jalr;

  // NPC_PLUS4   3'b000
  // NPC_BRANCH  3'b001
  // NPC_JUMP    3'b010
  // NPC_JALR	3'b100
  assign NPCOp[0] = sbtype;
  assign NPCOp[1] = i_jal;
  assign NPCOp[2] = i_jalr;
  

 /*`define ALUOp_nop 5'b00000
`define ALUOp_lui 5'b00001 /]
`define ALUOp_auipc 5'b00010 /
`define ALUOp_add 5'b00011 /]
`define ALUOp_sub 5'b00100 /
`define ALUOp_bne 5'b00101 /]
`define ALUOp_blt 5'b00110 /
`define ALUOp_bge 5'b00111 //]
`define ALUOp_bltu 5'b01000 //
`define ALUOp_bgeu 5'b01001 //]
`define ALUOp_slt 5'b01010 /
`define ALUOp_sltu 5'b01011 /]
`define ALUOp_xor 5'b01100 /
`define ALUOp_or 5'b01101 /]
`define ALUOp_and 5'b01110 /
`define ALUOp_sll 5'b01111 /]
`define ALUOp_srl 5'b10000 /
`define ALUOp_sra 5'b10001 /]*/
	assign ALUOp[0] = i_add|i_or|i_sll|i_sra|i_sltu|i_addi|i_ori|i_srai|i_sltiu|i_slli|i_jalr|itype_l||stype|i_bne|i_bge|i_bgeu|i_lui|i_jal;
	assign ALUOp[1] = i_add|i_and|i_sll|i_slt|i_sltu|i_addi|i_andi|i_slti|i_sltiu|i_slli|i_jalr|itype_l|stype|i_blt|i_bge|i_auipc|i_jal;
	assign ALUOp[2] = i_sub|i_or|i_xor|i_and|i_sll|i_ori|i_xori|i_andi|i_slli|i_beq|i_bne|i_blt|i_bge;
	assign ALUOp[3] = i_or|i_xor|i_and|i_sll|i_slt|i_sltu|i_ori|i_xori|i_andi|i_slti|i_sltiu|i_slli|i_bltu|i_bgeu;
	assign ALUOp[4] = i_sra|i_srl|i_srai|i_srli;

endmodule
