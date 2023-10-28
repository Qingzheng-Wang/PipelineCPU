module RF(   
    input clk, 
    input rst,
    input RFWr, 
    input [31:0] instr_in,
    input [4:0] wregnum, 
    input [31:0] WD, 
    output [31:0] RD1, RD2
);
  
  wire [4:0]  rs1;
  wire [4:0]  rs2;

  assign rs1 = instr_in[19:15];
  assign rs2 = instr_in[24:20];

  reg [31:0] rf[31:0];
  integer i;

  always @(negedge clk)
    if (rst)     
      for (i=1; i<32; i=i+1)
        rf[i] <= 0;
    else 
      if (RFWr)
      begin
        rf[wregnum] <= WD;
        /*$display("r[20]=0x%8X", rf[20]);
        $display("r[21]=0x%8X", rf[21]);
		    $display("r[22]=0x%8X", rf[22]);
        $display("r[23]=0x%8X", rf[23]);
		    $display("r[25]=0x%8x", rf[25]);
		    $display("r[9]=0x%8x", rf[9]);*/
      end
    
    /*always @(posedge clk)
    begin
      if(rs1 != 0)
        RD1 <= rf[rs1];
      if(rs2 != 0)
        RD2 = rf[rs2];
    end*/
  assign RD1 = (rs1 != 0) ? rf[rs1] : 0;
  assign RD2 = (rs2 != 0) ? rf[rs2] : 0; 

endmodule 
