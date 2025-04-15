import random
import string
import time
from app.config import settings
from twilio.rest import Client

otp_store = {}


def generate_otp(length: int = settings.OTP_LENGTH) -> str:
    """Generate a numeric OTP of a given length."""
    return "".join(random.choices(string.digits, k=length))


def create_otp_entry(verification_id: str) -> dict:
    """Create and store a new OTP entry for the provided verification ID."""
    otp = generate_otp()
    current_time = int(time.time())
    expiration_time = current_time + settings.OTP_EXPIRATION_SECONDS
    otp_store[verification_id] = {
        "otp": otp,
        "expires_at": expiration_time,
        "resend_count": 0,
    }
    return otp_store[verification_id]


def update_otp_entry(verification_id: str) -> dict:
    """
    Update an existing OTP entry if a user requests to resend the OTP.
    Raises an exception if the maximum resend limit is reached.
    """
    entry = otp_store.get(verification_id)
    if entry:
        if entry["resend_count"] >= settings.OTP_MAX_RESENDS:
            raise Exception("Maximum OTP resends reached")
        otp = generate_otp()
        current_time = int(time.time())
        expiration_time = current_time + settings.OTP_EXPIRATION_SECONDS
        entry["otp"] = otp
        entry["expires_at"] = expiration_time
        entry["resend_count"] += 1
        otp_store[verification_id] = entry
        return entry
    # If no entry exists, create one
    return create_otp_entry(verification_id)


def verify_otp_entry(verification_id: str, otp: str) -> bool:
    """
    Verify that the provided OTP is correct and has not expired.
    Returns True if the OTP is valid; otherwise, False.
    """
    entry = otp_store.get(verification_id)
    if not entry:
        return False
    current_time = int(time.time())
    if current_time > entry["expires_at"]:
        # OTP has expired; remove the entry.
        otp_store.pop(verification_id, None)
        return False
    if entry["otp"] == otp:
        # Successful verification; remove the OTP entry.
        otp_store.pop(verification_id, None)
        return True
    return False


def send_otp(phone: str) -> str:
    client = Client(settings.ACCOUNT_SID, settings.AUTH_TOKEN)
    verification = client.verify.v2.services(
        "VA679662e3457aca8da4922c98ec64030e"
    ).verifications.create(to=phone, channel="sms")

    return verification.sid
