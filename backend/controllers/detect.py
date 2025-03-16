import base64

from constants import IMAGE_PATH
from db import DB


async def detect(base64_string):
    npd = DB.npd
    try:
        # convert base64 string to image file
        image_data = base64.b64decode(base64_string)
        with open(IMAGE_PATH, "wb") as f:
            f.write(image_data)

        # get vehicle number from detection model
        # TODO: function call
        vehicle_number = "DL10CD5678"

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
