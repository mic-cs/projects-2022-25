from flask import Flask, Response, render_template, jsonify, request
import cv2
import numpy as np
from collections import Counter
from keras.models import load_model
from keras.preprocessing.image import img_to_array
import os
from time import time
basepath = os.path.dirname(__file__)
face_classifier = cv2.CascadeClassifier(os.path.join(basepath, "haarcascade_frontalface_default.xml"))
classifier = load_model(os.path.join(basepath, 'model.h5'))
emotion_labels = ['Angry', 'Disgust', 'Fear', 'Happy', 'Neutral', 'Sad', 'Surprise']
app = Flask(__name__)
dominant_emotion = None
detection_in_progress = False
detection_completed = False
def gen_frames():
    global dominant_emotion, detection_in_progress, detection_completed
    cap = cv2.VideoCapture(0)
    start_time = None
    emotions_detected = []
    while True:
        success, frame = cap.read()
        if not success:
            break
        gray = cv2.cvtColor(frame, cv2.COLOR_BGR2GRAY)
        faces = face_classifier.detectMultiScale(gray)
        if len(faces) > 0 and not detection_in_progress and not detection_completed:
            detection_in_progress = True
            start_time = time()
            emotions_detected.clear()
        if detection_in_progress:
            for (x, y, w, h) in faces:
                cv2.rectangle(frame, (x, y), (x + w, y + h), (0, 255, 255), 2)
                roi_gray = gray[y:y + h, x:x + w]
                roi_gray = cv2.resize(roi_gray, (48, 48), interpolation=cv2.INTER_AREA)
                if np.sum([roi_gray]) != 0:
                    roi = roi_gray.astype('float') / 255.0
                    roi = img_to_array(roi)
                    roi = np.expand_dims(roi, axis=0)
                    prediction = classifier.predict(roi)[0]
                    label = emotion_labels[prediction.argmax()]
                    emotions_detected.append(label)
                    cv2.putText(frame, label, (x, y), cv2.FONT_HERSHEY_SIMPLEX, 1, (0, 255, 0), 2)
        if detection_in_progress and start_time and time() - start_time > 10:
            detection_in_progress = False
            detection_completed = True
            if emotions_detected:
                dominant_emotion = Counter(emotions_detected).most_common(1)[0][0]
            else:
                dominant_emotion = "none"
            print(f"Dominant Emotion: {dominant_emotion}")
        _, buffer = cv2.imencode('.jpg', frame)
        frame = buffer.tobytes()
        yield (b'--frame\r\n'
               b'Content-Type: image/jpeg\r\n\r\n' + frame + b'\r\n')
@app.route('/video_feed')
def video_feed():
    return Response(gen_frames(),
                    mimetype='multipart/x-mixed-replace; boundary=frame')
@app.route('/get_emotion')
def get_emotion():
    global dominant_emotion, detection_completed
    if request.args.get('reset') == 'true':
        global detection_in_progress
        detection_in_progress = False
        detection_completed = False
        dominant_emotion = None
        print("Detection state reset.")
    if not detection_completed:
        return jsonify({"status": "waiting"})  
    elif dominant_emotion == "none":
        return jsonify({"status": "failed"})  
    else:
        return jsonify({"status": "success", "emotion": dominant_emotion})  
@app.route('/happy')
def happy_page():
    return render_template('activity/happy.html')
@app.route('/sad')
def sad_page():
    return render_template('activity/sad.html')
@app.route('/angry')
def angry_page():
    return render_template('activity/angry.html')
@app.route('/surprised')
def surprised_page():
    return render_template('activity/surprised.html')
@app.route('/neutral')
def neutral_page():
    return render_template('activity/neutral.html')
@app.route('/fear')
def fear_page():
    return render_template('activity/fear.html')
@app.route('/activity')
def activity_page():
    return render_template('activity.html')
@app.route('/music')
def music_page():
    return render_template('music.html')
@app.route('/task')
def task_page():
    return render_template('task.html')
@app.route('/music_happy')
def music_happy_page():
    return render_template('music/happy.html')
@app.route('/music_sad')
def music_sad_page():
    return render_template('music/sad.html')
@app.route('/music_angry')
def music_angry_page():
    return render_template('music/angry.html')
@app.route('/music_surprised')
def music_surprised_page():
    return render_template('music/surprised.html')
@app.route('/music_neutral')
def music_neutral_page():
    return render_template('music/neutral.html')
@app.route('/music_fear')
def music_fear_page():
    return render_template('music/fear.html')
@app.route('/')
def index():
    return render_template('index.html')
if __name__ == '__main__':
    app.run(debug=True)