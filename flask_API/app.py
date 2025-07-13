from flask import Flask, request, jsonify
from flask_cors import CORS
from ultralytics import YOLO
import cv2
import numpy as np

# ---------------------------
# Load your two YOLOv8 models
# ---------------------------
currency_model = YOLO("currency_best_model.pt")                    # YOLOv8n for currency
indoor_model   = YOLO("indoor_best.pt", task="obb")                # YOLOv8-OBB for indoor objects

# ---------------------------
# Define your label lists
# ---------------------------
labels_currency = [
    'PKR_10', 'PKR_100', 'PKR_1000',
    'PKR_20', 'PKR_50', 'PKR_500', 'PKR_5000'
]

labels_indoor = [
    'Air_Conditioner', 'Pen', 'Purse', 'bench', 'chair',
    'clock', 'fan', 'laptop', 'mobile', 'rostrum'
]

# ---------------------------
# Flask app initialization
# ---------------------------
app = Flask(__name__)
CORS(app)

# ---------------------------
# API route: Currency Detection
# ---------------------------
@app.route("/predict_currency", methods=["POST"])
def predict_currency():
    if "image" not in request.files:
        return jsonify({"error": "No image uploaded."}), 400

    file = request.files["image"]
    img = cv2.imdecode(
        np.frombuffer(file.read(), np.uint8),
        cv2.IMREAD_COLOR
    )

    # Set custom confidence threshold
    results = currency_model.predict(img, conf=0.7)
    boxes = results[0].boxes

    if boxes is not None and len(boxes) > 0:
        confidences = boxes.conf.cpu().numpy()
        max_conf = float(np.max(confidences))

        if max_conf < 0.6:
            return jsonify({"result": "No currency note detected."})

        cls_id = int(boxes.cls[0].item())
        label = labels_currency[cls_id] if cls_id < len(labels_currency) else "Unknown"
        clean_label = label.replace('_', ' ')
        return jsonify({"result": f"This is {clean_label} note"})
    
    return jsonify({"result": "No currency note detected."})

# ---------------------------
# API route: Indoor Object Detection (OBB)
# ---------------------------
@app.route("/predict_indoor", methods=["POST"])
def predict_indoor():
    if "image" not in request.files:
        return jsonify({"error": "No image uploaded."}), 400

    file = request.files["image"]
    img = cv2.imdecode(
        np.frombuffer(file.read(), np.uint8),
        cv2.IMREAD_COLOR
    )

    # Perform OBB prediction
    results = indoor_model.predict(img, conf=0.6)
    obb = results[0].obb  # rotated boxes container

    # Inspect attributes for debugging
    print("OBB attributes:", dir(obb))

    # Extract class IDs and confidences
    cls_tensor = obb.cls  # class tensor
    conf_tensor = obb.conf  # confidence tensor

    # Ensure detections exist
    if cls_tensor is not None and len(cls_tensor) > 0:
        cls_ids = cls_tensor.cpu().numpy() if hasattr(cls_tensor, 'cpu') else cls_tensor.numpy()
        confs = conf_tensor.cpu().numpy() if hasattr(conf_tensor, 'cpu') else conf_tensor.numpy()

        # Pick highest-confidence detection
        max_idx = int(np.argmax(confs))
        cls_id = int(cls_ids[max_idx])
        label = labels_indoor[cls_id] if cls_id < len(labels_indoor) else "Unknown"

        # Clean label by replacing underscore if any
        clean_label = label.replace('_', ' ') if '_' in label else label

        return jsonify({
            "result": f"This is a {clean_label} detected",
            "confidence": float(confs[max_idx])
        })
    else:
        # No detections found
        return jsonify({"result": "No indoor object detected.", "debug": str(results)})

# ---------------------------
# Run Flask App
# ---------------------------
if __name__ == "__main__":
    app.run(host="0.0.0.0", port=5000, debug=True)
