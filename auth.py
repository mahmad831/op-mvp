# auth.py
import cv2, os, numpy as np
from kivy.resources import resource_find

DATA_DIR = "face_data"
os.makedirs(DATA_DIR, exist_ok=True)
FACE_FILE = os.path.join(DATA_DIR, "user_face.npy")

def _cascade(name):
    # Try packaged assets first, then OpenCV's built-in path
    p = resource_find(f"assets/haarcascades/{name}")
    if p:
        return cv2.CascadeClassifier(p)
    return cv2.CascadeClassifier(cv2.data.haarcascades + name)

class FaceAuth:
    def __init__(self):
        self.face_cascade = _cascade("haarcascade_frontalface_default.xml")

    def register_face(self, cam_index=1):
        cap = cv2.VideoCapture(cam_index) or cv2.VideoCapture(0)
        if not cap or not cap.isOpened():
            return False
        while True:
            ok, frame = cap.read()
            if not ok: break
            gray = cv2.cvtColor(frame, cv2.COLOR_BGR2GRAY)
            faces = self.face_cascade.detectMultiScale(gray, 1.2, 5, minSize=(120,120))
            if len(faces):
                x,y,w,h = max(faces, key=lambda f:f[2]*f[3])
                roi = cv2.resize(gray[y:y+h, x:x+w], (100,100)).flatten()
                np.save(FACE_FILE, roi)
                cap.release()
                return True
        cap.release(); return False

    def authenticate(self, cam_index=1, thresh=0.80):
        if not os.path.exists(FACE_FILE):
            return False
        stored = np.load(FACE_FILE)
        cap = cv2.VideoCapture(cam_index) or cv2.VideoCapture(0)
        if not cap or not cap.isOpened():
            return False
        while True:
            ok, frame = cap.read()
            if not ok: break
            gray = cv2.cvtColor(frame, cv2.COLOR_BGR2GRAY)
            faces = self.face_cascade.detectMultiScale(gray, 1.2, 5, minSize=(120,120))
            if len(faces):
                x,y,w,h = max(faces, key=lambda f:f[2]*f[3])
                live = cv2.resize(gray[y:y+h, x:x+w], (100,100)).flatten()
                sim = float(np.dot(stored, live) / (np.linalg.norm(stored)*np.linalg.norm(live) + 1e-8))
                cap.release()
                return sim >= thresh
        cap.release(); return False
