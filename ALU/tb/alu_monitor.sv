class alu_monitor extends uvm_monitor;

  `uvm_component_utils(alu_monitor)

  virtual alu_if vif;
  alu_packet pkt;

  uvm_analysis_port #(alu_packet) monitor_port;

  function new(string name = "alu_monitor", uvm_component parent = null);
    super.new(name, parent);
    `uvm_info("MON", "Inside constructor", UVM_HIGH)
  endfunction

  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    `uvm_info("MON", "Build phase", UVM_HIGH)

    monitor_port = new("monitor_port", this);

    if (!(uvm_config_db #(virtual alu_if)::get(this, "*", "vif", vif))) begin
      `uvm_error("MON", "Failed to get VIF from config DB")
    end
  endfunction

  function void connect_phase(uvm_phase phase);
    super.connect_phase(phase);
    `uvm_info("MON", "Connect phase", UVM_HIGH)
  endfunction

  task run_phase(uvm_phase phase);
    alu_packet prev_pkt;

    super.run_phase(phase);
    `uvm_info("MON", "Run phase", UVM_HIGH)

    forever begin
      @(posedge vif.clock);

      // Step 1: capture current inputs
      pkt = alu_packet::type_id::create("pkt");

      pkt.reset   = vif.reset;
      pkt.a       = vif.a;
      pkt.b       = vif.b;
      pkt.op_code = vif.alu_sel;

      // Step 2: attach previous cycle output
      if ((prev_pkt != null) && (!prev_pkt.reset)) begin
        prev_pkt.result    = vif.alu_out;
        prev_pkt.carry_out = vif.carryout;

        monitor_port.write(prev_pkt);

        `uvm_info("MON",
          $sformatf("Sampled packet: a=%0d b=%0d op=%0d result=%0d",
                    prev_pkt.a, prev_pkt.b, prev_pkt.op_code, prev_pkt.result),
          UVM_MEDIUM)
      end

      // Step 3: shift pipeline
      prev_pkt = pkt;
    end
  endtask

endclass