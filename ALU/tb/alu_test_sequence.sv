class alu_test_sequence extends alu_base_sequence;

  `uvm_object_utils(alu_test_sequence)

  alu_packet pkt;

  // Constructor
  function new(string name = "alu_test_sequence");
    super.new(name);
    `uvm_info("TEST_SEQ", "Inside constructor", UVM_HIGH)
  endfunction

  // body task
  task body();
    `uvm_info("TEST_SEQ", "Inside body task", UVM_HIGH)

    // first send reset transaction from base sequence
    super.body();

    repeat (5) begin
      pkt = alu_packet::type_id::create("pkt");
      start_item(pkt);
      if (!pkt.randomize() with { reset == 0; })
        `uvm_error("TEST_SEQ", "Randomization failed for normal packet")
      finish_item(pkt);
    end
  endtask

endclass