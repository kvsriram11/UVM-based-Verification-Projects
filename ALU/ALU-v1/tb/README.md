# UVM Testbench for ALU Verification (ALU-v1)

This directory contains the complete UVM-based testbench used to verify the ALU RTL design.

The testbench follows standard UVM architecture and is designed to validate functional correctness while handling real-world verification challenges such as DUT latency and simulation synchronization.

---

## UVM Testbench Architecture

<p align="center">
  <img src="../images/uvm_tb_architecture.jpeg" width="800">
</p>

---

## Testbench Overview

The testbench is built using the Universal Verification Methodology (UVM) and includes:

- Transaction-based stimulus generation  
- Driver–Sequencer communication  
- Monitor-based sampling  
- Scoreboard-based checking  
- Virtual interface configuration  
- Pass/Fail tracking with final summary  

---

## UVM Components

### Sequence Item (`alu_packet.sv`)
- Defines transaction fields:
  - `a`, `b`, `op_code`, `reset`
  - `result`, `carry_out`
- Includes constraints for randomized testing  

---

### Sequences

#### `alu_base_sequence.sv`
- Generates reset transaction  

#### `alu_test_sequence.sv`
- Generates **20 randomized functional transactions**  
- Constrained to valid operations (`op_code = 0–3`)  
- Prevents divide-by-zero for division  

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
- Handles **1-cycle latency alignment**  
- Sends transactions to scoreboard via analysis port  

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
- Tracks:
  - Total testcases  
  - Passed transactions  
  - Failed transactions  
- Prints final summary at end of simulation  

Example summary:

```text
=====================================
TOTAL TEST CASES = 20
PASSED           = 20
FAILED           = 0
=====================================
```

---

### Environment (`alu_env.sv`)
- Instantiates agent and scoreboard  
- Connects monitor to scoreboard using analysis port  

---

### Test (`alu_test.sv`)
- Builds environment  
- Starts reset and test sequences  
- Uses UVM objections to control simulation  
- Ensures all transactions are processed before ending simulation  

---

### Top Module (`top.sv`)
- Instantiates DUT and interface  
- Connects UVM testbench  
- Starts simulation using `run_test()`

---

## Key Verification Insights

### 1. DUT Latency Handling

The ALU is a synchronous design:

```
Inputs at cycle N → Output at cycle N+1
```

#### Issue Faced
- Incorrect comparison due to misaligned input-output pairing  

#### Solution
- Implemented a **pipeline mechanism in the monitor**  
- Stored previous transaction and aligned it with next cycle output  

---

### 2. Simulation Synchronization Issue

#### Issue Faced
- Simulation ended before all transactions were verified  
- Scoreboard reported fewer testcases than expected  

#### Root Cause
- `phase.drop_objection()` was called before all transactions propagated  

#### Solution
- Added synchronization in test to ensure:
  - All transactions are captured  
  - Scoreboard processes all inputs  
  - Final report reflects complete execution  

---

## Files

```text
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

## Current Limitations (ALU-v1)

- Functional coverage not implemented  
- No assertion-based verification  
- Carry-out signal not verified  
- Limited corner-case exploration  

---

## Future Improvements (ALU-v2)

- Add functional coverage using `uvm_subscriber`  
- Add SystemVerilog assertions (SVA)  
- Introduce coverage-driven verification  
- Add carry-out verification  
- Expand corner-case testing  

---

## Purpose

This testbench demonstrates:

- Complete UVM verification flow  
- Debugging real timing issues  
- Building scalable and modular verification environments  

---

## Author

**Venkata Sriram Kamarajugadda**  
Master’s in Electrical & Computer Engineering  
Portland State University  
