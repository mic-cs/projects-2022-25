from pydantic_settings import BaseSettings


class Settings(BaseSettings):
    HOST: str = "0.0.0.0"
    PORT: int = 8000

    OTP_EXPIRATION_SECONDS: int = 300
    OTP_LENGTH: int = 6
    OTP_MAX_RESENDS: int = 5

    FIREBASE_SERVICE_ACCOUNT_KEY_PATH: str = "./firebase_service.json"
    FIREBASE_DATABASE_URL: str = (
        "https://database.firebaseio.com/"
    )

    class Config:
        env_file = ".env"


settings = Settings()
