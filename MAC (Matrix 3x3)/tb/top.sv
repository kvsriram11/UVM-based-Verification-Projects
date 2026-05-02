/*-------------------------------------------------------------------------------
File        : top.sv
Class/Interface/Module : top
Project     : 3x3 Matrix Multiplier Verification Environment
Course      : ECE-593 Fundamentals of Pre-Silicon Validation
Author      : Venkata Sriram Kamarajugadda

Description :
    Top-level testbench module that connects the DUT with the
    UVM verification environment. It generates the simulation
    clock, instantiates the interface, connects the DUT ports,
    and starts the UVM test.

Responsibilities:
    - Generate system clock
    - Instantiate verification interface
    - Connect DUT with interface signals
    - Provide virtual interface to UVM components
    - Launch the UVM test
-------------------------------------------------------------------------------
*/

module top;

  // Import UVM library and testbench package
  import uvm_pkg::*;
  import tb_pkg::*;

  // System clock used by DUT and verification components
  logic clk;

  initial clk = 0;
  always #5 clk = ~clk;  // Clock generation (10 time unit period)

  // Interface instance connecting DUT and UVM environment
  mtx_if m_if (clk);

  // DUT instantiation: 3x3 matrix multiplier
  mtx_mul_unit #(
      .WIDTH(16),   // Bit width of matrix elements
      .N(3)         // Matrix dimension
  ) dut (
      .clk   (clk),
      .rst   (m_if.rst),
      .start (m_if.start),
      .A     (m_if.A),   // Input matrix A
      .B     (m_if.B),   // Input matrix B
      .C     (m_if.C),   // Output matrix C
      .done  (m_if.done) // Completion signal
  );

  initial begin
    // Provide virtual interface to UVM components
    uvm_config_db #(virtual mtx_if)::set(null, "*", "vif", m_if);

    // Start the specified UVM test
    run_test("mtx_test");
  end

endmodule