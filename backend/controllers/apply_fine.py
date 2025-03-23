from db import DB
from datetime import datetime

cases = {
    0: {"reason": "Speeding over limit", "fine": 500},
    1: {"reason": "Jumping a red light", "fine": 1000},
    2: {"reason": "Driving without a license", "fine": 2000},
    3: {"reason": "Not wearing a seatbelt", "fine": 300},
    4: {"reason": "Using a mobile phone while driving", "fine": 1000},
    5: {"reason": "Illegal parking", "fine": 500},
    6: {"reason": "Driving under the influence", "fine": 5000},
    7: {"reason": "Riding without a helmet", "fine": 500},
    8: {"reason": "No valid insurance", "fine": 1500},
    9: {"reason": "Overloading passengers", "fine": 800},
}


async def apply_fine(user_id: int, reasons: list):
    npd = DB.npd
    try:
        # check user
        user = await npd.users.find_one({"user_id": user_id}, {"_id": 0})
        if not user:
            print(f"User {user_id} not found")
            return {"status": 404, "message": "Person not found"}

        # find open cases and calculate fine
        num_open_cases = await npd.cases.count_documents(
            {"status": False, "user_id": user_id}
        )

        fine = 0
        for reason in reasons:
            fine += cases[reason]["fine"]

        total_fine = fine * (1 + 0.1 * num_open_cases)

        # create new case
        new_case = {
            "user_id": user_id,
            "fine": total_fine,
            "reasons": sorted(reasons),
            "status": False,
            "timestamp": datetime.now().strftime("%Y-%m-%dT%H:%M:%S"),
        }
        await npd.cases.insert_one(new_case)

        # get history
        history = await npd.cases.find(
            {"user_id": user["user_id"]}, {"_id": 0, "user_id": 0}
        ).to_list()

        user["history"] = history

        print(f"Fine applied to user ID {user_id}")
        return {
            "status": 200,
            "message": "Fine applied successfully",
            "details": user,
        }
    except Exception as e:
        print(f"Error applying fine to user {user_id}:- \n{e}")
        return {"status": 500, "message": "Error applying fine"}
