# 🧩 ALU RTL Design

This directory contains the RTL implementation of an 8-bit Arithmetic Logic Unit (ALU).

The design is written in Verilog and serves as the Device Under Test (DUT) for UVM-based verification.

---

## 📌 Overview

The ALU performs basic arithmetic operations based on a 4-bit control signal (`alu_sel`).

---

## 🖼️ DUT Architecture

<p align="center">
  <img src="../images/alu_dut.png" width="500">
</p>

---

## ⚙️ Supported Operations

| Opcode | Operation        |
|--------|------------------|
| 0000   | Addition (a + b) |
| 0001   | Subtraction      |
| 0010   | Multiplication   |
| 0011   | Division         |
| Others | Default (0xFF)   |

---

## 📥 Inputs

- `clock`   : System clock  
- `reset`   : Active-high reset  
- `a`       : 8-bit input operand  
- `b`       : 8-bit input operand  
- `alu_sel` : 4-bit operation select  

---

## 📤 Outputs

- `alu_out`  : 8-bit result  
- `carryout` : Carry flag (valid for addition)  

---

## 🧠 Design Details

- The ALU is a **synchronous design**
- Output is **registered on the clock edge**
- Uses combinational logic to compute intermediate results
- Final output is updated on the next clock cycle

---

## 🔄 Timing Behavior

- Inputs are sampled at the clock edge  
- Output is produced after **1 clock cycle delay**  

```
Inputs at cycle N → Output at cycle N+1
```

---

## 📁 File

```
alu.v
```

---

## ⚠️ Notes

- Division operation does not include divide-by-zero protection
- Carry flag is only meaningful for addition
- Default case outputs `8'hFF`

---

## 🚀 Purpose

This RTL is used as a DUT for:
- UVM-based functional verification
- Debugging timing behavior
- Understanding synchronous design concepts

---

## 👨‍💻 Author

**Venkata Sriram Kamarajugadda**
