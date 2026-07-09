import cv2
import numpy as np
import matplotlib.pyplot as plt

def reconstruct_hardware_rgb(hex_input, output_image, width=1280, height=720):
    """
    Reads the synthesized RGB hex stream from co-simulation and reconstructs
    the final 24-bit full-color image.
    """
    print(f"[INFO] Reading simulation stream from {hex_input}...")
    with open(hex_input, 'r') as f:
        lines = [line.strip() for line in f.readlines() if line.strip()]
        
    total_expected = width * height
    print(f"[INFO] Retrieved {len(lines)} pixels. Expected {total_expected}.")
    
    pixels = []
    for h in lines:
        if all(c in '0123456789abcdefABCDEF' for c in h) and len(h) == 6:
            r = int(h[0:2], 16)
            g = int(h[2:4], 16)
            b = int(h[4:6], 16)
            pixels.append([b, g, r])
        else:
            pixels.append([0, 0, 0]) 
    if len(pixels) < total_expected:
        missing_count = total_expected - len(pixels)
        print(f"[WARN] Padding missing {missing_count} pixels with black...")
        pixels.extend([[0, 0, 0]] * missing_count)
        
    img_data = np.array(pixels[:total_expected], dtype=np.uint8)
    img_array = img_data.reshape((height, width, 3))
    cv2.imwrite(output_image, img_array)
    print(f"[INFO] Frame reconstructed successfully. Saved as {output_image}")
    plt.imshow(img_array)
    plt.axis('off')
    plt.show()
reconstruct_hardware_rgb(
    hex_input="output_rgb.hex", 
    output_image="isp_output_final.png"
)
