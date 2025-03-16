from os import getenv, path


class Env:
    @classmethod
    def initialize(cls):
        cls.HOST = getenv("HOST", "127.0.0.1")
        cls.PORT = int(getenv("PORT", 8000))
        cls.DEV_ENV = bool(int(getenv("DEV_ENV", 1)))
        cls.CLIENT = getenv("CLIENT")
        cls.MONGODB_URI = getenv("MONGODB_URI")


IMAGE_PATH = path.abspath("detection_model/input.jpg")
