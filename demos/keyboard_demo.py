
from kivy.uix.floatlayout import FloatLayout
from kivy.properties import StringProperty
from kivy.uix.gridlayout import GridLayout
from kivy.uix.button import Button

class KeyboardDemo(FloatLayout):
    typed_text = StringProperty("")

    def __init__(self, **kwargs):
        super().__init__(**kwargs)
        grid = GridLayout(cols=7, spacing=6, size_hint=(1, None))
        grid.bind(minimum_height=grid.setter('height'))
        letters = "ABCDEFGHIJKLMNOPQRSTUVWXYZ"
        for ch in letters:
            b = Button(text=ch, size_hint_y=None, height=40, background_normal="", background_color=(0.2,0.78,0.36,1))
            b.bind(on_release=lambda inst, c=ch: self.add_letter(c))
            grid.add_widget(b)
        self.add_widget(grid)

    def add_letter(self, letter):
        self.typed_text += letter

    def clear_text(self):
        self.typed_text = ""
