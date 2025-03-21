import cv2
import pytesseract
import re
from detection_model.utils.image_utils import preprocess_plate  
from detection_model.models.yolo_model import load_model



def correct_plate_text(text):
    text = "".join(re.split("[^A-Z0-9]", text)).upper()
    corrected_text = ""

    for i, char in enumerate(text):
        if char in {'O', '0'}:
            prev_char = text[i - 1] if i > 0 else None
            next_char = text[i + 1] if i < len(text) - 1 else None

            if prev_char and prev_char.isalpha() and next_char and next_char.isdigit():
                corrected_text += '0'  # If a letter is before it and a number is after it, it's zero
            elif prev_char and prev_char.isdigit() and next_char and next_char.isdigit():
                corrected_text += '0'  # If it's between numbers, it's zero
            else:
                corrected_text += 'O'  # Otherwise, assume 'O'
        else:
            corrected_text += char

    # Fix known license plate format errors
    if re.match(r"^[A-Z]{2}O\d", corrected_text):
        corrected_text = corrected_text[:2] + '0' + corrected_text[3:]  # Replace 'O' with '0' in state code

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
            plate_img = img[y:y + h, x:x + w]
            processed_plate = preprocess_plate(plate_img)

            text = pytesseract.image_to_string(processed_plate, config="--psm 8 --oem 1")
            corrected_text = correct_plate_text(text)

            if len(corrected_text) > 4:
                return corrected_text, (x, y, w, h)
    
    return None, None


def detect_vehicle(img, plate_bbox):
    model = load_model()
    px, py, pw, ph = plate_bbox
    
    margin_x = int(pw * 2)
    margin_y = int(ph * 3)
    x1, y1 = max(px - margin_x, 0), max(py - margin_y, 0)
    x2, y2 = min(px + pw + margin_x, img.shape[1]), min(py + ph + margin_y, img.shape[0])
    cropped_img = img[y1:y2, x1:x2]
    
    results = model(cropped_img)
    vehicle_classes = {2: "car", 3: "motorcycle", 5: "bus", 7: "truck"}
    detected_vehicles = []
    
    for result in results:
        for box in result.boxes:
            cls = int(box.cls[0])
            conf = float(box.conf[0])
            if cls in vehicle_classes and conf > 0.6:
                detected_vehicles.append((vehicle_classes[cls], conf, box.xyxy[0].tolist()))
    
    return max(detected_vehicles, key=lambda v: v[1]) if detected_vehicles else None