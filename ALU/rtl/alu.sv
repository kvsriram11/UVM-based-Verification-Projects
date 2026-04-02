module alu(
	input clock,
	input reset,
	input [7:0] a,b,
	input [3:0] alu_sel,
	output reg [7:0] alu_out,
	output bit carryout
	);
	
	reg [7:0] alu_result;
	wire [8:0] tmp;
	
	assign tmp = {1'b0,a} + {1'b0,b};
	
	always @(posedge clock or posedge reset) begin
		if(reset) begin
			alu_out <= 8'd0;
			carryout <= 1'd0;
		end
		else begin
			alu_out <= alu_result;
			carryout <= tmp[8];
		end
	end
	
	always @(*)begin
		case(alu_sel)
			4'b0000: alu_result = a + b;
			4'b0001: alu_result = a - b;
			4'b0010: alu_result = a * b;
			4'b0011: alu_result = a/b;
			default: alu_result =8'hFF;
		endcase
	end
endmodule
	