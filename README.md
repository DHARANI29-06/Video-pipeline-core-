# Video Pipeline Core
**Theme II - Video Processing & Multimedia Systems** \
**Track C: Video Pipeline Core**

<div>
  <table>
    <tr>
      <td style="border: 2px solid #58a6ff; border-radius: 10px; padding: 20px;">
        <br>
        <img src="https://img.shields.io/badge/TEAM-SynthCore -black?style=for-the-badge&logo=architectural-digest&logoColor=white" style="width: 300px; max-width: 100%;"/>
        <br><br>
        <pre align="left">
<pre align="left">
┌──────────────────────────────────────────────────────────┐
│   <b>Our Team</b>                                               │
├──────────────────────────────────────────────────────────┤
│   > <b>Ranjith Ganesh B</b>                                     │
│   > <b>Royce Niran George A</b>                                 │
│   > <b>Dharani M</b>                                            │
│   > <b>Dharshini A</b>                                          │
└──────────────────────────────────────────────────────────┘
</pre>
        <sub> 🏗️ <i>Synthesizing Logic. Optimizing Latency. Driven by RTL.</i> </sub>
        <br><br>
      </td>
    </tr>
  </table>
</div>
---
          
## Project Overview

This project implements a hardware-accelerated Video Pipeline Core for FPGA-based embedded systems. The design captures raw video input, synchronizes incoming frames, performs real-time image processing, and streams the processed video output with minimal latency.

Traditional software-based video pipelines often suffer from processing delays and increased CPU utilization, making them unsuitable for real-time surveillance, multimedia, and broadcasting applications. By implementing the complete video pipeline as a dedicated FPGA IP Core, the system achieves high throughput, deterministic timing, and efficient hardware resource utilization.

The Video Pipeline Core consists of four major functional blocks:

Video Input Handling
Frame Synchronization
Image Processing
Video Streaming Output

The architecture is fully modular, enabling easy integration into larger FPGA/ASIC-based vision systems.

---

## System Architecture

The following architecture illustrates the complete video processing pipeline implemented on the FPGA.

                 +----------------------+
                 |  Video Input Source  |
                 | (Camera/Test Pattern)|
                 +----------+-----------+
                            |
                            v
                +-----------------------+
                | Video Input Handling  |
                | Resolution Detection  |
                | Frame Capture         |
                +----------+------------+
                           |
                           v
               +------------------------+
               | Frame Synchronization  |
               | Frame Alignment        |
               | Timing Control         |
               +----------+-------------+
                          |
                          v
               +------------------------+
               | Image Processing Block |
               | Brightness Adjustment  |
               | Grayscale Conversion   |
               | Edge Detection/Filter  |
               +----------+-------------+
                          |
                          v
               +------------------------+
               | Video Streaming Output |
               | Display Interface      |
               | Video Transmission     |
               +----------+-------------+
                          |
                          v
                  Processed Video Output

---

## Project Structure

