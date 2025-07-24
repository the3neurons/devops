from flask import Flask, request, jsonify
from PIL import Image
import numpy as np
import io
import base64
import joblib
import os
app = Flask(__name__)

# print all file in directory and pwd
print(os.listdir('.'))
print(os.getcwd())
model = joblib.load("model.joblib")

def preprocess_image(image):
    image = image.resize((32, 32))
    image_array = np.array(image).astype("float32") / 255.0
    return image_array.flatten().reshape(1, -1)

@app.route("/predict", methods=["POST"])
def predict():
    # Récupère l'image (soit via multipart/form-data, soit base64)
    if request.files.get("image"):
        file = request.files["image"]
        img = Image.open(file).convert("RGB")
    else:
        data = request.get_json(force=True)
        img_bytes = base64.b64decode(data["image"])
        img = Image.open(io.BytesIO(img_bytes)).convert("RGB")

    features = preprocess_image(img)

    pred = model.predict(features)[0]
    label = "cat" if pred == 0 else "dog"

    return jsonify({"prediction": label})

if __name__ == "__main__":
    port = int(os.environ.get("PORT", 8000), debug=True)
    app.run(host="0.0.0.0", port=port)
