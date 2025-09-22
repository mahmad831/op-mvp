from kivy.app import App
from kivy.lang import Builder
from kivy.uix.screenmanager import ScreenManager, Screen
from kivy.properties import StringProperty, ObjectProperty
from kivy.clock import Clock
from kivy.graphics.texture import Texture
from kivy.uix.button import Button
import cv2

from auth import FaceAuth
from gaze import GazeTracker

# Demos
from demos.buttons_demo import ButtonsDemo
from demos.keyboard_demo import KeyboardDemo
from demos.draw_demo import DrawDemo
from demos.media_demo import MediaDemo
from demos.game_demo import PongGame

class HomeScreen(Screen): pass
class DemoHubScreen(Screen): pass
class SettingsScreen(Screen): pass
class HelpScreen(Screen): pass
class ButtonsDemoScreen(Screen): pass
class KeyboardDemoScreen(Screen): pass
class DrawDemoScreen(Screen): pass
class MediaDemoScreen(Screen): pass
class GameDemoScreen(Screen): pass

class AuthScreen(Screen):
    status = StringProperty("Please register or authenticate")
    def do_register(self):
        ok = FaceAuth().register_face()
        self.status = "Face registered ✅" if ok else "Registration failed ❌"
    def do_auth(self):
        ok = FaceAuth().authenticate()
        self.status = "Authenticated ✅" if ok else "Auth failed ❌"

class GazeControlScreen(Screen):
    preview = ObjectProperty(None)   # <Image> in kv
    cursor  = ObjectProperty(None)   # <Widget> in kv (drawn as circle)
    status  = StringProperty("Look around; hold steady to click")

    def on_enter(self, *a):
        self.cap = cv2.VideoCapture(1) or cv2.VideoCapture(0)
        if not self.cap or not self.cap.isOpened():
            self.status = "Camera not available"
            return
        self.tracker = GazeTracker()
        self.cx = self.width/2; self.cy = self.height/2
        self.speed = 600  # px per second at full deflection
        self._ev = Clock.schedule_interval(self._update, 1/30.)

    def on_leave(self, *a):
        if hasattr(self, "_ev") and self._ev:
            self._ev.cancel()
        if hasattr(self, "cap") and self.cap:
            self.cap.release()

    def _update(self, dt):
        ok, frame = self.cap.read()
        if not ok: return
        res = self.tracker.estimate(frame, dt)
        # move cursor
        self.cx = min(max(self.cx + res["nx"]*self.speed*dt, 0), self.width- self.cursor.width)
        self.cy = min(max(self.cy - res["ny"]*self.speed*dt, 0), self.height- self.cursor.height)
        self.cursor.pos = (self.cx, self.cy)
        self.status = f"{res['direction']} | dwell: {res['dwell_progress']:.2f}"

        # dwell click -> hit test buttons on this screen
        if res["clicked"]:
            for w in self.ids.controls.children:
                if isinstance(w, Button) and w.collide_point(*self.cursor.center):
                    w.trigger_action(duration=0.05)

        # show preview
        buf = cv2.flip(frame, 1).tobytes()
        h, w = frame.shape[:2]
        if not self.preview.texture or self.preview.texture.size != (w, h):
            self.preview.texture = Texture.create(size=(w, h), colorfmt='bgr')
            self.preview.texture.flip_vertical()
        self.preview.texture.blit_buffer(buf, colorfmt='bgr', bufferfmt='ubyte')
        self.preview.canvas.ask_update()

class OpticiaApp(App):
    title = "Opticia"
    def build(self):
        Builder.load_file("ui.kv")
        sm = ScreenManager()
        sm.add_widget(HomeScreen(name="home"))
        sm.add_widget(AuthScreen(name="auth"))
        sm.add_widget(GazeControlScreen(name="gaze"))
        sm.add_widget(DemoHubScreen(name="demo_hub"))
        sm.add_widget(ButtonsDemoScreen(name="buttons_demo"))
        sm.add_widget(KeyboardDemoScreen(name="keyboard_demo"))
        sm.add_widget(DrawDemoScreen(name="draw_demo"))
        sm.add_widget(MediaDemoScreen(name="media_demo"))
        sm.add_widget(GameDemoScreen(name="game_demo"))
        sm.add_widget(SettingsScreen(name="settings"))
        sm.add_widget(HelpScreen(name="help"))
        return sm
    def change_screen(self, name): self.root.current = name

if __name__ == "__main__":
    OpticiaApp().run()
