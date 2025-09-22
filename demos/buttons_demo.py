
from kivy.uix.floatlayout import FloatLayout
from kivy.properties import StringProperty
from kivy.uix.gridlayout import GridLayout
from kivy.uix.button import Button

class ButtonsDemo(FloatLayout):
    status_text = StringProperty("Look at a button to select (tap for now)")

    def __init__(self, **kwargs):
        super().__init__(**kwargs)
        grid = GridLayout(cols=2, spacing=10, size_hint=(1, None))
        grid.bind(minimum_height=grid.setter('height'))
        names = ["Play", "Pause", "Next", "Back"]
        for n in names:
            b = Button(text=n, size_hint_y=None, height=48, background_normal="", background_color=(0.2,0.78,0.36,1))
            b.bind(on_release=lambda inst, name=n: self.on_button_pressed(name))
            grid.add_widget(b)
        self.add_widget(grid)

    def on_button_pressed(self, name):
        self.status_text = f"You selected: {name}"
