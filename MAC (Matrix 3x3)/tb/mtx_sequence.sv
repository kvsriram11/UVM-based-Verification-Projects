/*
-------------------------------------------------------------------------------
File        : mtx_sequence.sv
Class/Interface/Module : mtx_sequence
Project     : 3x3 Matrix Multiplier Verification Environment
Course      : ECE-593 Fundamentals of Pre-Silicon Validation
Author      : Venkata Sriram Kamarajugadda

Description :
    Sequence responsible for generating stimulus transactions for the
    matrix multiplier. It first issues several directed scenarios to
    validate important functional behaviors, followed by randomized
    stimulus to explore a wider input space.

Responsibilities:
    - Generate directed stimulus for key functional cases
    - Exercise corner value combinations
    - Produce randomized transactions for broader coverage
    - Send mtx_transaction items to the sequencer/driver
-------------------------------------------------------------------------------
*/

import uvm_pkg::*;
`include "uvm_macros.svh"

class mtx_sequence extends uvm_sequence #(mtx_transaction);

  `uvm_object_utils(mtx_sequence)

  // Number of random transactions after directed phase
  int rand_count = 1000;

  function new(string name="mtx_sequence");
    super.new(name);
  endfunction


  // Directed stimulus: both matrices are all zeros
  task case_zero_matrix();

    mtx_transaction pkt = new();

    foreach (pkt.A[i,j]) pkt.A[i][j] = 16'h0000;
    foreach (pkt.B[i,j]) pkt.B[i][j] = 16'h0000;

    start_item(pkt);
    finish_item(pkt);

    `uvm_info("SEQ","Directed: ZERO matrix",UVM_LOW)

  endtask


  // Directed stimulus: A multiplied with identity matrix
  task case_identity_property();

    mtx_transaction pkt = new();

    pkt.A = '{ '{1,2,3},'{4,5,6},'{7,8,9} };

    foreach (pkt.B[i,j])
      pkt.B[i][j] = (i==j) ? 16'h0001 : 16'h0000;

    start_item(pkt);
    finish_item(pkt);

    `uvm_info("SEQ","Directed: Identity property",UVM_LOW)

  endtask


  // Directed stress case using large byte values
  task case_max_byte();

    mtx_transaction pkt = new();

    foreach (pkt.A[i,j]) pkt.A[i][j] = 16'h00FF;
    foreach (pkt.B[i,j]) pkt.B[i][j] = 16'h00FF;

    start_item(pkt);
    finish_item(pkt);

    `uvm_info("SEQ","Directed: Stress 0x00FF",UVM_LOW)

  endtask


  // Two back-to-back operations to observe reset behavior
  task case_reset_behavior();

    mtx_transaction first  = new();
    mtx_transaction second = new();

    foreach (first.A[i,j])
      first.A[i][j] = (i==j) ? 16'hAAAA : 16'h0000;

    foreach (first.B[i,j])
      first.B[i][j] = (i==j) ? 16'h0001 : 16'h0000;

    start_item(first);
    finish_item(first);

    foreach (second.A[i,j]) second.A[i][j] = 16'h0000;
    foreach (second.B[i,j]) second.B[i][j] = 16'h0000;

    start_item(second);
    finish_item(second);

    `uvm_info("SEQ","Directed: Reset behavior (AAAA -> 0)",UVM_LOW)

  endtask


  // Corner value combinations applied to both matrices
  task case_corner_cross();

    logic [15:0] corner_vals [3] = '{16'h0000,16'h0001,16'h00FF};

    foreach (corner_vals[a]) begin
      foreach (corner_vals[b]) begin

        mtx_transaction pkt = new();

        foreach (pkt.A[i,j]) pkt.A[i][j] = corner_vals[a];
        foreach (pkt.B[i,j]) pkt.B[i][j] = corner_vals[b];

        start_item(pkt);
        finish_item(pkt);

      end
    end

    `uvm_info("SEQ","Directed: Corner cross combinations sent",UVM_LOW)

  endtask


  // Main sequence body
  virtual task body();

    // Directed stimulus phase
    case_zero_matrix();
    case_identity_property();
    case_max_byte();
    case_reset_behavior();
    case_corner_cross();

    // Random stimulus phase
    repeat(rand_count) begin

      mtx_transaction pkt = new();

      assert(pkt.randomize())
        else `uvm_fatal("SEQ","Randomization failed")

      start_item(pkt);
      finish_item(pkt);

    end

    `uvm_info("SEQ","Completed stimulus generation",UVM_LOW)

  endtask

endclass