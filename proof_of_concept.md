## Architecture & Modularity
### Our ISP Core is designed with a strictly modular architecture. The system is partitioned into three distinct stages: a Digital Gain Control front-end, a sliding-window Line Buffer, and a Bilinear Demosaicing engine. This modularity allows for the seamless integration of future IP blocks, such as Noise Reduction or Auto White Balance, into the existing AXI4-Stream pipeline without re-architecting the core data path.
#### <img width="1563" height="763" alt="image" src="https://github.com/user-attachments/assets/753b9ead-8a02-4e2b-ae5c-2aa093e35d6d" />

## IP through Pure RTL
#### <img width="296" height="207" alt="image" src="https://github.com/user-attachments/assets/81d5501a-30f0-4951-8681-e6c0b565ea2b" />

## IP through HLS
#### <img width="285" height="159" alt="image" src="https://github.com/user-attachments/assets/83baf124-37c7-44fd-a2db-0dbd97fb45f1" />

## Performance Metrics (Throughput, Latency, & Real-Time)
### To meet real-time automotive and industrial vision requirements, the IP core is optimized for high-throughput streaming. After an initial latency of two image rows (required for line-buffer filling), the core achieves a steady-state throughput of one pixel per clock cycle. At a 100MHz clock frequency, this translates to a processing capability of over 80 FPS for 720p HD video, comfortably exceeding the 60 FPS real-time threshold.
#### <img width="1160" height="521" alt="image" src="https://github.com/user-attachments/assets/7ff2e3d7-bbd7-4842-8d0b-2154872c4673" />

## Arithmetic Choices & Hardware Efficiency
### We justified the use of Fixed-Point arithmetic (4.4 format) over floating-point to maximize hardware efficiency and minimize power consumption. Floating-point units require significant DSP and LUT resources, which are unnecessary for 8-bit image data. Our fixed-point implementation utilizes simple bit-shifts and integer multipliers, reducing the silicon footprint while maintaining high accuracy for demosaicing and gain scaling.
#### <img width="683" height="255" alt="image" src="https://github.com/user-attachments/assets/dc9079e3-172f-4236-848c-5154ba3ca094" /> <img width="556" height="115" alt="image" src="https://github.com/user-attachments/assets/bd08d60f-b0ac-42b0-8ced-6dc30c0c2be5" />

## Verification & Signal Correctness
### Functional verification was conducted through a multi-stage approach to ensure signal processing correctness. A Python-based 'Golden Model' was used to generate expected pixel values, which were then compared against the hardware output from our RTL testbench simulation. The zero-error result across a full 720p frame confirms the mathematical integrity of our hardware-accelerated ISP core.
#### <img width="1032" height="339" alt="image" src="https://github.com/user-attachments/assets/a01e280f-910a-445b-9e42-d5f27876e5af" />

## Power-Performance Trade-offs
### By offloading the ISP tasks from the ARM CPU to dedicated FPGA fabric, we achieved a significant power-performance gain. While the CPU would require high clock speeds and multiple cores to process HD video (leading to high thermal output), our RTL implementation performs the same task at a low 100MHz frequency with near-zero CPU load, making it ideal for power-constrained embedded and automotive systems.
#### <img width="397" height="295" alt="image" src="https://github.com/user-attachments/assets/fcab1aab-7393-4f12-bdfc-364f0f6652ea" />

## Scalability Roadmap
### Our scalability roadmap targets production-grade features. The modular AXI-Stream architecture allows for the future integration of Auto White Balance (AWB) using global accumulators and Noise Reduction using median filters. We also plan to implement Tone Mapping via Look-Up Tables (LUTs) to support 10/12-bit raw sensor data

