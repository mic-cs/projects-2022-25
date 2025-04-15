import cloudinary
import cloudinary.uploader
from fastapi import APIRouter, HTTPException, UploadFile
from typing import List
from pydantic import BaseModel

from app.utils.firebase_client import get_all_users, update_field_by_verification_id

cloudinary.config(
    cloud_name="demazndgq",
    api_key="547426464719655",
    api_secret="QWRg5EJN5zj61AuCtWQMZLBLQYc",
    secure=True,
)

router = APIRouter()


class User(BaseModel):
    verification_id: str
    dob: str
    name: str
    phone: str
    email: str
    photo: str
    verified: bool


@router.get("/users/unverified", response_model=List[User])
def get_unverified_users():
    users = []
    try:
        users = get_all_users()
    except:
        print("Error occured")

    return [user for user in users if not user["verified"]]


@router.get("/users", response_model=List[User])
def get_users():
    users = []
    try:
        users = get_all_users()
    except:
        print("Error")

    return [user for user in users]


@router.post("/users/{verification_id}/verify_request")
def verify_request(verification_id: str, uploaded_file: UploadFile):
    try:
        upload_result = cloudinary.uploader.upload(uploaded_file)
        cloudinary_url = upload_result.get("secure_url")
        if not cloudinary_url:
            print("[Error] Cloudinary did not return a secure URL for the file")
            return
        update_field_by_verification_id(verification_id, "selfie", cloudinary_url)
    except:
        print("[Error] Cloudinary upload failed for file")


@router.post("/users/{verification_id}/verify")
def verify_user(verification_id: str):
    if not verification_id.startswith("S"):
        raise HTTPException(status_code=400, detail="Not valid verification")
    try:
        update_field_by_verification_id(verification_id, "verified", True)
        return {"message": f"User {verification_id} verified"}
    except:
        raise HTTPException(status_code=404, detail="User not found")


@router.get("/users/{verification_id}", response_model=User)
def get_user(verification_id: str):
    if not verification_id.startswith("S"):
        raise HTTPException(status_code=400, detail="Not valid verification")
    users = get_all_users()
    for user in users:
        if user["verification_id"] == verification_id:
            return user


class RejectRequest(BaseModel):
    reason: str


@router.post("/users/{verification_id}/reject")
def reject_user(verification_id: str, request: RejectRequest):
    try:
        update_field_by_verification_id(verification_id, "selfie", "")
        return {"message": f"User {verification_id} rejected. Reason {request.reason}"}
    except:
        raise HTTPException(status_code=404, detail="User not found")
