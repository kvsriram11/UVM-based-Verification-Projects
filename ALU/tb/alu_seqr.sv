class alu_seqr extends uvm_sequencer #(alu_packet);

  // UVM factory registration
  `uvm_component_utils(alu_seqr)

  function new(string name = "alu_seqr", uvm_component parent = null);
    super.new(name, parent);
    `uvm_info("SEQR", "Inside Constructor", UVM_HIGH)
  endfunction

  // Build Phase
  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    `uvm_info("SEQR", "Build Phase", UVM_HIGH)
  endfunction

  // Connect Phase
  function void connect_phase(uvm_phase phase);
    super.connect_phase(phase);
    `uvm_info("SEQR", "Connect Phase", UVM_HIGH)
  endfunction

endclass