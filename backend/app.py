from quart import Quart
from dotenv import load_dotenv

from router import router
from constants import Env
from db import DB


if __name__ == "__main__":
    load_dotenv()
    Env.initialize()
    DB.initialize()

    app = Quart(__name__)
    app.register_blueprint(router)

    app.run(host=Env.HOST, port=Env.PORT, debug=Env.DEV_ENV)
