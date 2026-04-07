
import uvm_pkg::*;
`include "uvm_macros.svh"
class alu_packet extends uvm_sequence_item;
	`uvm_object_utils(alu_packet)
	
	rand logic reset;
	rand logic [7:0] a,b;
	rand logic [3:0] op_code;
	
	logic [7:0] result;
	bit carry_out;
	
	constraint in_c1 {a inside {[10:20]};}
	constraint in_c2 {b inside {[1:10]};}
	constraint op_code_c3 { op_code inside {0,1,2,3};}
	
	function new (string name = "alu_packet");
		super.new(name);
	endfunction
	
endclass 