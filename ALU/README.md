# ALU Verification Project (UVM-Based)

![UVM](https://img.shields.io/badge/UVM-SystemVerilog-blue)
![Simulator](https://img.shields.io/badge/Simulator-QuestaSim-green)
![Status](https://img.shields.io/badge/Status-Active-success)
![License](https://img.shields.io/badge/License-MIT-yellow)

This repository contains a structured verification project for an 8-bit Arithmetic Logic Unit (ALU) using the Universal Verification Methodology (UVM).

The project is organized into multiple versions, each progressively improving the design and verification environment to reflect real-world design verification practices.

---

## Project Objective

- Build a complete UVM-based verification environment  
- Verify a synchronous ALU design  
- Handle real-world challenges such as latency and simulation synchronization  
- Progress towards coverage-driven and assertion-based verification  

---

## Versions

### 🔹 ALU-v1 (Current)

**Focus:** Functional Verification + UVM Fundamentals  

- Complete UVM testbench (driver, monitor, agent, env, test)  
- Randomized stimulus generation  
- Scoreboard-based checking  
- Pass/Fail tracking with final summary  
- Handling 1-cycle DUT latency  
- Simulation synchronization using UVM objections  

📁 Folder: `ALU-v1/`

---

### 🔹 ALU-v2 (Planned)

**Focus:** Verification Completeness  

- Functional coverage using `uvm_subscriber`  
- Assertion-based verification (SVA)  
- Carry-out verification  
- Corner-case and stress testing  
- Coverage-driven verification  

📁 Folder: `ALU-v2/` *(upcoming)*

---

## ALU Overview

The ALU supports the following operations:

| Opcode | Operation        |
|--------|------------------|
| 0000   | Addition (a + b) |
| 0001   | Subtraction      |
| 0010   | Multiplication   |
| 0011   | Division         |

---

## Key Learning Highlights

- UVM architecture and component interaction  
- Transaction-level modeling (TLM)  
- Debugging synchronous DUT latency  
- Simulation lifecycle control using objections  
- Building scalable verification environments  

---

## Repository Structure

```text
ALU/
├── ALU-v1/
│   ├── rtl/
│   ├── tb/
│   ├── run.do
│   └── README.md
├── ALU-v2/          (upcoming)
└── README.md
```

---

## Getting Started

1. Navigate to a version folder:
   ```
   cd ALU-v1
   ```

2. Run simulation using QuestaSim:
   ```
   do run.do
   ```

---

## Roadmap

- Add functional coverage  
- Introduce assertion-based verification  
- Improve DUT (carry handling, error cases)  
- Expand test scenarios  
- Move towards industry-style verification closure  

---

## License

This project is licensed under the MIT License.

---

## Author

**Venkata Sriram Kamarajugadda**  
Master’s in Electrical & Computer Engineering  
Portland State University  

---

## Notes

This project is part of a structured effort to build strong fundamentals in UVM-based design verification and evolve towards industry-level verification practices.
