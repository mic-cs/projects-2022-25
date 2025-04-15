from fastapi import APIRouter

router = APIRouter()

@router.get("/hello-world")
def get_voters():
    return 'hello world'
