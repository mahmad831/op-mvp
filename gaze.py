# gaze.py
import cv2, numpy as np, time
from kivy.resources import resource_find

def _cascade(name):
    p = resource_find(f"assets/haarcascades/{name}")
    if p: return cv2.CascadeClassifier(p)
    return cv2.CascadeClassifier(cv2.data.haarcascades + name)

class GazeTracker:
    def __init__(self):
        self.face = _cascade("haarcascade_frontalface_default.xml")
        self.eye  = _cascade("haarcascade_eye_tree_eyeglasses.xml")
        self.last_blink = 0.0
        self.dwell_accum = 0.0
        self.dwell_threshold = 1.0   # seconds for click

    def _pupil_center(self, eye_roi):
        g = cv2.cvtColor(eye_roi, cv2.COLOR_BGR2GRAY)
        g = cv2.GaussianBlur(g, (5,5), 0)
        _, th = cv2.threshold(g, 0, 255, cv2.THRESH_BINARY_INV+cv2.THRESH_OTSU)
        m = cv2.moments(th)
        if m["m00"] == 0: return None
        cx = m["m10"]/m["m00"]; cy = m["m01"]/m["m00"]
        H, W = th.shape
        # normalize to [-0.5..0.5]
        return (cx/W - 0.5, cy/H - 0.5)

    def estimate(self, frame_bgr, dt, sensitivity=1.0):
        f = cv2.flip(frame_bgr, 1)  # selfie mirror
        gray = cv2.cvtColor(f, cv2.COLOR_BGR2GRAY)
        faces = self.face.detectMultiScale(gray, 1.2, 5, minSize=(120,120))
        nx = ny = 0.0
        if len(faces):
            x,y,w,h = max(faces, key=lambda a:a[2]*a[3])
            roi = f[y:y+h, x:x+w]; gry = gray[y:y+h, x:x+w]
            eyes = self.eye.detectMultiScale(gry, 1.1, 5, minSize=(30,30))
            eyes = sorted(eyes, key=lambda e:e[0])[:2]
            pupils = []
            for (ex,ey,ew,eh) in eyes:
                pc = self._pupil_center(roi[ey:ey+eh, ex:ex+ew])
                if pc: pupils.append(pc)
            if pupils:
                nx = float(np.mean([p[0] for p in pupils])) * sensitivity
                ny = float(np.mean([p[1] for p in pupils])) * sensitivity
        # direction classification
        horiz = "center" if -0.12 <= nx <= 0.12 else ("left" if nx > 0.12 else "right")
        vert  = "center" if -0.10 <= ny <= 0.10 else ("up" if ny < -0.10 else "down")
        direction = (horiz, vert)
        # dwell (cursor still)
        if abs(nx) < 0.08 and abs(ny) < 0.08:
            self.dwell_accum = min(self.dwell_threshold, self.dwell_accum + dt)
        else:
            self.dwell_accum = max(0.0, self.dwell_accum - dt*0.5)
        dwell_progress = self.dwell_accum / self.dwell_threshold
        click = dwell_progress >= 1.0
        if click: self.dwell_accum = 0.0
        return {"nx": nx, "ny": ny, "direction": direction, "dwell_progress": dwell_progress, "clicked": click}
