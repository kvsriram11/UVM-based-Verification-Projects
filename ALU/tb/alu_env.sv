class alu_env extends uvm_env;

  // uvm factory registration
  `uvm_component_utils(alu_env)

  // instantiate UVM sub-components for env
  alu_agent agnt;
  alu_scb   scb;

  // constructor
  function new(string name = "alu_env", uvm_component parent = null);
    super.new(name, parent);
    `uvm_info("ENV", "Inside constructor", UVM_HIGH)
  endfunction

  // build phase: create sub-components using UVM factory create method
  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    `uvm_info("ENV", "Build phase", UVM_HIGH)

    agnt = alu_agent::type_id::create("agnt", this);
    scb  = alu_scb  ::type_id::create("scb",  this);
  endfunction

  // connect phase
  function void connect_phase(uvm_phase phase);
    super.connect_phase(phase);
    `uvm_info("ENV", "Connect phase", UVM_HIGH)

    // connect monitor analysis port to scoreboard analysis imp
    agnt.mon.monitor_port.connect(scb.scb_port);
  endfunction

  // run phase
  task run_phase(uvm_phase phase);
    super.run_phase(phase);
  endtask

endclass