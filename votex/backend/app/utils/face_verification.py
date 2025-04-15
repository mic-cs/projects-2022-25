import io
import cv2
import numpy as np
import requests
from deepface import DeepFace
from fastapi import UploadFile

from app.utils.firebase_client import get_user_photo


def read_image_from_bytes(image_bytes: bytes):
    """
    Convert raw image bytes to an OpenCV (numpy) image.
    """
    image_np = np.frombuffer(image_bytes, np.uint8)
    img = cv2.imdecode(image_np, cv2.IMREAD_COLOR)
    if img is None:
        raise Exception("Invalid image data")
    return img


def verify_face(verification_id: str, uploaded_file: UploadFile) -> dict:
    """
    Retrieves the stored image from Firestore/Cloudinary and compares it with the uploaded image
    using DeepFace. Returns a dictionary with the verification result.
    """
    stored_image_url = get_user_photo(verification_id)

    # Download stored image
    response = requests.get(stored_image_url)
    if response.status_code != 200:
        raise Exception("Failed to download stored image")
    stored_image_bytes = response.content
    stored_image = read_image_from_bytes(stored_image_bytes)

    # Read the uploaded image from user
    uploaded_file_bytes = uploaded_file.file.read()
    uploaded_image = read_image_from_bytes(uploaded_file_bytes)

    # Compare the two images
    verification_result = DeepFace.verify(
        img1_path=stored_image,
        img2_path=uploaded_image,
        enforce_detection=False,
        model_name="Facenet512",
    )
    # verification_result = {"distance": 0.2, "verified": False}

    threshold = 0.5
    is_verified = (
        verification_result["distance"] <= threshold or verification_result["verified"]
    )

    return {
        "verified": is_verified,
        "distance": verification_result["distance"],
        "model": verification_result.get("model", "unknown"),
    }
