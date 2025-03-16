from db import DB
from datetime import datetime


async def apply_fine(user_id: int, fine: int):
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
        total_fine = fine * (1 + 0.1 * num_open_cases)

        # create new case
        new_case = {
            "user_id": user_id,
            "fine": total_fine,
            "status": False,
            "timestamp": datetime.now().strftime("%Y-%m-%dT%H:%M:%S"),
        }
        await npd.cases.insert_one(new_case)

        # get history
        history = (
            await npd.cases.find({"user_id": user_id}, {"_id": 0})
            .sort("timestamp", -1)
            .to_list()
        )

        print(f"Fine applied to user ID {user_id}")
        return {
            "status": 200,
            "message": "Fine applied successfully",
            "history": history,
        }
    except Exception as e:
        print(f"Error applying fine to user {user_id}:- \n{e}")
        return {"status": 500, "message": "Error applying fine"}
