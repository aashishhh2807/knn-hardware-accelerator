# KNN Hardware Accelerator

## Overview
This project implements a **K-Nearest Neighbors (KNN) accelerator** in **Verilog HDL**.  
The design performs distance computation, top-K selection, and classification using hardware modules.

---

## Features
- Hardware implementation of KNN algorithm
- Parallel distance computation
- Top-K nearest neighbor selection
- Voting-based classification
- Modular RTL design
- FPGA compatible

---

## Architecture Modules
- Distance Engine
- Top-K Selector
- Voting Logic
- Instruction Memory
- Program Counter (PC)
- Decoder
- Latency Counter

---

## File Structure

```
knn-hardware-accelerator/
├── src/
│   ├── knn_processor_top.v
│   ├── knn_system_l.v
│   ├── pc.v
│   ├── decoder.v
│   ├── instruction_memory.v
│   ├── distance_engine.v
│   ├── top_k_selector.v
│   ├── voting_logic.v
│   ├── training_data.v
│   └── latency_counter.v
│
├── testbench/
│   └── tb_knn_system.v
│
├── data/
│   └── query.mem
│
└── README.md
```

---

## Tools Used
- Verilog HDL
- ModelSim
- Intel Quartus Prime

---

## Applications
- Machine Learning Acceleration
- Edge AI Systems
- FPGA-based AI Inference
- 
