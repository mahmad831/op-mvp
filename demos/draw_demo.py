
from kivy.uix.widget import Widget
from kivy.graphics import Line, Color
from kivy.core.window import Window

class DrawDemo(Widget):
    def __init__(self, **kwargs):
        super().__init__(**kwargs)
        self.drawing = False
        self.bind(on_touch_down=self._down, on_touch_move=self._move, on_touch_up=self._up)

    def _down(self, widget, touch):
        if not self.collide_point(*touch.pos):
            return False
        self.drawing = True
        with self.canvas:
            Color(0, 1, 0)
            self.line = Line(points=list(touch.pos), width=2)
        return True

    def _move(self, widget, touch):
        if self.drawing:
            self.line.points += list(touch.pos)

    def _up(self, widget, touch):
        self.drawing = False
