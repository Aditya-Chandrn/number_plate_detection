import base64
import cv2
import numpy as np
from detection_model.services.detection import detect_number_plate, detect_vehicle
from constants import IMAGE_PATH
from db import DB



async def detect(base64_string):
    npd = DB.npd
    try:
        # convert base64 string to image file
        image_data = base64.b64decode(base64_string)
        file_bytes = np.frombuffer(image_data, np.uint8)
        img = cv2.imdecode(file_bytes, cv2.IMREAD_COLOR)

        # Detect Number Plate
        vehicle_number , plate_bbox = detect_number_plate(img)
        print("***********************",vehicle_number)
        print("************************",plate_bbox )
        if  vehicle_number:
            vehicle_info = detect_vehicle(img, plate_bbox)
            vehicle_type = vehicle_info[0] if vehicle_info else "Unknown"
            print("******************************", vehicle_type)
        # get vehicle number from detection model
        # TODO: function call

        # get user data
        user = await npd.users.find_one({"vehicle_number": vehicle_number}, {"_id": 0})
        if not user:
            print("Vehicle not found from number plate")
            return {"status": 404, "message": "Vehicle not found"}

        history = await npd.cases.find(
            {"user_id": user["user_id"]}, {"_id": 0, "user_id": 0}
        ).to_list()

        user["history"] = history

        print("Vehicle detected")
        return {"status": 200, "message": "Vehicle detected", "details": user}
    except Exception as e:
        print(f"Error detecting vehicle from number plate:- \n{e}")
        return {"status": 500, "message": "Error detecting vehicle"}