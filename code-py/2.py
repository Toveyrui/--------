import cv2
import numpy as np
import matplotlib.pyplot as plt
import os
import argparse
from scipy.fft import dct
from jinja2 import Template
import base64
from io import BytesIO

# Function to display images and return as base64
def process_image(image, cmap='gray'):
    buf = BytesIO()
    plt.imshow(image, cmap=cmap)
    plt.axis('off')
    plt.savefig(buf, format='png', bbox_inches='tight', pad_inches=0)
    buf.seek(0)
    img_base64 = base64.b64encode(buf.getvalue()).decode('utf-8')
    plt.close()
    return img_base64

# (1) Discrete Fourier Transform and Discrete Cosine Transform
def dft_dct(image_path):
    image = cv2.imread(image_path, cv2.IMREAD_GRAYSCALE)
    dft = np.fft.fft2(image)
    dft_shift = np.fft.fftshift(dft)
    magnitude_spectrum = 20 * np.log(np.abs(dft_shift))

    dct_image = dct(dct(image.T, norm='ortho').T, norm='ortho')

    return {
        'original': process_image(image),
        'magnitude_spectrum': process_image(magnitude_spectrum),
        'dct_image': process_image(dct_image)
    }

# (2) Image Enhancement
def image_enhancement(image_path):
    image = cv2.imread(image_path, cv2.IMREAD_GRAYSCALE)
    equalized = cv2.equalizeHist(image)
    adjusted = cv2.convertScaleAbs(image, alpha=1.5, beta=0)

    return {
        'original': process_image(image),
        'equalized': process_image(equalized),
        'adjusted': process_image(adjusted)
    }

# (3) Smoothing and Denoising
def smoothing_denoising(image_path):
    image = cv2.imread(image_path, cv2.IMREAD_GRAYSCALE)
    noise = np.random.normal(0, 25, image.shape).astype(np.uint8)
    noisy_image = cv2.add(image, noise)
    mean_filtered = cv2.blur(noisy_image, (5, 5))
    median_filtered = cv2.medianBlur(noisy_image, 5)

    return {
        'noisy_image': process_image(noisy_image),
        'mean_filtered': process_image(mean_filtered),
        'median_filtered': process_image(median_filtered)
    }

# (4) Sharpening
def image_sharpening(image_path):
    image = cv2.imread(image_path, cv2.IMREAD_GRAYSCALE)
    kernelx = np.array([[1, 0], [0, -1]], dtype=int)
    kernely = np.array([[0, 1], [-1, 0]], dtype=int)
    roberts_x = cv2.filter2D(image, cv2.CV_16S, kernelx)
    roberts_y = cv2.filter2D(image, cv2.CV_16S, kernely)
    roberts = cv2.convertScaleAbs(roberts_x + roberts_y)

    return {
        'original': process_image(image),
        'roberts': process_image(roberts)
    }

def main(image_dir):
    results = []
    for filename in os.listdir(image_dir):
        if filename.endswith(('.png', '.jpg', '.jpeg', '.tif')):
            image_path = os.path.join(image_dir, filename)
            results.append({
                'filename': filename,
                'dft_dct': dft_dct(image_path),
                'enhancement': image_enhancement(image_path),
                'smoothing': smoothing_denoising(image_path),
                'sharpening': image_sharpening(image_path)
            })
    
    template = Template('''
    <!DOCTYPE html>
    <html lang="en">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Image Processing Results</title>
    </head>
    <body>
        <h1>Image Processing Results</h1>
        {% for result in results %}
            <h2>{{ result.filename }}</h2>
            <h3>DFT & DCT</h3>
            <img src="data:image/png;base64,{{ result.dft_dct.original }}" alt="Original">
            <img src="data:image/png;base64,{{ result.dft_dct.magnitude_spectrum }}" alt="Magnitude Spectrum">
            <img src="data:image/png;base64,{{ result.dft_dct.dct_image }}" alt="DCT Image">

            <h3>Image Enhancement</h3>
            <img src="data:image/png;base64,{{ result.enhancement.original }}" alt="Original">
            <img src="data:image/png;base64,{{ result.enhancement.equalized }}" alt="Equalized">
            <img src="data:image/png;base64,{{ result.enhancement.adjusted }}" alt="Adjusted">

            <h3>Smoothing & Denoising</h3>
            <img src="data:image/png;base64,{{ result.smoothing.noisy_image }}" alt="Noisy Image">
            <img src="data:image/png;base64,{{ result.smoothing.mean_filtered }}" alt="Mean Filtered">
            <img src="data:image/png;base64,{{ result.smoothing.median_filtered }}" alt="Median Filtered">

            <h3>Sharpening</h3>
            <img src="data:image/png;base64,{{ result.sharpening.original }}" alt="Original">
            <img src="data:image/png;base64,{{ result.sharpening.roberts }}" alt="Roberts Sharpened">
        {% endfor %}
    </body>
    </html>
    ''')
    
    html_content = template.render(results=results)
    with open('result_2.html', 'w') as f:
        f.write(html_content)

if __name__ == "__main__":
    parser = argparse.ArgumentParser(description='Process images in a directory.')
    parser.add_argument('image_dir', type=str, help='Path to the directory containing images.')
    args = parser.parse_args()
    main(args.image_dir)
