import os
from glob import glob
from PIL import Image
import numpy as np
from sklearn.linear_model import LogisticRegression
from sklearn.metrics import classification_report, accuracy_score
import joblib

def load_image_paths(data_dir):
    """
    Walks through data_dir/<class_name> and returns lists of (filepath, label).
    """
    image_paths = []
    labels = []
    classes = ["cat", "dog"]
    for idx, cls in enumerate(classes):
        cls_folder = os.path.join(data_dir, cls)
        if not os.path.isdir(cls_folder):
            continue
        for ext in ("*.png", "*.jpg", "*.jpeg"):
            for img_file in glob(os.path.join(cls_folder, ext)):
                image_paths.append(img_file)
                labels.append(idx)
    return image_paths, np.array(labels), classes

def extract_features(image_paths):
    """
    Loads each image, converts to grayscale, resizes to 32×32,
    and flattens into a 1D feature vector.
    """
    feats = []
    for path in image_paths:
        img = Image.open(path).convert("L")
        img = img.resize((32, 32))
        arr = np.array(img).flatten() / 255.0
        feats.append(arr)
    return np.vstack(feats)

# 1. Load train and validation image paths
base_path = "training-data"
train_dir = base_path + "train"
val_dir   = base_path + "val"

print("Getting images paths...")
X_train_paths, y_train, class_names = load_image_paths(train_dir)
X_val_paths,   y_val,   _           = load_image_paths(val_dir)

# 2. Extract features
print("Converting images to arrays...")
X_train = extract_features(X_train_paths)
X_val   = extract_features(X_val_paths)

# 3. Train a lightweight model
model = LogisticRegression(max_iter=1000)
print("Training...")
model.fit(X_train, y_train)

# 4. Evaluate on the validation set
y_pred = model.predict(X_val)
acc = accuracy_score(y_val, y_pred)
print(f"Validation Accuracy: {acc:.2%}")
print("\nClassification Report:")
print(classification_report(y_val, y_pred, target_names=class_names))

# 5. Save model & class mapping
os.makedirs("outputs", exist_ok=True)
joblib.dump({"model": model, "classes": class_names}, "outputs/model.joblib")
print("Model and class mapping saved to outputs/light_model.joblib")
