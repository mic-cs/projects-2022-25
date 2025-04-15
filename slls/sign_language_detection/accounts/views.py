import random
from django.contrib.auth.models import User
from django.core.mail import send_mail
from django.shortcuts import render, redirect
from django.contrib.auth import authenticate, login, logout
from django.contrib.auth.decorators import login_required
from django.contrib import messages
from django.conf import settings
from django.http import StreamingHttpResponse, JsonResponse
import cv2
from .forms import CustomPasswordResetForm, UserRegistrationForm, LoginForm, CustomPasswordChangeForm
from django.contrib.auth import update_session_auth_hash
from super_gradients.training import models
import threading
import os
import sys

stop_video = False
video_thread = None

model = models.get('yolo_nas_s', num_classes=26, checkpoint_path='model_weights/ckpt_best.pth')


def generate_otp():
    """Generate a 6-digit OTP."""
    return str(random.randint(100000, 999999))


def send_otp_via_email(user, otp):
    """Send OTP to user's email for password reset."""
    subject = "Your OTP for Password Reset"
    message = f"Your OTP for password reset is {otp}. Use this to reset your password."
    send_mail(subject, message, settings.EMAIL_HOST_USER, [user.email])


# def register_view(request):
#     """Handle user registration."""
#     if request.method == 'POST':
#         form = UserRegistrationForm(request.POST)
#         if form.is_valid():
#             form.save()
#             messages.success(request, 'Registration successful. Please login.')
#             return redirect('login')
#         else:
#             for field, errors in form.errors.items():
#                 for error in errors:
#                     messages.error(request, f"{field}: {error}")
#     else:
#         form = UserRegistrationForm()
#     storage = messages.get_messages(request)
#     storage.used = True
#     return render(request, 'accounts/register.html', {'form': form})


# def login_view(request):
#     """Handle user login."""
#     if request.user.is_authenticated:
#         return redirect('dashboard')

#     if request.method == 'POST':
#         form = LoginForm(request.POST)
#         if form.is_valid():
#             username = form.cleaned_data.get('username')
#             password = form.cleaned_data.get('password')
#             user = authenticate(request, username=username, password=password)
#             if user is not None:
#                 login(request, user)
#                 messages.success(request, 'Login successful.')
#                 return redirect('dashboard')
#             else:
#                 messages.error(request, 'Invalid username or password.')
#         else:
#             for error in form.errors.values():
#                 messages.error(request, error)
#     else:
#         form = LoginForm()
#     storage = messages.get_messages(request)
#     storage.used = True
#     return render(request, 'accounts/login.html', {'form': form})



def dashboard_view(request):
    """User dashboard view."""
    return render(request, 'accounts/dashboard.html')


# def logout_view(request):
#     """Handle user logout."""
#     logout(request)
#     return redirect('login')

def letters(request):
    return render(request,'accounts/letter.html')

def services(request):
    return render(request,'accounts/services.html')


def password_reset_email_view(request):
    """Handle the password reset form submission."""
    if request.method == 'POST':
        form = CustomPasswordResetForm(request.POST)
        if form.is_valid():
            email = form.cleaned_data['email']
            messages.success(request, f'Password reset instructions have been sent to {email}.')
            return redirect('verify_otp')
        else:
            for error in form.errors.values():
                messages.error(request, error)
    else:
        form = CustomPasswordResetForm()
    return render(request, 'accounts/password_reset_email.html', {'form': form})


def verify_otp_view(request):
    """View for OTP verification during password reset."""
    if request.method == 'POST':
        entered_otp = request.POST.get('otp')
        if entered_otp == request.session.get('otp'):
            return redirect('password_reset_confirm')
        else:
            messages.error(request, 'Invalid OTP.')
    return render(request, 'accounts/verify_otp.html')


def password_reset_confirm_view(request):
    """View for resetting the password after OTP verification."""
    if request.method == 'POST':
        password = request.POST.get('password')
        confirm_password = request.POST.get('confirm_password')
        if password == confirm_password:
            email = request.session.get('email')
            user = User.objects.get(email=email)
            user.set_password(password)
            user.save()
            messages.success(request, 'Password reset successful. Please log in.')
            return redirect('login')
        else:
            messages.error(request, 'Passwords do not match.')
    return render(request, 'accounts/password_reset_confirm.html')


