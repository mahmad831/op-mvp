
import cv2
import os
import numpy as np

DATA_DIR = "face_data"
if not os.path.exists(DATA_DIR):
    os.makedirs(DATA_DIR)

FACE_FILE = os.path.join(DATA_DIR, "user_face.npy")


class FaceAuth:
    def __init__(self):
        self.face_cascade = cv2.CascadeClassifier(
            cv2.data.haarcascades + "haarcascade_frontalface_default.xml"
        )

    def register_face(self):
        cap = cv2.VideoCapture(0)
        if not cap.isOpened():
            print("Camera not available")
            return False

        print("Look at the camera for registration...")

        face_embedding = None
        while True:
            ret, frame = cap.read()
            if not ret:
                break
            gray = cv2.cvtColor(frame, cv2.COLOR_BGR2GRAY)
            faces = self.face_cascade.detectMultiScale(gray, 1.3, 5)

            for (x, y, w, h) in faces:
                roi = gray[y:y+h, x:x+w]
                roi_resized = cv2.resize(roi, (100, 100))
                face_embedding = roi_resized.flatten()
                np.save(FACE_FILE, face_embedding)
                print("Face registered ✅")
                cap.release()
                return True

        cap.release()
        return False

    def authenticate(self):
        if not os.path.exists(FACE_FILE):
            print("No face registered yet!")
            return False

        stored_face = np.load(FACE_FILE)

        cap = cv2.VideoCapture(0)
        if not cap.isOpened():
            print("Camera not available")
            return False

        print("Authenticating...")

        while True:
            ret, frame = cap.read()
            if not ret:
                break
            gray = cv2.cvtColor(frame, cv2.COLOR_BGR2GRAY)
            faces = self.face_cascade.detectMultiScale(gray, 1.3, 5)

            for (x, y, w, h) in faces:
                roi = gray[y:y+h, x:x+w]
                roi_resized = cv2.resize(roi, (100, 100))
                live_face = roi_resized.flatten()

                # Simple cosine similarity check
                sim = np.dot(stored_face, live_face) / (
                    np.linalg.norm(stored_face) * np.linalg.norm(live_face)
                )
                cap.release()
                return sim > 0.8

        cap.release()
        return False
