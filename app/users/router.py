from aiogram import Router, types
from aiogram.filters import CommandStart
from fast_depends import inject

from app.users.dependencies import UserServiceDep

router = Router()


@router.message(CommandStart())
@inject
async def start_command(message: types.Message, users: UserServiceDep) -> None:
    assert message.from_user
    user = await users.get_by_telegram_id(message.from_user.id)
    if not user:
        user = await users.register(
            telegram_id=message.from_user.id,
            first_name=message.from_user.first_name,
            last_name=message.from_user.last_name,
        )
    await message.answer(f"Hello, {user.display_name}!")
