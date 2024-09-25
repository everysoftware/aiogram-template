from typing import Annotated

from fast_depends import Depends

from app.users.service import UserService

UserServiceDep = Annotated[UserService, Depends(UserService)]
