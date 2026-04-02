# ALU Verification using UVM

![UVM](https://img.shields.io/badge/UVM-SystemVerilog-blue)
![Simulation](https://img.shields.io/badge/Simulator-QuestaSim-green)
![Status](https://img.shields.io/badge/Status-Working-success)
![License](https://img.shields.io/badge/License-MIT-yellow)

This project demonstrates the verification of an 8-bit Arithmetic Logic Unit (ALU) using the Universal Verification Methodology (UVM).

The focus is on building a clean UVM testbench from scratch and verifying a synchronous DUT while handling real-world verification challenges like pipeline latency.

---

## Overview

The ALU supports the following operations:

| Opcode | Operation        |
|--------|------------------|
| 0000   | Addition (a + b) |
| 0001   | Subtraction      |
| 0010   | Multiplication   |
| 0011   | Division         |

### Inputs
- `a` : 8-bit input  
- `b` : 8-bit input  
- `alu_sel` : 4-bit opcode  
- `reset`, `clock`

### Outputs
- `alu_out` : 8-bit result  
- `carryout` : carry flag  

---

## Key Learning Outcomes

- UVM testbench architecture (driver, monitor, sequencer, agent, env, test)
- Sequence-based stimulus generation
- Virtual interface configuration (`uvm_config_db`)
- TLM communication (analysis ports)
- Scoreboard-based checking
- Handling 1-cycle DUT latency
- Debugging timing mismatches in synchronous designs

---

## DUT Architecture

<p align="center">
  <img src="./images/alu_dut.png" width="500">
</p>

### Notes
- The ALU is a synchronous design
- Output is registered
- Result appears 1 clock cycle after inputs

---

## UVM Testbench Architecture

<p align="center">
  <img src="./images/uvm_tb_architecture.jpeg" width="800">
</p>

### Flow

1. Sequence generates transactions  
2. Sequencer → Driver sends stimulus  
3. Driver drives inputs to DUT via interface  
4. Monitor samples inputs and outputs  
5. Scoreboard compares expected vs actual  

---

## Important Design Insight

Since the DUT is synchronous, output has a 1-cycle delay:

Inputs at cycle N → Output at cycle N+1

### Problem faced
- Initial mismatch: correct inputs paired with wrong outputs  

### Solution
- Implemented a pipeline mechanism in the monitor  
- Stored previous transaction and attached next cycle output  

---

## Functional Coverage (Planned)

Coverage model will be added to improve verification completeness:

- Opcode coverage (ADD, SUB, MUL, DIV)
- Input value ranges
- Corner cases (overflow, divide-by-zero)
- Cross coverage between operands and operations

---

## 📁 Directory Structure

```text
ALU/
├── rtl/
│   ├── alu.v
│   └── README.md
├── tb/
│   ├── alu_pkg.sv
│   ├── alu_if.sv
│   ├── alu_packet.sv
│   ├── alu_base_sequence.sv
│   ├── alu_test_sequence.sv
│   ├── alu_seqr.sv
│   ├── alu_drv.sv
│   ├── alu_monitor.sv
│   ├── alu_agent.sv
│   ├── alu_scb.sv
│   ├── alu_env.sv
│   ├── alu_test.sv
│   ├── top.sv
│   └── README.md
├── run.do
└── images/
    ├── alu_dut.png
    └── uvm_tb_architecture.png

```

## Sample Output

[DRV] Driving packet: a=13 b=3 op_code=2
[MON] Sampled packet: a=13 b=3 result=39
[SCB] Transaction passed: ACT=39, EXP=39
---

## Future Improvements

- Add functional coverage model
- Add assertions for protocol checking
- Randomized stress testing
- Extend ALU operations
- Coverage-driven verification
---

## License

This project is licensed under the MIT License.

MIT License

Copyright (c) 2026 Venkata Sriram Kamarajugadda

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files...


---

## Author

**Venkata Sriram Kamarajugadda**  
Master’s in Electrical & Computer Engineering  
Portland State University  

---

## Notes

This project is part of a growing collection of UVM-based verification projects aimed at mastering industry-level design verification techniques.