def instruction_view(request):
    """View for rendering instructions."""
    return render(request, 'accounts/instruction.html')

def     blog_view(request):
    """show the blogs."""
    return render(request, 'accounts/blogs.html')


def test_view(request):
    """View for testing the sign language detector."""
    return render(request, 'accounts/test.html')

def change_password_view(request):
    if request.method == 'POST':
        form = CustomPasswordChangeForm(user=request.user, data=request.POST) 
        if form.is_valid():
            user = form.save()  
            update_session_auth_hash(request, user)  
            messages.success(request, 'Your password has been successfully changed.')
            return redirect('dashboard')  
        else:
            for error in form.errors.values():
                messages.error(request, error)
    else:
        form = CustomPasswordChangeForm(user=request.user)  
    storage = messages.get_messages(request)
    storage.used = True
    return render(request, 'accounts/change_password.html', {'form': form})



stop_video = False
video_thread = None

def predict_sign(frame):
    """Function to predict sign language gesture from a video frame using the YOLO model."""
    result = model.predict_webcam()
    predicted_sign = result[0]["class"] if result else "None"
    return predicted_sign

def gen_frames():
    """Capture webcam feed and yield video frames with predicted sign overlaid using YOLO model."""
    global stop_video
    cap = cv2.VideoCapture(0)
    
    try:
        while not stop_video:
            success, frame = cap.read()
            if not success or stop_video:
                break
            
            # Predict sign using YOLO model
            sign_prediction = predict_sign(frame)

            # Display prediction on the frame
            cv2.putText(frame, f'Detected Sign: {sign_prediction}', (50, 50), 
                        cv2.FONT_HERSHEY_SIMPLEX, 1, (0, 255, 0), 2, cv2.LINE_AA)

            # Convert frame for streaming
            ret, buffer = cv2.imencode('.jpg', frame)
            frame = buffer.tobytes()

            yield (b'--frame\r\n'
                   b'Content-Type: image/jpeg\r\n\r\n' + frame + b'\r\n')

    finally:
        cap.release()  # Ensure camera is released when stopping


def video_feed(request):
    print('Hi')
    """Video feed view for the sign language detection."""
    global stop_video, video_thread
    stop_video = False 
    if video_thread is None or not video_thread.is_alive():
        video_thread = threading.Thread(target=gen_frames)
        video_thread.start()

    return StreamingHttpResponse(gen_frames(), content_type='multipart/x-mixed-replace; boundary=frame')

def stop_video_feed(request):
    """Stop the video feed."""
    global stop_video, video_thread
    stop_video = True 

    if video_thread is not None:
        video_thread.join(timeout=2)
        video_thread = None

   
    return JsonResponse({'status': 'stopped'})


def restart_server():
    """Function to restart the Django development server."""
    try:
        os.execv(sys.executable, ['python'] + sys.argv)
    except Exception as e:
        print(f"Error restarting the server: {e}")


def stop_and_restart_view(request):
    """View to stop video stream and restart the server."""
    global stop_video
    stop_video = True

    
    threading.Thread(target=restart_server).start()

    return JsonResponse({'status': 'restarting'})



import os
import sys
import cv2
import random
import threading
import numpy as np
import tensorflow as tf
from django.shortcuts import render, redirect
from django.http import StreamingHttpResponse, JsonResponse
from django.contrib.auth import authenticate, login, logout
from django.contrib.auth.decorators import login_required
from django.contrib import messages
from django.contrib.auth.models import User
from django.contrib.auth import update_session_auth_hash
from django.core.mail import send_mail
from django.conf import settings
from super_gradients.training import models
from .forms import CustomPasswordResetForm, UserRegistrationForm, LoginForm, CustomPasswordChangeForm
import mediapipe as mp



