
import cv2
import numpy as np
import time

class GazeTracker:
    def __init__(self):
        self.face_cascade = cv2.CascadeClassifier(
            cv2.data.haarcascades + "haarcascade_frontalface_default.xml"
        )
        self.eye_cascade = cv2.CascadeClassifier(
            cv2.data.haarcascades + "haarcascade_eye.xml"
        )
        self.last_click_time = 0
        self.dwell_threshold = 1.5  # seconds

    def process_frame(self, frame):
        gray = cv2.cvtColor(frame, cv2.COLOR_BGR2GRAY)
        faces = self.face_cascade.detectMultiScale(gray, 1.3, 5)

        gaze_direction = "center"
        dwell_click = False

        for (x, y, w, h) in faces:
            roi_gray = gray[y:y+h, x:x+w]
            eyes = self.eye_cascade.detectMultiScale(roi_gray)

            if len(eyes) >= 2:
                ex, ey, ew, eh = eyes[0]
                eye_region = roi_gray[ey:ey+eh, ex:ex+ew]
                _, threshold = cv2.threshold(eye_region, 70, 255, cv2.THRESH_BINARY)
                gaze_ratio = np.sum(threshold == 0) / threshold.size

                if gaze_ratio < 0.35:
                    gaze_direction = "right"
                elif gaze_ratio > 0.65:
                    gaze_direction = "left"
                else:
                    gaze_direction = "center"

        # dwell click
        if gaze_direction == "center":
            if time.time() - self.last_click_time > self.dwell_threshold:
                dwell_click = True
                self.last_click_time = time.time()

        return gaze_direction, dwell_click
