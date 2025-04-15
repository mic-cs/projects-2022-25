from pydantic import BaseModel, EmailStr, Field, HttpUrl
from datetime import date


class UserData(BaseModel):
    name: str = Field(..., description="User's full name", examples=["John Doe"])
    verification_id: str = Field(
        ..., description="User's verification id", examples=["S1234"]
    )
    phone: str = Field(
        ..., description="User's phone number", examples=["+91112334455"]
    )
    email: EmailStr = Field(
        ..., description="User's email", examples=["john.doe@gmail.com"]
    )
    dob: date = Field(..., description="User's date of birth", examples=["2000-01-01"])
    photo: HttpUrl = Field(
        ...,
        description="URL of user's photo",
        examples=["https://example.com/images/john.jpeg"],
    )

    class Config:
        schema_extra = {
            "example": {
                "name": "John Doe",
                "admission_no": "A1234567",
                "phone": "+1234567890",
                "email": "john.doe@example.com",
                "dob": "2000-01-01",
                "photo": "https://example.com/images/john.jpeg",
            }
        }
