from motor.motor_asyncio import AsyncIOMotorClient
from constants import Env


class DB:
    @classmethod
    def initialize(cls):
        client = AsyncIOMotorClient(Env.MONGODB_URI)
        cls.npd = client.npd
