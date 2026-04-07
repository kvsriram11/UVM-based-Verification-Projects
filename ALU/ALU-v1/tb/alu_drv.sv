class alu_drv extends uvm_driver #(alu_packet);

  `uvm_component_utils(alu_drv)

  virtual alu_if vif;
  alu_packet pkt;

  function new(string name = "alu_drv", uvm_component parent = null);
    super.new(name, parent);
    `uvm_info("DRV", "Inside Constructor", UVM_HIGH)
  endfunction

  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    `uvm_info("DRV", "Build Phase", UVM_HIGH)

    if (!(uvm_config_db #(virtual alu_if)::get(this, "*", "vif", vif))) begin
      `uvm_error("DRV", "Failed to get VIF from config DB")
    end
  endfunction

  task run_phase(uvm_phase phase);
    super.run_phase(phase);
    `uvm_info("DRV", "Run Phase", UVM_HIGH)

    forever begin
      seq_item_port.get_next_item(pkt);

      // drive before DUT samples on next posedge
      @(negedge vif.clock);
      vif.reset   <= pkt.reset;
      vif.a       <= pkt.a;
      vif.b       <= pkt.b;
      vif.alu_sel <= pkt.op_code;

      `uvm_info("DRV",
        $sformatf("Driving packet: reset=%0d a=%0d b=%0d op_code=%0d",
                  pkt.reset, pkt.a, pkt.b, pkt.op_code),
        UVM_MEDIUM)

      seq_item_port.item_done();
    end
  endtask

endclass