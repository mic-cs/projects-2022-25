from fastapi import FastAPI
from fastapi.middleware.cors import CORSMiddleware
from app.routes import voters, voting, hello_world, auth, users
from app.config import settings
from app.routes import elections

app = FastAPI()

app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

app.include_router(hello_world.router)
app.include_router(auth.router, prefix="/auth", tags=["Authentication"])
app.include_router(users.router, prefix="/api")
app.include_router(elections.router, prefix="/api")
