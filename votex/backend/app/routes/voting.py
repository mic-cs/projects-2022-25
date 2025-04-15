from fastapi import APIRouter
import requests
from flask import request, jsonify
from pydantic import BaseModel

router = APIRouter()


class TallyUpdate(BaseModel):
    tally: int
    tally_account: str


@router.post("/vote")
def cast_vote():
    """
    Receives JSON with 'election_id', 'voter_id', and 'candidate_id'
    and calls the Microfab RPC endpoint to invoke the 'CastVote' function.
    """
    data = request.get_json()
    election_id = data.get("election_id")
    voter_id = data.get("voter_id")
    candidate_id = data.get("candidate_id")

    if not all([election_id, voter_id, candidate_id]):
        return (
            jsonify(
                {
                    "error": "Missing required parameters: election_id, voter_id, candidate_id"
                }
            ),
            400,
        )

    payload = {
        "jsonrpc": "2.0",
        "method": "invokeChaincode",
        "params": {
            "channel": "mychannel",
            "chaincode": "voting_chaincode",
            "fcn": "CastVote",
            "args": [election_id, voter_id, candidate_id],
        },
        "id": 1,
    }

    rpc_url = "http://localhost:7051/"

    try:
        rpc_response = requests.post(rpc_url, json=payload)
        rpc_response.raise_for_status()
        result = rpc_response.json()

        if "error" in result:
            return jsonify({"error": result["error"]}), 500

        vote_receipt = result.get("result")
        return jsonify({"vote_receipt": vote_receipt}), 200

    except Exception as e:
        return jsonify({"error": str(e)}), 500


@router.post("/solana/update_tally")
async def update_solana_tally(update: TallyUpdate):

    payer = Keypair()
    try:
        response = await update_tally(update.tally, update.tally_account, payer)
        return {"result": response}
    except Exception as e:
        raise HTTPException(status_code=500, detail=str(e))
