class alu_test extends uvm_test;

  `uvm_component_utils(alu_test)

  alu_env           env;
  alu_base_sequence reset_seq;
  alu_test_sequence test_seq;

  // Constructor
  function new(string name = "alu_test", uvm_component parent = null);
    super.new(name, parent);
    `uvm_info("TEST", "Inside constructor", UVM_HIGH)
  endfunction

  // build phase
  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    `uvm_info("TEST", "Build phase", UVM_HIGH)

    env = alu_env::type_id::create("env", this);
  endfunction

  // end of elaboration phase topology
  virtual function void end_of_elaboration_phase(uvm_phase phase);
    super.end_of_elaboration_phase(phase);
    uvm_top.print_topology();
  endfunction

// start of simulation phase
virtual function void start_of_simulation_phase(uvm_phase phase);
  super.start_of_simulation_phase(phase);

  $display("ALU: start_of_simulation_phase reached at time %0t", $time);

  `uvm_info("ALU","  +===========================================================+",UVM_NONE)
  `uvm_info("ALU","  |                                                           |",UVM_NONE)
  `uvm_info("ALU","  |     |||||     ||        ||   ||                            |",UVM_NONE)
  `uvm_info("ALU","  |    ||   ||    ||        ||   ||                            |",UVM_NONE)
  `uvm_info("ALU","  |    ||   ||    ||        ||   ||                            |",UVM_NONE)
  `uvm_info("ALU","  |    |||||||    ||        ||   ||                            |",UVM_NONE)
  `uvm_info("ALU","  |    ||   ||    ||        ||   ||                            |",UVM_NONE)
  `uvm_info("ALU","  |    ||   ||    ||        ||   ||                            |",UVM_NONE)
  `uvm_info("ALU","  |    ||   ||    ||||||     |||||                             |",UVM_NONE)
  `uvm_info("ALU","  |                                                           |",UVM_NONE)
  `uvm_info("ALU","  +===========================================================+",UVM_NONE)
endfunction

  // connect phase
  function void connect_phase(uvm_phase phase);
    super.connect_phase(phase);
    `uvm_info("TEST", "Connect phase", UVM_HIGH)
  endfunction

  // run phase
  task run_phase(uvm_phase phase);
    super.run_phase(phase);
    `uvm_info("TEST", "Run phase", UVM_HIGH)

    phase.raise_objection(this);

    reset_seq = alu_base_sequence::type_id::create("reset_seq");
    reset_seq.start(env.agnt.seqr);

    test_seq = alu_test_sequence::type_id::create("test_seq");
    test_seq.start(env.agnt.seqr);

    phase.drop_objection(this);
  endtask

endclass