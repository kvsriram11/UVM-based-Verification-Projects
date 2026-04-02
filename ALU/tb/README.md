# UVM Testbench for ALU Verification

This directory contains the complete UVM-based testbench used to verify the ALU RTL design.

The testbench follows standard UVM architecture and is designed to validate functional correctness while handling real-world verification challenges like DUT latency.

---

## UVM Testbench Architecture

<p align="center">
  <img src="../images/uvm_tb_architecture.png" width="800">
</p>

---

## Testbench Overview

The testbench is built using the Universal Verification Methodology (UVM) and includes:

- Transaction-based stimulus generation
- Driver–Sequencer communication
- Monitor-based sampling
- Scoreboard-based checking
- Virtual interface configuration

---

## UVM Components

### Sequence Item (`alu_packet.sv`)
- Defines transaction fields:
  - `a`, `b`, `op_code`, `reset`
  - `result`, `carry_out`
- Includes constraints for randomized testing

---

### Sequences
- `alu_base_sequence.sv`
  - Generates reset transaction  
- `alu_test_sequence.sv`
  - Generates randomized functional transactions  

---

### Sequencer (`alu_seqr.sv`)
- Controls flow of sequence items to the driver  

---

### Driver (`alu_drv.sv`)
- Receives transactions from sequencer  
- Drives DUT inputs via virtual interface  
- Applies stimulus on clock edge  

---

### Monitor (`alu_monitor.sv`)
- Samples DUT inputs and outputs  
- Sends transactions to scoreboard using analysis port  

---

### Agent (`alu_agent.sv`)
- Encapsulates:
  - Driver  
  - Sequencer  
  - Monitor  

---

### Scoreboard (`alu_scb.sv`)
- Computes expected results  
- Compares with DUT output  
- Reports PASS/FAIL  

---

### Environment (`alu_env.sv`)
- Instantiates agent and scoreboard  
- Connects monitor to scoreboard  

---

### Test (`alu_test.sv`)
- Builds environment  
- Starts sequences  
- Controls simulation flow  

---

### Top Module (`top.sv`)
- Instantiates DUT and interface  
- Connects UVM testbench  
- Starts simulation using `run_test()`

---

## Key Verification Insight

The ALU is a **synchronous DUT** with registered outputs:

```
Inputs at cycle N → Output at cycle N+1
```

### Challenge
- Initial mismatch between expected and actual results  

### Solution
- Implemented a **pipeline mechanism in the monitor**
- Stored previous transaction and aligned output with next cycle  

---

## Functional Coverage (Planned 🚧)

Planned enhancements include:

- Opcode coverage (ADD, SUB, MUL, DIV)
- Input combinations
- Corner cases (overflow, divide-by-zero)
- Cross coverage

---

## Simulation

Example using QuestaSim:

```
vlog -sv +incdir+tb tb/alu_pkg.sv
vsim work.top +UVM_TESTNAME=alu_test
run -all
```

---

## Files

```
tb/
├── alu_pkg.sv
├── alu_if.sv
├── alu_packet.sv
├── alu_base_sequence.sv
├── alu_test_sequence.sv
├── alu_seqr.sv
├── alu_drv.sv
├── alu_monitor.sv
├── alu_agent.sv
├── alu_scb.sv
├── alu_env.sv
├── alu_test.sv
├── top.sv
└── README.md
```

---

## Purpose

This testbench demonstrates:

- Complete UVM verification flow  
- Debugging real timing issues  
- Building scalable verification environments  

---

## Author

**Venkata Sriram Kamarajugadda**  
Master’s in Electrical & Computer Engineering  
Portland State University  