model_tf = tf.keras.models.load_model('model_weights/model_complete.h5')  # Update with your model's path
mp_hands = mp.solutions.hands
hands = mp_hands.Hands(static_image_mode=False, max_num_hands=1, min_detection_confidence=0.7, min_tracking_confidence=0.5)

# Define a function to preprocess each frame
def preprocess_frame(frame):
    img = cv2.resize(frame, (64, 64))  # Resize to model input size
    img = img / 255.0  # Normalize pixel values
    img = np.expand_dims(img, axis=0)  # Add batch dimension
    return img

# Define a function to overlay predictions on the frame
def overlay_predictions(frame, predictions):
    label = np.argmax(predictions)  # Get the predicted label index
    confidence = predictions[0][label]  # Get the confidence score
    cv2.putText(frame, f"Label: {label}, Confidence: {confidence:.2f}", (10, 30),
                cv2.FONT_HERSHEY_SIMPLEX, 1, (0, 255, 0), 2)
    return frame

# Generate video frames with predictions
def gen_frames_tf():
    """Capture webcam feed and yield video frames with hand detection and sign prediction for website streaming."""
    global stop_video
    cap = cv2.VideoCapture(0)
    
    if not cap.isOpened():
        print("Error: Could not open webcam.")
        return

    try:
        while not stop_video:
            ret, frame = cap.read()
            if not ret:
                print("Error: Unable to capture frame.")
                break

            # Flip frame horizontally (mirror effect)
            frame = cv2.flip(frame, 1)

            # Convert BGR to RGB for MediaPipe
            rgb_frame = cv2.cvtColor(frame, cv2.COLOR_BGR2RGB)

            # Detect hands
            results = hands.process(rgb_frame)

            if results.multi_hand_landmarks:
                for hand_landmarks in results.multi_hand_landmarks:
                    # Extract bounding box coordinates
                    h, w, _ = frame.shape
                    x_min, y_min = w, h
                    x_max, y_max = 0, 0

                    for lm in hand_landmarks.landmark:
                        x, y = int(lm.x * w), int(lm.y * h)
                        x_min = min(x_min, x)
                        y_min = min(y_min, y)
                        x_max = max(x_max, x)
                        y_max = max(y_max, y)

                    # Add padding to the bounding box
                    padding = 20
                    x_min = max(x_min - padding, 0)
                    y_min = max(y_min - padding, 0)
                    x_max = min(x_max + padding, w)
                    y_max = min(y_max + padding, h)

                    # Draw only the bounding box around the hand
                    cv2.rectangle(frame, (x_min, y_min), (x_max, y_max), (0, 255, 0), 2)

                    # Crop and preprocess the hand region
                    hand_crop = frame[y_min:y_max, x_min:x_max]
                    processed_frame = preprocess_frame(hand_crop) if hand_crop.size > 0 else np.zeros((64, 64, 3))

                    # Predict hand sign
                    predictions = model_tf.predict(processed_frame)
                    label = np.argmax(predictions)  # Predicted label index

                    # Show the label on top of the bounding box
                    cv2.putText(frame, f"Label: {label}", (x_min, y_min - 10), 
                                cv2.FONT_HERSHEY_SIMPLEX, 0.9, (0, 255, 0), 2)

            else:
                cv2.putText(frame, "No hand detected", (10, 40), 
                            cv2.FONT_HERSHEY_SIMPLEX, 1, (0, 0, 255), 2)

            # Convert frame to JPEG format for web streaming
            ret, buffer = cv2.imencode('.jpg', frame)
            frame = buffer.tobytes()

            # Yield the frame for streaming in the website
            yield (b'--frame\r\n'
                   b'Content-Type: image/jpeg\r\n\r\n' + frame + b'\r\n')

    finally:
        cap.release()



# Video feed view
def video_feed_tf(request):
    global stop_video, video_thread
    stop_video = False 
    if video_thread is None or not video_thread.is_alive():
        video_thread = threading.Thread(target=gen_frames)
        video_thread.start()
    
    return StreamingHttpResponse(gen_frames_tf(), content_type='multipart/x-mixed-replace; boundary=frame')

# View for testing the sign language detector
def number_test_view(request):
    return render(request, 'accounts/number_test.html')