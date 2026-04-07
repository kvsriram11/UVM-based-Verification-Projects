class alu_pkt_seq extends uvm_sequence #(alu_packet);

  // UVM Factory Registration
  `uvm_object_utils(alu_pkt_seq)

  // Instantiate packet handle
  alu_packet pkt;

  // Standard UVM Constructor
  function new(string name = "alu_pkt_seq");
    super.new(name);
    `uvm_info("SEQ", "Inside Constructor", UVM_HIGH)
  endfunction

  // sequence is an object class, so no UVM phases required
  task body();

    repeat (2) begin
      pkt = alu_packet::type_id::create("pkt");
      start_item(pkt);
      if (!pkt.randomize() with { reset == 1; })
        `uvm_error("SEQ", "Randomization failed for reset=1 packet")
      finish_item(pkt);
    end

    repeat (5) begin
      pkt = alu_packet::type_id::create("pkt");
      start_item(pkt);
      if (!pkt.randomize() with { reset == 0; })
        `uvm_error("SEQ", "Randomization failed for reset=0 packet")
      finish_item(pkt);
    end

  endtask

endclass