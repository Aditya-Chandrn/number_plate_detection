import cv2
import pytesseract
import re
from .image_utils import preprocess_plate
from .yolo_model import load_model


def correct_plate_text(text):
    # Remove non-alphanumeric characters and convert to uppercase
    text = "".join(re.split("[^A-Z0-9]", text)).upper()

    length = len(text)  # Get the length of the extracted plate number
    if length < 9:
        return text  # If too short, return as is

    corrected_text = ""

    for i, char in enumerate(text):
        pos = i + 1  # Convert 0-based index to 1-based index

        # Determine if this position should be a letter or number
        is_letter = (length == 10 and pos in {1, 2, 5, 6}) or (
            length == 9 and pos in {1, 2, 5}
        )
        is_number = not is_letter  # Everything else should be a number

        # Correct common OCR mistakes based on position
        if char in {"O", "0"}:
            corrected_text += "O" if is_letter else "0"
        elif char in {"S", "5"}:
            corrected_text += "S" if is_letter else "5"
        elif char in {"Z", "2"}:
            corrected_text += "Z" if is_letter else "2"
        elif char in {"I", "1"}:
            corrected_text += "I" if is_letter else "1"
        elif char in {"B", "8"}:
            corrected_text += "B" if is_letter else "8"
        elif char in {"G", "6"}:
            corrected_text += "G" if is_letter else "6"
        else:
            corrected_text += char  # Keep character if it doesn’t need correction

    return corrected_text


def detect_number_plate(img):
    gray = cv2.cvtColor(img, cv2.COLOR_BGR2GRAY)
    blur = cv2.GaussianBlur(gray, (5, 5), 0)
    edges = cv2.Canny(blur, 50, 200)

    contours, _ = cv2.findContours(edges, cv2.RETR_TREE, cv2.CHAIN_APPROX_SIMPLE)
    for cnt in contours:
        x, y, w, h = cv2.boundingRect(cnt)
        aspect_ratio = w / h
        area = w * h

        if 1000 < area < 100000 and 2 < aspect_ratio < 6:
            plate_img = img[y : y + h, x : x + w]
            processed_plate = preprocess_plate(plate_img)

            text = pytesseract.image_to_string(
                processed_plate, config="--psm 8 --oem 1"
            ).strip()
            corrected_text = correct_plate_text(text)

            # Ensure corrected text has valid format & last 4 characters are alphanumeric
            if corrected_text and len(corrected_text) > 4:
                return corrected_text, (x, y, w, h)

    return None, None


def detect_vehicle(img, plate_bbox):
    model = load_model()
    px, py, pw, ph = plate_bbox

    margin_x = int(pw * 2)
    margin_y = int(ph * 3)
    x1, y1 = max(px - margin_x, 0), max(py - margin_y, 0)
    x2, y2 = min(px + pw + margin_x, img.shape[1]), min(
        py + ph + margin_y, img.shape[0]
    )
    cropped_img = img[y1:y2, x1:x2]

    results = model(cropped_img)
    vehicle_classes = {2: "car", 3: "motorcycle", 5: "bus", 7: "truck"}
    detected_vehicles = []

    for result in results:
        for box in result.boxes:
            cls = int(box.cls[0])
            conf = float(box.conf[0])
            if cls in vehicle_classes and conf > 0.6:
                detected_vehicles.append(
                    (vehicle_classes[cls], conf, box.xyxy[0].tolist())
                )

    return max(detected_vehicles, key=lambda v: v[1]) if detected_vehicles else None