```text
ROBOCHIPX-hackathon-SynthCore/
│
├── hardware/                         # HLS & Vivado System Integration Artifacts
│   ├── design_1_wrapper.bit          # Compiled physical bitstream file
│   ├── design_1_wrapper.hwh          # Hardware handoff file for PYNQ
│   └── design_source.png             # Block design / Vivado IP integrator screenshot
│
├── src/                              # High-Level Synthesis & Jupyter Source Code
│   └── hls.cpp                       # C++ Source code for Vitis HLS IP generation
├── notebooks/                    
│   └── ISP.ipynb                     # PYNQ Driver & Video processing notebook
│
├── data/                             # HLS Flow Test Data & PYNQ Results
│   ├── test_image_4.jpg              # Original input image for testing
│   └── processed/                    
│       ├── pynq_cpu_output.png       # Image processed by the ARM CPU
│       ├── pynq_hardware_output.png  # Image processed by the FPGA HLS Core
│       └── simulated_bayer_grid.png  # Grayscale visual of the raw Bayer grid
│
├── PureRTL/                          # Independent Pure RTL Workflow
│   ├── RTL/                          # Verilog Hardware Description Files
│   │   ├── line_buffer.v             # $3x3$ Stencil rolling line buffer
│   │   ├── isp_top.v                 # Top-level Demosaicing module
│   │   └── tb_isp_core.v             # Testbench for behavioral simulation
│   │
│   ├── Python/                       # Pre- & Post-Processing scripts for simulation
│   │   ├── ImageToRawBayerHex.py     # Converts .jpg to simulated raw hex stimulus
│   │   └── OutputHexToImage.py       # Reconstructs Verilog output hex back to image
│   │
│   ├── hex/                          # Simulation Data Streams
│   │   ├── input_bayer.hex           # Input stimulus generated by Python
│   │   └── output_rgb.hex            # Output file dumped by Verilog testbench
│   │
│   └── images/                       # Pure RTL Verification Results
│       ├── test_image_4.jpg          # Original image used for RTL testing
│       ├── bayer_pattern_visualization.png # Visual of the input Bayer grid
│       ├── simulation_output.png     # Raw terminal/wave output evidence
│       └── isp_output_final.png      # Reconstructed color image from simulation
│
├── README.md                         # Main repository landing page & summary
├── manual.md                         # Technical manual & implementation guide
├── proof_of_concept.md               # Deliverables mapping & evaluation proofs
└── project_report.pdf                # Overall report of the project```
```
---

## 🛠️ What We Did: Step-by-Step
<details> <summary><b>🔹 Step 1: Video Input Handling</b></summary>
Designed a hardware module to capture raw video data from an input source.
Implemented support for continuous frame acquisition.
Managed pixel data flow with minimal latency.
Ensured compatibility with different frame sizes and resolutions.
</details>
<details> <summary><b>🔹 Step 2: Frame Synchronization Module</b></summary>
Developed a synchronization unit to align incoming video frames.
Managed frame start/end signals and timing synchronization.
Prevented frame loss and maintained continuous video streaming.
Generated synchronization status for reliable pipeline operation.
</details>

<details> <summary><b>🔹 Step 3: Image Processing Block</b></summary>
  
Implemented basic image enhancement techniques in hardware.
Added grayscale conversion and brightness adjustment.
Designed filtering operations for improved image quality.
Optimized processing logic to reduce FPGA resource utilization while maintaining real-time performance.

</details>
<details> <summary><b>🔹 Step 4: Video Streaming Output</b></summary>
Developed the output module to stream processed video frames.
Maintained synchronization between input and output pipelines.
Ensured continuous real-time video transmission.
Verified stable output through simulation and FPGA implementation.
</details>

---
## Track Milestones Reached

- Designed the complete Video Pipeline Core architecture.

- Implemented the Video Input Handling module.

- Developed the Frame Synchronization module.

- Implemented the Image Processing block.

- Integrated the Video Streaming Output module.

- Verified module functionality using Verilog testbenches.

- Simulated the complete pipeline in Vivado.

- Optimized the design for low latency and efficient FPGA resource utilization.

- Achieved a modular IP Core suitable for FPGA/ASIC integration.

This version closely matches your hackathon problem statement and is structured like the demo README, but it focuses on the required Video Pipeline Core modules instead of the ISP demosaicing example.

---

### 📍 Future Roadmap (Conceptual Design)
* Auto White Balance (AWB): Integrating global accumulators to measure the ambient average of the frame and apply independent red/blue multipliers to remove artificial lighting tints.
* Noise Reduction: Introducing a $3\times3$ sliding Median Filter directly in front of the demosaicing stage to neutralize dead pixels and salt-and-pepper camera noise.
* Tone Mapping: Building hardware Look-Up Tables (LUTs) to compress raw wide-range sensor captures into pleasing, natural-looking 8-bit visual displays.

---

## 📖 Technical Manual & Execution Guide

For a detailed, step-by-step technical guide on how to build, simulate, and deploy this project, please refer to the dedicated [**manual.md**](manual.md) file.

The manual includes complete instructions for both development paths:
* **HLS IP Flow:** C-Synthesis in Vitis HLS, IP generation, block design automation in Vivado, bitstream generation, and execution via the PYNQ framework on Jupyter Notebook.
* **Pure RTL IP Flow:** Raw Bayer stimulus generation using Python, behavioral simulation in Vivado XSIM via the TCL console, and data reconstruction back to standard color image frames.

---

## Snapshots

### PYNQ-Z2 FPGA BOARD 
![IMG_20260328_152340 jpg](https://github.com/user-attachments/assets/6108e55e-2c4b-4662-b471-92f83a845e6a)
<img width="1600" height="1204" alt="image" src="https://github.com/user-attachments/assets/b1311d43-4608-4780-be1e-8d53b44ed530" />

---

### RAW BAYER IMAGE GENERATION USING PYTHON
<img width="991" height="343" alt="image" src="https://github.com/user-attachments/assets/a3d3a193-d618-4622-a723-b7d7e98044ee" />

---

### FPGA INFERENCE FOR IMAGE SIGNAL PROCESSOR CORE
<img width="600" height="336" alt="image" src="https://github.com/user-attachments/assets/24ed649f-06ac-467f-8b54-8c64ee209dfd" />

---

### CPU INFERENCE FOR IMAGE SIGNAL PROCESSOR CORE
<img width="756" height="410" alt="image" src="https://github.com/user-attachments/assets/7c74f8ad-2cdd-4f68-bb2c-8c2e39b26cee" />

---

### COMPARISION BETWEEN CPU AND FPGA
<img width="1007" height="520" alt="image" src="https://github.com/user-attachments/assets/e8b4d8af-2ff1-4305-acf9-0e788dcdfec1" />

---

### INPUT IMAGE (PURE RTL)
<img width="576" height="336" alt="image" src="https://github.com/user-attachments/assets/4d7015ca-88a1-4705-853c-6ee4ffe5dc32" />

---

### CONVERTED TO RAW BAYER IMAGE (PURE RTL)
<img width="973" height="583" alt="im age" src="https://github.com/user-attachments/assets/f0d7ae9c-e09a-4aa3-b61c-7478efd5d6e4" />

---

### OUTPUT IMAGE (PURE RTL)
<img width="636" height="441" alt="image" src="https://github.com/user-attachments/assets/009eb932-275d-480d-8d47-be2d9dc3bccc" />

---

## Conclusion

The **Video Pipeline Core** successfully demonstrates a hardware-based solution for real-time video processing on FPGA. The system integrates video input handling, frame synchronization, image processing, and video streaming into a unified pipeline, ensuring low latency and efficient resource utilization. Its modular architecture allows easy integration into FPGA/ASIC-based applications such as surveillance, broadcasting, and multimedia systems. This project provides a scalable foundation for future enhancements, including advanced image processing, multi-stream video support, and AI-assisted video analytics.

---

<div align="center">
 
---
 
![Built with](https://img.shields.io/badge/Built_with-Vitis_HLS-0d1117?style=flat-square&labelColor=58a6ff)
![](https://img.shields.io/badge/Deployed_on-PYNQ--Z2-0d1117?style=flat-square&labelColor=3fb950)
![](https://img.shields.io/badge/Verified_in-Vivado_XSIM-0d1117?style=flat-square&labelColor=f0883e)
![](https://img.shields.io/badge/RTL-Verilog-0d1117?style=flat-square&labelColor=ff7b72)
 
**RTL ARCHITECTS** — *Synthesizing Logic. Optimizing Latency. Driven by RTL.*
 
</div>
