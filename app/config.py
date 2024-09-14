from pydantic import AnyHttpUrl
from pydantic_settings import BaseSettings, SettingsConfigDict


class AppSettings(BaseSettings):
    bot_token: str
    callback_url: AnyHttpUrl

    model_config = SettingsConfigDict(extra="allow", env_file=".env")


settings = AppSettings()
