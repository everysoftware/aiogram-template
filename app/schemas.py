from typing import Optional

import pydantic
from pydantic import BaseModel


class BotBase(BaseModel):
    pass


class OpenID(BotBase):
    id: str
    email: Optional[pydantic.EmailStr] = None
    first_name: Optional[str] = None
    last_name: Optional[str] = None
    display_name: Optional[str] = None
    picture: Optional[str] = None
    provider: str
