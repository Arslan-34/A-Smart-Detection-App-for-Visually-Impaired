# A-Smart-Detection-App-for-Visually-ImpairedSmart Detection App – Final Year Project

An AI-powered mobile application designed to assist visually impaired users by detecting indoor objects and Pakistani currency, and providing real-time voice feedback.

Project Overview

The Smart Detection App was developed as my Final Year Project for the BS Information Technology program at Bahria University, Islamabad. The main aim of the app is to assist visually impaired users in navigating their surroundings by using AI-powered object detection and voice feedback. The app uses a custom-trained YOLOv8 model to detect common indoor objects and Pakistani currency, and provides real-time voice guidance using Google Text-to-Speech (TTS).

The app was built using Flutter and integrated with a Python-based machine learning backend using Flask API. It provides a user-friendly interface with minimal interaction needed for people with visual impairments.

Objectives

- Detect indoor objects and Pakistani currency using a mobile phone camera
- Provide real-time voice feedback using TTS
- Create an accessible Flutter-based mobile app
- Integrate a Python-trained YOLOv8 model with the app using Flask

Machine Learning Model

- Model used: YOLOv8 (Ultralytics)
- Dataset: Custom images annotated using Roboflow
- Model training performed using Google Colab
- Evaluation metrics include F1-score, precision, and recall
- The model was integrated with a lightweight Flask API for inference and connected with the Flutter app via HTTP requests

Training code is available in:
model_training/fyp_arslan_yolov8_training.ipynb


Flask Integration

A lightweight Flask API was used to serve the trained model. The Flask server accepts image inputs, runs predictions using the YOLOv8 model, and returns JSON responses to the Flutter app.

Flask server code is available in:
flask_api/app.py

Tech Stack

App Framework: Flutter (Dart)
Machine Learning: Python, YOLOv8, Google Colab
Voice Feedback: Google Text-to-Speech (TTS)
Dataset Annotation: Roboflow
Backend Integration: Flask API
Version Control: Git and GitHub

App Screenshots

Screenshots of the app interface are available in the following folder:
assets/screenshots/

Folder Structure

Smart-Detection-App/
├── lib/                        (Flutter app source code)
├── assets/screenshots/        (Screenshots of app UI)
├── model_training/            (YOLOv8 training and evaluation notebooks)
├── flask_api/                 (Flask API code for model inference)
├── pubspec.yaml               (Flutter dependencies)
└── README.md                  (Project description)

Key Features

- Real-time object detection via mobile camera
- Indoor object and Pakistani currency recognition
- Voice feedback using Google TTS
- Custom-trained YOLOv8 model integrated via Flask API
- Easy-to-use interface designed for accessibility

How to Run the App

1. Clone this repository
2. Navigate to the project folder
3. Run flutter pub get to install dependencies
4. Connect a physical device or emulator
5. Run flutter run to launch the app

Author

Muhammad Arslan Nawaz 
Final Year Project – BSIT  
Bahria University, Islamabad  
Email: manarslan4@gmail.com 
GitHub: github.com/Arslan-34

License

This project is intended for educational and academic purposes only.
