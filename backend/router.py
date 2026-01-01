from quart import request, jsonify, Blueprint
from controllers import detect, apply_fine

router = Blueprint("router", __name__, url_prefix="/api")


###### DETECT ######
@router.route("/detect", methods=["POST"])
async def detect_route():
    req = await request.get_json()
    base64_string = req.get("base64_string")

    result = await detect(base64_string)
    return jsonify(
        {"message": result.get("message"), "details": result.get("details")}
    ), result.get("status")


###### APPLY FINE ######
@router.route("/apply-fine", methods=["POST"])
async def apply_fine_route():
    req = await request.get_json()
    user_id = int(req.get("user_id"))
    reasons = req.get("reasons")
    print(user_id, reasons)

    result = await apply_fine(user_id, reasons)
    return jsonify(
        {"message": result.get("message"), "details": result.get("details")}
    ), result.get("status")


@router.route("/hello", methods=["GET"])
async def hello():
    return "hello"
