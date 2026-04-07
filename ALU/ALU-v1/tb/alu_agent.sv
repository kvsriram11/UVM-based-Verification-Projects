class alu_agent extends uvm_agent;

  // uvm factory registration
  `uvm_component_utils(alu_agent)

  // instantiate subcomponents
  alu_drv     drv;
  alu_monitor mon;
  alu_seqr    seqr;

  // Standard UVM Constructor
  function new(string name = "alu_agent", uvm_component parent = null);
    super.new(name, parent);
    `uvm_info("AGENT", "Inside Constructor", UVM_HIGH)
  endfunction

  // build phase
  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    `uvm_info("AGENT", "Build Phase", UVM_HIGH)

    drv  = alu_drv    ::type_id::create("drv",  this);
    mon  = alu_monitor::type_id::create("mon",  this);
    seqr = alu_seqr   ::type_id::create("seqr", this);
  endfunction

  // Connect Phase
  function void connect_phase(uvm_phase phase);
    super.connect_phase(phase);
    `uvm_info("AGENT", "Connect phase", UVM_HIGH)

    drv.seq_item_port.connect(seqr.seq_item_export);
  endfunction

  // Run Phase
  task run_phase(uvm_phase phase);
    super.run_phase(phase);
    `uvm_info("AGENT", "Run phase", UVM_HIGH)
  endtask

endclass