/*
-------------------------------------------------------------------------------
File        : mtx_if.sv
Interface   : mtx_if
Project     : 3x3 Matrix Multiplier Verification Environment
Course      : ECE-593 Fundamentals of Pre-Silicon Validation
Author      : Venkata Sriram Kamarajugadda

Description :
    SystemVerilog interface that connects the DUT with the UVM testbench
    components. It encapsulates all control and data signals required for
    the matrix multiplication unit.

Responsibilities:
    - Provide shared access to DUT signals for driver and monitor
    - Define control signals (reset, start, done)
    - Carry matrix input operands A and B
    - Capture output matrix C from the DUT
    - Use modports to restrict signal access for driver and monitor

Signal Overview:
    clk   : System clock
    rst   : Active-high reset signal
    start : Start signal to trigger matrix multiplication
    done  : Indicates completion of computation

    A     : 3x3 input matrix A (16-bit elements)
    B     : 3x3 input matrix B (16-bit elements)
    C     : 3x3 output matrix C (32-bit elements)

-------------------------------------------------------------------------------
*/

interface mtx_if (input logic clk);

  // Control Signals
  logic rst;        // Reset signal for DUT
  logic start;      // Start signal to trigger computation
  logic done;       // Indicates computation completion

  // Matrix Input/Output Signals
  logic [15:0] A [2:0][2:0];
  logic [15:0] B [2:0][2:0];
  logic [31:0] C [2:0][2:0];


  // Driver Modport
  // Used by the UVM driver to apply stimulus
  // Driver controls reset, start, and input matrices
  // Driver only observes done and output matrix

  modport drv_mp (
    input  clk,
    output rst,
    output start,
    output A,
    output B,
    input  done,
    input  C
  );

  // Monitor Modport
  // Used by monitors to observe DUT activity
  // All signals are inputs because monitors
  // should never drive DUT signals

  modport mon_mp (
    input clk,
    input rst,
    input start,
    input done,
    input A,
    input B,
    input C
  );

endinterface