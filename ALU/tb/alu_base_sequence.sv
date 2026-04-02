class alu_base_sequence extends uvm_sequence #(alu_packet);

  `uvm_object_utils(alu_base_sequence)

  alu_packet reset_pkt;

  // Constructor
  function new(string name = "alu_base_sequence");
    super.new(name);
    `uvm_info("BASE_SEQ", "Inside Constructor", UVM_HIGH)
  endfunction

  // Body Task
  task body();
    `uvm_info("BASE_SEQ", "Inside Body Task", UVM_HIGH)

    reset_pkt = alu_packet::type_id::create("reset_pkt");
    start_item(reset_pkt);
    if (!reset_pkt.randomize() with { reset == 1; })
      `uvm_error("BASE_SEQ", "Randomization failed for reset packet")
    finish_item(reset_pkt);
  endtask

endclass