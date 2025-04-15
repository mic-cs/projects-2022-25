from flask import Flask, request, jsonify
from flask_cors import CORS
import PyPDF2
import docx
import io

app = Flask(__name__)
CORS(app)

def extract_text_from_pdf(file):
    pdf_reader = PyPDF2.PdfReader(file)
    text = ""
    for page in pdf_reader.pages:
        text += page.extract_text()
    return text

def extract_text_from_docx(file):
    doc = docx.Document(file)
    text = ""
    for paragraph in doc.paragraphs:
        text += paragraph.text + "\n"
    return text

@app.route('/upload', methods=['POST'])
def upload_file():
    if 'file' not in request.files:
        return jsonify({'error': 'No file part'}), 400
    
    file = request.files['file']
    if file.filename == '':
        return jsonify({'error': 'No selected file'}), 400

    try:
        file_content = file.read()
        file_stream = io.BytesIO(file_content)
        
        if file.filename.endswith('.pdf'):
            text = extract_text_from_pdf(file_stream)
        elif file.filename.endswith('.docx'):
            text = extract_text_from_docx(file_stream)
        else:
            text = file_content.decode('utf-8')
        
        return jsonify({'text': text})
    except Exception as e:
        return jsonify({'error': str(e)}), 500

if __name__ == '__main__':
    app.run(debug=True, port=5000)