from pydantic import BaseModel, Field


class SendOTPRequest(BaseModel):
    verification_id: str = Field(..., examples=["S1894"])


class VerifyOTPRequest(BaseModel):
    verification_id: str = Field(..., examples=["S1894"])
    otp: str = Field(..., examples=["123456"])
