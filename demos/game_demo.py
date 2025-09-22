
from kivy.uix.widget import Widget
from kivy.graphics import Rectangle, Color
from kivy.clock import Clock

class PongGame(Widget):
    def __init__(self, **kwargs):
        super().__init__(**kwargs)
        self.size_hint = (1, 1)
        with self.canvas:
            Color(0, 1, 0)
            self.ball = Rectangle(pos=(100, 100), size=(20, 20))
        self.vx = 2
        self.vy = 2
        Clock.schedule_interval(self.update, 1/60)

    def update(self, dt):
        x, y = self.ball.pos
        nx = x + self.vx
        ny = y + self.vy
        # bounce on widget bounds
        if nx < 0 or nx + self.ball.size[0] > self.width:
            self.vx *= -1
        if ny < 0 or ny + self.ball.size[1] > self.height:
            self.vy *= -1
        self.ball.pos = (x + self.vx, y + self.vy)
