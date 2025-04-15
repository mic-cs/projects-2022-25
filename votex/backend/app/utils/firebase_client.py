# backend/utils/firebase_client.py
import firebase_admin
from firebase_admin import credentials, db, firestore
from app.config import settings


# Initialize Firebase only once
if not firebase_admin._apps:
    cred = credentials.Certificate(settings.FIREBASE_SERVICE_ACCOUNT_KEY_PATH)
    firebase_admin.initialize_app(cred, {"databaseURL": settings.FIREBASE_DATABASE_URL})


def get_user_mobile(verification_id: str) -> str:
    """
    Retrieve the user's mobile number from Firebase Realtime Database.
    Assumes that user data is stored under 'students/<verification_id>' with a key "mobile".
    """
    ref = db.reference(f"students/{verification_id}")
    user_data = ref.get()
    if not user_data:
        raise Exception(f"User not found {verification_id}")
    if "phone" not in user_data:
        raise Exception(f"User Phone found {verification_id}")

    return user_data["phone"]


def get_user(verification_id: str) -> dict[str, str]:
    db_client = firestore.client()
    ref = db_client.collection("students").document(verification_id)
    user_data = ref.get()
    if not user_data.exits:
        raise Exception(f"User not found {verification_id}")
    user_data = user_data.to_dict()

    return user_data


def get_user_photo(verification_id: str) -> str:
    """
    Retrieve the user's photo from firestore.
    """
    db_client = firestore.client()
    ref = db_client.collection("students").document(verification_id)
    user_data = ref.get()
    if not user_data.exists:
        raise Exception(f"User not found {verification_id}")
    user_data = user_data.to_dict()
    if "photo" not in user_data:
        raise Exception(f"User Photo not found {verification_id}")

    return user_data["photo"]


def get_all_users():
    """
    Get all users from Firestore with verified set to False.
    """
    db_client = firestore.client()
    docs = db_client.collection("students").stream()
    users = []
    for doc in docs:
        data = doc.to_dict()
        users.append(data)

    return users


def update_field_by_verification_id(verification_id, field_name, new_value):
    """
    Updates a specific field in a Firestore document located in the 'students' collection using the provided verification_id.

    Args:
        verification_id (str): The document ID in Firestore (typically the admission number).
        field_name (str): The name of the field to update.
        new_value (any): The new value to set for the field.
    """
    db = firestore.client()
    try:
        # Update the document using its verification_id as the document id
        db.collection("students").document(verification_id).update(
            {field_name: new_value}
        )
        print(
            f"Successfully updated '{field_name}' for document with verification_id {verification_id} to {new_value}."
        )
    except Exception as e:
        print(
            f"[Error] Failed to update document with verification_id {verification_id}: {e}"
        )
