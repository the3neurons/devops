from flask import Flask, request, jsonify
import joblib

app = Flask(__name__)
model = joblib.load("model.pkl")

@app.route("/predict", methods=["POST"])
def predict():
    data = request.json.get("data", "")
    feat = [[len(data.encode())]]
    pred = model.predict(feat)[0]
    label = "cat" if pred == 0 else "dog"
    return jsonify({"prediction": label})

if __name__ == "__main__":
    app.run(host="0.0.0.0", port=5000)
