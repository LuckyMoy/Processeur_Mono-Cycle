# VHDL Monocycle Processor Project

## Project Description

This project aims to design and simulate the core of a monocycle processor using VHDL. The processor is built from basic components such as registers, multiplexers, memory banks, and an Arithmetic Logic Unit (ALU). The project involves integrating these elements to form various system blocks, including the processing unit, instruction management unit, and control unit. The functionality of the processor will first be verified through the simulation of a simple test program, followed by testing on an FPGA.

## Project Origin

This project was conducted as part of my studies at Polytech Sorbonne.

## Key Components

### 1. Processing Unit
- **Arithmetic Logic Unit (ALU)**: A 32-bit ALU that performs operations such as addition, subtraction, bitwise operations, and logical negation.
- **Register Bank**: Consisting of 16 registers of 32 bits each, facilitating read and write operations.
- **Data Memory**: A memory module that can store 64 words of 32 bits.

### 2. Instruction Management Unit
- **Instruction Memory**: A memory unit that stores the instructions to be executed by the processor.
- **Program Counter (PC)**: A 32-bit register that holds the address of the next instruction to be executed.
- **Sign Extension Unit**: Extends the sign of a smaller bit input to a 32-bit output.

### 3. Control Unit
- **Instruction Decoder**: Generates control signals based on the fetched instruction and the processor's current state.
- **Processor State Register (PSR)**: Stores the state of the processor, including flags from the ALU operations.

### 4. Vector Interrupt Controller (VIC)
- **VIC**: Manages external interrupt requests and prioritizes them. It ensures that the processor responds correctly to external events by handling interrupt signals and directing the program counter to the appropriate interrupt service routines.

### 5. UART RX/TX
- **UART (Universal Asynchronous Receiver/Transmitter)**: Facilitates serial communication. The UART module includes:
  - **Transmission (TX)**: Sends data from the processor to external devices.
  - **Reception (RX)**: Receives data from external devices and sends it to the processor.
- The UART allows the processor to communicate with external devices, such as a PC, enabling tasks like sending and receiving messages through serial communication.

## Project Objectives

1. **Design and Simulation**: Each component is described in behavioral VHDL and simulated using Modelsim or GHDL/GTKwave.
2. **Integration**: Assemble the designed components to form a fully functional processing unit, instruction management unit, control unit, VIC, and UART.
3. **Validation**: Verify the correct operation of the processor through simulation and running a test program.
4. **FPGA Implementation**: Implement the processor on an FPGA and test its functionality in a hardware environment.

## Simulation and Testing

- **Behavioral Simulation**: Using test benches to validate individual modules and the integrated processor system.
- **FPGA Testing**: Implementing the processor on an FPGA board and verifying its operation by running the test program and observing outputs.

## Skills Developed

- VHDL behavioral design and synthesis
- Digital IP core design and validation
- FPGA implementation and testing
- Handling interrupts with a Vector Interrupt Controller
- Serial communication with UART


