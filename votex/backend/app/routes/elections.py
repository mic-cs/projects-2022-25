from fastapi import APIRouter, HTTPException
from typing import List, Optional
from pydantic import BaseModel

router = APIRouter()


class Election(BaseModel):
    id: str
    name: str
    description: Optional[str] = None
    status: str = "pending"  # ("pending", "started", "stopped")
    candidates: List[dict] = []
    voters: List[dict] = []


class Candidate(BaseModel):
    id: str
    name: str
    party: Optional[str] = None


class ElectionReport(BaseModel):
    election_id: str
    results: dict
    analytics: dict


elections_db = {}


@router.get("/elections", response_model=List[Election])
def list_elections():
    return list(elections_db.values())


def get_election(id: str):
    election = elections_db.get(id)
    if not election:
        raise HTTPException(status_code=404, detail="Election not found")
    return election


def create_election(election: Election):
    if election.id in elections_db:
        raise HTTPException(status_code=400, detail="Election already exists")
    elections_db[election.id] = election
    return election


def update_election(id: str, updated_data: Election):
    if id not in elections_db:
        raise HTTPException(status_code=404, detail="Election not found")
    elections_db[id] = updated_data
    return updated_data
