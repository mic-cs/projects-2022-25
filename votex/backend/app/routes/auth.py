import asyncio
from concurrent.futures import ThreadPoolExecutor

from fastapi import APIRouter, File, Form, HTTPException, UploadFile, status

from app.models.auth_model import SendOTPRequest
from app.utils import otp as otp_util
from app.utils.face_verification import verify_face
from app.utils.firebase_client import get_user_mobile

router = APIRouter()

executor = ThreadPoolExecutor()


@router.post("/send_otp")
async def send_otp(request: SendOTPRequest):
    mobile = get_user_mobile(request.verification_id)
    if not mobile:
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND, detail="User not found"
        )
    if request.verification_id in otp_util.otp_store:
        try:
            otp_entry = otp_util.update_otp_entry(request.verification_id)
        except Exception as e:
            raise HTTPException(status_code=status.HTTP_400_BAD_REQUEST, detail=str(e))
    else:
        otp_entry = otp_util.create_otp_entry(request.verification_id)
    return {
        "message": "OTP sent successfully",
        "mobile": mobile,
        "otp": otp_entry["otp"],
    }


@router.post("/face_verification")
async def face_verification(
    verification_id: str = Form(...),
    image: UploadFile = File(...),
):
    try:
        loop = asyncio.get_running_loop()
        result = await loop.run_in_executor(
            executor, verify_face, verification_id, image
        )
        return result
    except Exception as e:
        raise HTTPException(
            status_code=status.HTTP_400_BAD_REQUEST,
            detail=str(e),
        )
