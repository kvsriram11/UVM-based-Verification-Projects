# UVM-Based Verification Projects

![UVM](https://img.shields.io/badge/UVM-SystemVerilog-blue)
![Simulation](https://img.shields.io/badge/Simulator-QuestaSim-green)
![Status](https://img.shields.io/badge/Status-Active-success)
![License](https://img.shields.io/badge/License-MIT-yellow)

This repository contains a collection of **UVM (Universal Verification Methodology) based verification projects** focused on building strong fundamentals in **design verification** using SystemVerilog and industry-standard practices.

Each project is structured to demonstrate:
- Clean UVM architecture
- Transaction-based verification
- Debugging real verification issues
- Scalable and reusable verification environments

---

## Goals of This Repository

- Learn and implement **UVM from scratch**
- Build **modular and reusable testbenches**
- Understand **timing issues and DUT behavior**
- Practice **industry-style verification flow**
- Gradually add **coverage, assertions, and advanced DV concepts**

---

## Projects

### ALU Verification using UVM

Verification of an 8-bit synchronous ALU supporting:
- Addition
- Subtraction
- Multiplication
- Division

#### Highlights
- Complete UVM testbench (Driver, Monitor, Sequencer, Agent, Env, Test)
- Scoreboard-based checking
- Handling **1-cycle latency (pipeline alignment)**
- Debugging real timing mismatches

Location: `./ALU/`

---

## Repository Structure

```text
UVM-based-Verification-Projects/
├── ALU/
│   ├── rtl/
│   ├── tb/
│   ├── images/
│   └── README.md
│
└── README.md
```

---

## Key Concepts Covered

- UVM Components:
  - Driver
  - Monitor
  - Sequencer
  - Agent
  - Environment
  - Test

- Transaction flow using sequences
- Virtual interface configuration (`uvm_config_db`)
- TLM communication (analysis ports)
- Scoreboard implementation
- Handling synchronous DUT latency
- Debugging and waveform reasoning

---

## Verification Flow (General)

1. Sequence generates transactions  
2. Sequencer sends to Driver  
3. Driver drives DUT via interface  
4. Monitor samples DUT behavior  
5. Scoreboard validates correctness  

---

## Planned Enhancements

- Assertions (SVA)
- Coverage-driven verification
- Randomized stress testing
- More DUTs:
  - FIFO
  - UART
  - Memory Controllers
  - Protocol-based designs
  - etc

---

## License

This project is licensed under the MIT License.

---

## Author

**Venkata Sriram Kamarajugadda**  
Master’s in Electrical & Computer Engineering  
Portland State University  

---

## Final Note

This repository is a **learning journey into design verification**, evolving from basic UVM concepts to advanced industry-level verification techniques.

Stay tuned for more projects 🚀
