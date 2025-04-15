import base64
import mimetypes
import requests
import threading
import time
import random
import json
import tensorflow as tf
import numpy as np
import cv2
import torch
import torchvision.transforms as transforms
from PIL import Image
from flask import Flask, render_template, jsonify, request as req
from scipy.ndimage import rotate
import nltk

nltk.download('punkt')

app = Flask(__name__)

MODEL_PATH = "models/model.h5"

def load_graph():
    if not tf.io.gfile.exists(MODEL_PATH):
        raise FileNotFoundError("Model file is missing!")
    graph = tf.Graph()
    with tf.io.gfile.GFile(MODEL_PATH, "rb") as f:
        graph_def = tf.compat.v1.GraphDef()
        graph_def.ParseFromString(f.read())
        with graph.as_default():
            tf.import_graph_def(graph_def, name="")
    return graph

graph = load_graph()

def preprocess_image(image_data):
    image = cv2.imdecode(np.frombuffer(image_data.read(), np.uint8), cv2.IMREAD_COLOR)
    pil_image = Image.fromarray(image)
    image = np.array(pil_image)
    image = rotate(image, angle=random.choice([0, 90, 180, 270]), reshape=False)
    image = cv2.resize(image, (224, 224))
    image = np.expand_dims(image, axis=0)
    image = image / 255.0
    return image

def predict_image(image_data):
    with graph.as_default():
        with tf.compat.v1.Session(graph=graph) as sess:
            input_tensor = graph.get_tensor_by_name("input:0")
            output_tensor = graph.get_tensor_by_name("final_result:0")
            processed_image = preprocess_image(image_data)
            predictions = sess.run(output_tensor, {input_tensor: processed_image})
            prediction_list = predictions.tolist()
            flattened_predictions = [item for sublist in prediction_list for item in sublist]
            top_index = np.argmax(flattened_predictions)
            confidence_score = flattened_predictions[top_index]
            return f"Detected item with confidence {confidence_score:.5f}"

def get_type(file_name):
    mime_type, _ = mimetypes.guess_type(file_name)
    return mime_type if mime_type else "unknown/unknown"

@app.route('/')
def index():
    return render_template('index.html')

@app.route('/recipe/<int:recipe_id>')
def recipe(recipe_id):
    return render_template('recipe.html', recipe_id=recipe_id)

def async_task(func, *args):
    thread = threading.Thread(target=func, args=args)
    thread.start()
    return thread

@app.route('/send', methods=['POST'])
def send():
    try:
        form = req.form
        image = req.files.get('image')
        text_input = form.get('text_input', "").strip()
        recognized_text = ""
        if image:
            async_task(lambda img: print("Recognized:", predict_image(img)), image)
            recognized_text = predict_image(image)
        if text_input:
            text_input += f" Also, {recognized_text}." if recognized_text else ""
        else:
            text_input = recognized_text if recognized_text else "Suggest a recipe."
        headers = {
            "Authorization": "Bearer api03-gNgWi3dkhU8US-j3ZC5MUqeNh8zdrRJZIx80dV7oqCxAcZUieM",
            "Content-Type": "application/json"
        }
        
        response = requests.post(
            "https://chat.cloxo.co/api/chat/completions",
            headers=headers,
            json={
                "model": "cloxoai/cloxogpt",
                "messages": [{"role": "user", "content": text_input}]
            }
        )
        response_data = response.json()
        message = response_data.get("choices", [{}])[0].get("message", {}).get("content", "No response.")
        return jsonify({"recipe": message})
    except Exception as e:
        return jsonify({"error": str(e)}), 500

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=5000, debug=True)
