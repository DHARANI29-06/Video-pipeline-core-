# Implementation Guide

## For HLS IP
1. **Generate the IP:** Open Vitis HLS and load [hls.cpp](/src/hls.cpp).
2. **Synthesis & Export:** Run C-Synthesis and then **Export RTL** to package the design.
3. **Vivado Integration:** Open your design source in Vivado and add the exported IP to the repository.
4. **Block Automation:** Connect all IP blocks (Zynq PS, DMA, and ISP Core) as per the [design source](/hardware/design_source.png).
5. **Set Top:** Create an HDL wrapper for the design and set it as the **Top** module.
6. **Bitstream Generation:** Run Synthesis, Implementation, and finally **Generate Bitstream**.
7. **PYNQ Transfer:** Locate the [.bit](/hardware/design_1_wrapper.bit) and [.hwh](/hardware/design_1_wrapper.hwh) files in the project folder and upload them to the Jupyter workspace on your PYNQ board.
8. **Inference:** Write the [Python inference code](/notebooks/ISP.ipynb) in a Jupyter notebook.
9. **Execution:** Update the file paths for the source images in the notebook and run the cells to view the output.

---

## For Pure RTL IP
1. **HDL Development:** Write and verify [line_buffer.v](/PureRTL/RTL/line_buffer.v), [isp_top.v](/PureRTL/RTL/isp_top.v), and [tb_isp_core.v](/PureRTL/RTL/tb_isp_core.v).
2. **Stimulus Generation:** Use the provided [Python script](/PureRTL/Python/ImageToRawBayerHex.py) to convert a raw Bayer image into a `input_bayer.hex` stimulus file.
3. **Environment Setup:** Copy the generated `.hex` file into the project simulation folder (typically `\ISP.sim\sim_1\behav\xsim`).
4. **Run Simulation:** Launch the behavioral simulation and execute `run 100ms` (or the required frame time) in the TCL console.
5. **Data Export:** The simulation will generate an `output_rgb.hex` file in same path (`\ISP.sim\sim_1\behav\xsim`).
6. **Reconstruction:** Move the output hex file back to the [Python script](/PureRTL/Python/OutputHexToImage.py) to reconstruct and visualize the final image.
