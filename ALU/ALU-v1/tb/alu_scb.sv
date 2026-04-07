class alu_scb extends uvm_scoreboard;

  // uvm factory registration
  `uvm_component_utils(alu_scb)

  // Define Analysis TLM interface port
  uvm_analysis_imp #(alu_packet, alu_scb) scb_port;

  // queue for sequence items
  alu_packet trans[$];

  // counters
  int total_tests;
  int pass_tests;
  int fail_tests;

  // standard uvm constructor
  function new(string name = "alu_scb", uvm_component parent = null);
    super.new(name, parent);
    total_tests = 0;
    pass_tests  = 0;
    fail_tests  = 0;
    `uvm_info("SCB", "Inside constructor", UVM_HIGH)
  endfunction

  // build phase
  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    `uvm_info("SCB", "Build phase", UVM_HIGH)

    // Create analysis port object
    scb_port = new("scb_port", this);
  endfunction

  // connect phase
  function void connect_phase(uvm_phase phase);
    super.connect_phase(phase);
    `uvm_info("SCB", "Connect phase", UVM_HIGH)
  endfunction

  // write method
  function void write(alu_packet pkt);
    trans.push_back(pkt);
  endfunction

  // run phase
  task run_phase(uvm_phase phase);
    alu_packet curr_trans;

    super.run_phase(phase);
    `uvm_info("SCB", "Run phase", UVM_HIGH)

    forever begin
      wait(trans.size() != 0);
      curr_trans = trans.pop_front();
      compare(curr_trans);
    end
  endtask

  // Generate expected result and compare with actual
  task compare(alu_packet curr_trans);
    logic [7:0] expected;
    logic [7:0] actual;

    total_tests++;

    case (curr_trans.op_code)
      0: expected = curr_trans.a + curr_trans.b;
      1: expected = curr_trans.a - curr_trans.b;
      2: expected = curr_trans.a * curr_trans.b;
      3: begin
           if (curr_trans.b == 0) begin
             expected = 8'hFF;
             `uvm_warning("SCB", $sformatf("Divide by zero detected for transaction %0d", total_tests))
           end
           else
             expected = curr_trans.a / curr_trans.b;
         end
      default: expected = 8'hFF;
    endcase

    actual = curr_trans.result;

    if (actual != expected) begin
      fail_tests++;
      `uvm_error("SCB", $sformatf("Transaction %0d failed: a=%0d, b=%0d, op=%0d, ACT=%0d, EXP=%0d",
                                  total_tests, curr_trans.a, curr_trans.b, curr_trans.op_code, actual, expected))
    end
    else begin
      pass_tests++;
      `uvm_info("SCB", $sformatf("Transaction %0d passed: a=%0d, b=%0d, op=%0d, ACT=%0d, EXP=%0d",
                                 total_tests, curr_trans.a, curr_trans.b, curr_trans.op_code, actual, expected), UVM_LOW)
    end
  endtask

  // final summary at end of simulation
  function void report_phase(uvm_phase phase);
    super.report_phase(phase);
    `uvm_info("SCB_SUMMARY",
      $sformatf("\n=====================================\nTOTAL TEST CASES = %0d\nPASSED           = %0d\nFAILED           = %0d\n=====================================",
                total_tests, pass_tests, fail_tests),
      UVM_NONE)
  endfunction

endclass
/*class alu_scb extends uvm_scoreboard;

  // uvm factory registration
  `uvm_component_utils(alu_scb)

  // Define Analysis TLM interface port
  uvm_analysis_imp #(alu_packet, alu_scb) scb_port;

  // queue for sequence items
  alu_packet trans[$];

  // standard uvm constructor
  function new(string name = "alu_scb", uvm_component parent = null);
    super.new(name, parent);
    `uvm_info("SCB", "Inside constructor", UVM_HIGH)
  endfunction

  // build phase
  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    `uvm_info("SCB", "Build phase", UVM_HIGH)

    // Create analysis port object
    scb_port = new("scb_port", this);
  endfunction

  // connect phase
  function void connect_phase(uvm_phase phase);
    super.connect_phase(phase);
    `uvm_info("SCB", "Connect phase", UVM_HIGH)
  endfunction

  // write method
  function void write(alu_packet pkt);
    trans.push_back(pkt);
  endfunction

  // run phase
  task run_phase(uvm_phase phase);
    alu_packet curr_trans;

    super.run_phase(phase);
    `uvm_info("SCB", "Run phase", UVM_HIGH)

    forever begin
      wait(trans.size() != 0);
      curr_trans = trans.pop_front();
      compare(curr_trans);
    end
  endtask

  // Generate expected result and compare with actual
  task compare(alu_packet curr_trans);
    logic [7:0] expected;
    logic [7:0] actual;

    case (curr_trans.op_code)
      0: expected = curr_trans.a + curr_trans.b;
      1: expected = curr_trans.a - curr_trans.b;
      2: expected = curr_trans.a * curr_trans.b;
      3: expected = curr_trans.a / curr_trans.b;
      default: expected = 8'hFF;
    endcase

    actual = curr_trans.result;

    if (actual != expected) begin
      `uvm_error("SCB", $sformatf("Transaction failed: ACT=%0d, EXP=%0d", actual, expected))
    end
    else begin
      `uvm_info("SCB", $sformatf("Transaction passed: ACT=%0d, EXP=%0d", actual, expected), UVM_LOW)
    end
  endtask

endclass*/