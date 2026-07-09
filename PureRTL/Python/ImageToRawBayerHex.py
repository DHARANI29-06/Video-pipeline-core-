import cv2
import numpy as np
import matplotlib.pyplot as plt
def generate_and_visualize_bayer(image_path, output_hex, output_image, width=1280, height=720):
    """
    Simulates a raw sensor Bayer grid from an RGB image and exports it as a 
    hex stimulus file for Verilog testbench simulation.
    """
    img = cv2.imread(image_path)
    if img is None:
        raise FileNotFoundError(f"Source image {image_path} not found.")
    img = cv2.resize(img, (width, height))
    bayer = np.zeros((height, width), dtype=np.uint8)
    bayer[0::2, 0::2] = img[0::2, 0::2, 2] 
    bayer[0::2, 1::2] = img[0::2, 1::2, 1] 
    bayer[1::2, 0::2] = img[1::2, 0::2, 1] 
    bayer[1::2, 1::2] = img[1::2, 1::2, 0] 
    print(f"[INFO] Exporting {width}x{height} Bayer grid to {output_hex}...")
    with open(output_hex, 'w') as f:
        for val in bayer.flatten():
            f.write(f"{val:02x}\n")
    print("[INFO] Rendering simulated Bayer grid...")
    plt.figure(figsize=(10, 7))
    plt.imshow(bayer, cmap='gray')
    plt.title('Simulated Bayer Pattern (Grayscale)')
    plt.axis('off')
    plt.show()
    plt.imsave(output_image, bayer, cmap='gray')
    print(f"[INFO] Bayer pattern visualization saved as {output_image}")
generate_and_visualize_bayer(
    image_path="test_image_4.jpg", 
    output_hex="input_bayer.hex", 
    output_image="bayer_pattern_visualization.png"
)
