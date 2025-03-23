import cv2
import numpy as np


def preprocess_plate(plate_img):
    gray = cv2.cvtColor(plate_img, cv2.COLOR_BGR2GRAY)
    gray = cv2.bilateralFilter(gray, 11, 17, 17)  # Reduce noise

    # Super-resolution upscale for better OCR
    scale_factor = 2.0
    height, width = gray.shape[:2]
    gray = cv2.resize(
        gray,
        (int(width * scale_factor), int(height * scale_factor)),
        interpolation=cv2.INTER_CUBIC,
    )

    _, thresh = cv2.threshold(gray, 0, 255, cv2.THRESH_BINARY + cv2.THRESH_OTSU)
    # resized_thresh = cv2.resize(thresh, (0, 0), fx=0.5, fy=0.5)

    # Display the resized preprocessed image
    # cv2.imshow("Preprocessed Image (Resized threshold image)", thresh)
    # cv2.waitKey(2000)  # Wait for 2 seconds
    # cv2.destroyAllWindows()  # Close the image window

    return thresh
