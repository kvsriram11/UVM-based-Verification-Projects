interface alu_if(input logic clock);

  logic reset;
  logic [7:0] a, b;
  logic [3:0] alu_sel;
  logic [7:0] alu_out;
  logic carryout;

endinterface