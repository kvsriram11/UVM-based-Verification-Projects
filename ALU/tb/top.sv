import uvm_pkg::*;
import alu_pkg::*;
`include "uvm_macros.svh"

module top;

  // clock
  logic clock;

  // interface instantiation
  alu_if intf(.clock(clock));

  // DUT instantiation
  alu dut (
    .clock    (intf.clock),
    .reset    (intf.reset),
    .a        (intf.a),
    .b        (intf.b),
    .alu_sel  (intf.alu_sel),
    .alu_out  (intf.alu_out),
    .carryout (intf.carryout)
  );

  // Interface setting
  initial begin
    uvm_config_db #(virtual alu_if)::set(null, "*", "vif", intf);
  end

  // start test
  initial begin
    run_test("alu_test");
  end

  // clock generation
  initial begin
    clock = 0;
    forever #5 clock = ~clock;
  end

  // max simulation time
  initial begin
    #5000;
    $display("Ran out of clock cycles");
    $finish();
  end

endmodule