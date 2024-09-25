import asyncio
import logging

from aiogram import Bot, Dispatcher

from app.users.lifespan import register_admin
from app.users.router import router as start_router
from .bot import bot as tg_bot

routers = [start_router]


async def on_startup(bot: Bot, dispatcher: Dispatcher) -> None:
    await register_admin()


async def on_shutdown(bot: Bot, dispatcher: Dispatcher) -> None:
    pass


dp = Dispatcher()
dp.include_routers(*routers)
dp.startup.register(on_startup)
dp.shutdown.register(on_shutdown)


def main() -> None:
    logging.basicConfig(level=logging.INFO)
    asyncio.run(dp.start_polling(tg_bot))


if __name__ == "__main__":
    try:
        main()
    except (KeyboardInterrupt, SystemExit):
        logging.info("Bot stopped")
