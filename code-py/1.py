import os
import sys
from PIL import Image
import numpy as np
import matplotlib.pyplot as plt
from io import BytesIO
import base64

# Function to convert image to base64
def image_to_base64(img):
    buffered = BytesIO()
    img.save(buffered, format="PNG")
    img_str = base64.b64encode(buffered.getvalue()).decode()
    return f'<img src="data:image/png;base64,{img_str}"/>'

# Function to add Gaussian noise
def add_gaussian_noise(image_array, mean=0, var=0.01):
    sigma = var**0.5
    gaussian = np.random.normal(mean, sigma, image_array.shape)
    noisy_image = np.clip(image_array + gaussian, 0, 255)
    return noisy_image.astype(np.uint8)

# Function to calculate and display histogram
def plot_histogram(image_array):
    plt.figure()
    plt.hist(image_array.ravel(), bins=256, color='orange')
    plt.hist(image_array.ravel(), bins=256, color='blue', alpha=0.5)
    plt.xlabel('Pixel Value')
    plt.ylabel('Frequency')
    plt.title('Histogram')
    buf = BytesIO()
    plt.savefig(buf, format='png')
    buf.seek(0)
    plt.close()
    return Image.open(buf)

def process_images(image_dir):
    # List of image files
    image_files = [
        "aerial1.png", "aerial2.png", "astro1.png", "barche.png", "blood.png", "blood1.png", 
        "cameraman.png", "clock.png", "couple.tiff", "eight.jpg", "einstein.png", "estatua.png", 
        "football.jpg", "foto.png", "galaxia.png", "hedgebw.png", "house.tiff", "lena.jpg", 
        "leopard.png", "mandrill.tiff", "peper.tiff", "pout.png", "rice.png", "rice1.png", 
        "SBS.jpg", "woman.tiff"
    ]

    # Create HTML report
    html_content = "<html><head><title>Image Processing Report</title></head><body>"
    html_content += "<h1>Image Processing Report</h1>"

    for file in image_files:
        file_path = os.path.join(image_dir, file)
        if not os.path.exists(file_path):
            continue

        # Read image
        image = Image.open(file_path)
        image_array = np.array(image)
        
        # Original image
        html_content += f"<h2>{file}</h2>"
        html_content += "<h3>Original Image</h3>"
        html_content += image_to_base64(image)
        
        # Resize image
        resized_image = image.resize((int(image.width * 1.5), int(image.height * 1.5)))
        html_content += "<h3>Resized Image (1.5x)</h3>"
        html_content += image_to_base64(resized_image)
        
        # Rotate image
        rotated_image = image.rotate(30)
        html_content += "<h3>Rotated Image (30 degrees)</h3>"
        html_content += image_to_base64(rotated_image)
        
        # Add Gaussian noise
        noisy_image_array = add_gaussian_noise(image_array)
        noisy_image = Image.fromarray(noisy_image_array)
        html_content += "<h3>Noisy Image (Gaussian Noise)</h3>"
        html_content += image_to_base64(noisy_image)
        
        # Calculate statistics
        mean_val = np.mean(image_array)
        std_dev = np.std(image_array)
        html_content += f"<p>Mean: {mean_val:.2f}</p>"
        html_content += f"<p>Standard Deviation: {std_dev:.2f}</p>"
        
        # Plot histogram
        histogram_image = plot_histogram(image_array)
        html_content += "<h3>Histogram</h3>"
        html_content += image_to_base64(histogram_image)
        
        html_content += "<hr>"

    html_content += "</body></html>"

    # Save HTML report to file
    with open("result_1.html", "w") as f:
        f.write(html_content)

    print("Report generated: result_1.html")

if __name__ == '__main__':
    if len(sys.argv) != 2:
        print("Usage: python script.py <image_directory>")
        sys.exit(1)

    image_directory = sys.argv[1]
    process_images(image_directory)
