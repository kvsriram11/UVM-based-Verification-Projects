/*
-------------------------------------------------------------------------------
File        : mtx_scoreboard.sv
Class/Interface/Module : mtx_scoreboard
Project     : 3x3 Matrix Multiplier Verification Environment
Course      : ECE-593 Fundamentals of Pre-Silicon Validation
Author      : Venkata Sriram Kamarajugadda

Description :
    Scoreboard responsible for checking DUT correctness. It receives completed
    transactions from the output monitor, computes the expected matrix
    multiplication result using a reference model, and compares it with the
    DUT output.

Responsibilities:
    - Receive transactions from monitor via analysis port
    - Compute golden matrix multiplication result
    - Compare DUT output against expected result
    - Track pass/fail statistics
    - Collect functional coverage on important matrix values
-------------------------------------------------------------------------------
*/

import uvm_pkg::*;
`include "uvm_macros.svh"

class mtx_scoreboard extends uvm_scoreboard;

  `uvm_component_utils(mtx_scoreboard)

  // Analysis implementation port used by monitor_out to send transactions
  uvm_analysis_imp #(mtx_transaction, mtx_scoreboard) scb_port;

  // Pass/fail counters
  int pass_cnt;
  int fail_cnt;

  // Current transaction under check
  mtx_transaction tr_cur;

  // Variables used for coverage sampling
  logic [15:0] cov_a_val;
  logic [15:0] cov_b_val;


  // Functional coverage for selected matrix values
  covergroup cg_values;

    cp_a: coverpoint cov_a_val {
      bins zero = {16'h0000};
      bins one  = {16'h0001};
      bins ff   = {16'h00FF};
    }

    cp_b: coverpoint cov_b_val {
      bins zero = {16'h0000};
      bins one  = {16'h0001};
      bins ff   = {16'h00FF};
    }

    // Cross coverage between selected A and B values
    cross_ab: cross cp_a, cp_b;

  endgroup


  // Constructor
  function new(string name="mtx_scoreboard", uvm_component parent);
    super.new(name,parent);

    scb_port = new("scb_port",this);

    pass_cnt = 0;
    fail_cnt = 0;

    cg_values = new();
  endfunction


  // Called whenever monitor_out publishes a transaction
  function void write(mtx_transaction tr);

    logic [31:0] golden [2:0][2:0];

    tr_cur = tr;


    // Coverage sampling for A matrix elements
    foreach (tr_cur.A[i,j]) begin
      cov_a_val = tr_cur.A[i][j];
      cg_values.sample();
    end

    // Coverage sampling for B matrix elements
    foreach (tr_cur.B[i,j]) begin
      cov_b_val = tr_cur.B[i][j];
      cg_values.sample();
    end


    // Reference model : C = A × B
    foreach (golden[i,j]) begin

      golden[i][j] = 32'h0;

      for(int k=0;k<3;k++) begin
        golden[i][j] =
          golden[i][j] +
          (32'(tr_cur.A[i][k]) * 32'(tr_cur.B[k][j]));
      end

    end


    // Compare DUT output with golden result
    if(golden == tr_cur.C) begin

      pass_cnt++;

      `uvm_info("SCB",
        $sformatf("PASS C diag: %0h %0h %0h",
        tr_cur.C[0][0],
        tr_cur.C[1][1],
        tr_cur.C[2][2]),
        UVM_LOW)

    end
    else begin

      fail_cnt++;

      `uvm_error("SCB","Matrix multiplication mismatch")

      foreach(golden[i,j]) begin
        if(golden[i][j] != tr_cur.C[i][j]) begin

          `uvm_error("SCB",
            $sformatf(
              "Mismatch C[%0d][%0d] exp=%08h got=%08h",
               i,j,golden[i][j],tr_cur.C[i][j]
            ))

        end
      end

    end

  endfunction


  // Final summary printed at the end of simulation
  function void report_phase(uvm_phase phase);

    `uvm_info("RESULT",
      $sformatf(
        "PASS:%0d FAIL:%0d TOTAL:%0d COVERAGE:%.2f%%",
        pass_cnt,
        fail_cnt,
        pass_cnt+fail_cnt,
        cg_values.get_coverage()
      ),
      UVM_NONE)

  endfunction

endclass