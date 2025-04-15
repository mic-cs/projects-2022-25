from fastapi import APIRouter

router = APIRouter()

@router.get("/voters")
def get_voters():
    return {"voters": "List of voters"}
