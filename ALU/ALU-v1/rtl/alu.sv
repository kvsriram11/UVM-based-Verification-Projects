// =============================================================================
// ORIGINAL CODE — fully commented, DO NOT modify
// =============================================================================

module alu(
	input clock,                  // clock: all outputs register on posedge
	input reset,                  // async active-high reset
	input [7:0] a,b,              // 8-bit unsigned operands
	input [3:0] alu_sel,          // 4-bit opcode selects operation
	output reg [7:0] alu_out,     // registered 8-bit result (1 cycle latency)
	output bit carryout            // BUG: 'bit' is 2-state; X/Z collapse silently to 0
	);

	reg [7:0] alu_result;         // combinational result wire between blocks
	wire [8:0] tmp;               // 9-bit wire: bit[8] captures addition carry

	// BUG: tmp ALWAYS computes a+b regardless of alu_sel.
	// carryout will be wrong for subtract, multiply, divide.
	assign tmp = {1'b0,a} + {1'b0,b};

	// Sequential block: async reset, else latch combinational results on posedge clock
	always @(posedge clock or posedge reset) begin
		if(reset) begin
			alu_out <= 8'd0;      // clear result on reset
			carryout <= 1'd0;     // clear carry on reset
		end
		else begin
			alu_out <= alu_result;  // register combinational result (1 cycle delay)
			carryout <= tmp[8];     // BUG: always carry from a+b, not per-operation
		end
	end

	// Combinational block: decode alu_sel and compute result
	always @(*)begin
		case(alu_sel)
			4'b0000: alu_result = a + b;   // ADD  — carry captured in tmp[8], but see bug above
			4'b0001: alu_result = a - b;   // SUB  — no borrow flag, silent underflow if a < b
			4'b0010: alu_result = a * b;   // MUL  — BUG: 8x8=up to 16-bit; upper byte silently dropped
			4'b0011: alu_result = a/b;     // DIV  — BUG: no guard when b==0; simulator-defined behavior
			default: alu_result =8'hFF;    // all other 12 opcodes → 0xFF (ambiguous: also valid data result)
		endcase
	end
endmodule


// =============================================================================
// FIXED CODE — all issues resolved, same interface + new status outputs
// =============================================================================
//
// Fixes applied:
//   1. 'bit' → 'logic' for carryout (4-state, X/Z safe)
//   2. Per-operation carry/borrow — not hardwired to a+b
//   3. Multiply uses 16-bit intermediate; overflow flag exposed
//   4. Divide guarded against b==0; div_by_zero flag added
//   5. Subtraction borrow flag via borrow output
//   6. Default opcode maps to 0x00, not 0xFF (avoids ambiguity)
// =============================================================================

module alu_fixed(
	input  logic        clock,
	input  logic        reset,
	input  logic [7:0]  a, b,
	input  logic [3:0]  alu_sel,
	output logic [7:0]  alu_out,
	output logic        carryout,    // carry (ADD) | 0 otherwise
	output logic        borrow,      // borrow (SUB, a < b) | 0 otherwise
	output logic        overflow,    // upper byte nonzero (MUL) | 0 otherwise
	output logic        div_by_zero  // b == 0 during DIV
);

	// ---------- internal combinational signals ----------
	logic [7:0]  alu_result;
	logic        carry_r;
	logic        borrow_r;
	logic        overflow_r;
	logic        divzero_r;

	wire [8:0]  add_tmp = {1'b0, a} + {1'b0, b};  // 9-bit add: bit[8] = carry
	wire [8:0]  sub_tmp = {1'b0, a} - {1'b0, b};  // 9-bit sub: bit[8] = borrow
	wire [15:0] mul_tmp = a * b;                    // 16-bit product (SV extends operands to LHS width)

	// ---------- combinational decode ----------
	always @(*) begin
		// safe defaults
		alu_result = 8'h00;
		carry_r    = 1'b0;
		borrow_r   = 1'b0;
		overflow_r = 1'b0;
		divzero_r  = 1'b0;

		case (alu_sel)
			4'b0000: begin                          // ADD
				alu_result = add_tmp[7:0];
				carry_r    = add_tmp[8];
			end

			4'b0001: begin                          // SUB
				alu_result = sub_tmp[7:0];
				borrow_r   = sub_tmp[8];            // set when a < b (unsigned underflow)
			end

			4'b0010: begin                          // MUL
				alu_result = mul_tmp[7:0];
				overflow_r = |mul_tmp[15:8];        // any nonzero upper byte = overflow
			end

			4'b0011: begin                          // DIV
				if (b == 8'h00) begin
					alu_result = 8'h00;             // safe fallback; div_by_zero signals the error
					divzero_r  = 1'b1;
				end else begin
					alu_result = a / b;
				end
			end

			default: alu_result = 8'h00;            // unimplemented opcode → 0, not 0xFF
		endcase
	end

	// ---------- output registers (posedge clock, async reset) ----------
	always @(posedge clock or posedge reset) begin
		if (reset) begin
			alu_out     <= 8'h00;
			carryout    <= 1'b0;
			borrow      <= 1'b0;
			overflow    <= 1'b0;
			div_by_zero <= 1'b0;
		end else begin
			alu_out     <= alu_result;
			carryout    <= carry_r;
			borrow      <= borrow_r;
			overflow    <= overflow_r;
			div_by_zero <= divzero_r;
		end
	end

endmodule
