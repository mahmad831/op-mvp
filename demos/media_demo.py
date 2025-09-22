
from kivy.uix.floatlayout import FloatLayout
from kivy.properties import StringProperty
from kivy.uix.gridlayout import GridLayout
from kivy.uix.button import Button

class MediaDemo(FloatLayout):
    status_text = StringProperty("Media Stopped")

    def __init__(self, **kwargs):
        super().__init__(**kwargs)
        grid = GridLayout(cols=3, spacing=10, size_hint=(1, None))
        grid.bind(minimum_height=grid.setter('height'))
        actions = [
            ("Play", self.play),
            ("Pause", self.pause),
            ("Next", self.next_track),
            ("Vol +", self.volume_up),
            ("Vol -", self.volume_down),
        ]
        for label, handler in actions:
            b = Button(text=label, size_hint_y=None, height=48, background_normal="", background_color=(0.2,0.78,0.36,1))
            b.bind(on_release=lambda inst, h=handler: h())
            grid.add_widget(b)
        self.add_widget(grid)

    def play(self):
        self.status_text = "Playing..."

    def pause(self):
        self.status_text = "Paused"

    def next_track(self):
        self.status_text = "Next track"

    def volume_up(self):
        self.status_text = "Volume up"

    def volume_down(self):
        self.status_text = "Volume down"
