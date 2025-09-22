
from kivy.app import App
from kivy.lang import Builder
from kivy.uix.screenmanager import ScreenManager, Screen
from kivy.properties import StringProperty
from kivy.core.window import Window

# Import demo/back-end modules to ensure availability
from demos.buttons_demo import ButtonsDemo
from demos.keyboard_demo import KeyboardDemo
from demos.draw_demo import DrawDemo
from demos.media_demo import MediaDemo
from demos.game_demo import PongGame

# Optional back-ends (not auto-invoked)
# from auth import FaceAuth
# from gaze import GazeTracker

class HomeScreen(Screen):
    pass

class PlaceholderScreen(Screen):
    label_text = StringProperty("Placeholder")

class ButtonsDemoScreen(Screen):
    pass

class KeyboardDemoScreen(Screen):
    pass

class DrawDemoScreen(Screen):
    pass

class MediaDemoScreen(Screen):
    pass

class GameDemoScreen(Screen):
    pass

class DemoHubScreen(Screen):
    pass

class SettingsScreen(Screen):
    pass

class HelpScreen(Screen):
    pass

class OpticiaApp(App):
    title = "Opticia"

    def build(self):
        Builder.load_file("ui.kv")
        sm = ScreenManager()
        sm.add_widget(HomeScreen(name="home"))
        sm.add_widget(DemoHubScreen(name="demo_hub"))
        sm.add_widget(ButtonsDemoScreen(name="buttons_demo"))
        sm.add_widget(KeyboardDemoScreen(name="keyboard_demo"))
        sm.add_widget(DrawDemoScreen(name="draw_demo"))
        sm.add_widget(MediaDemoScreen(name="media_demo"))
        sm.add_widget(GameDemoScreen(name="game_demo"))
        sm.add_widget(SettingsScreen(name="settings"))
        sm.add_widget(HelpScreen(name="help"))
        # Extras / placeholders
        sm.add_widget(PlaceholderScreen(name="camera_demo", label_text="Camera Demo (coming soon)"))
        sm.add_widget(PlaceholderScreen(name="mic_demo", label_text="Microphone Demo (coming soon)"))
        return sm

    def change_screen(self, name):
        if self.root.current != name and name in self.root.screen_names:
            self.root.current = name

if __name__ == "__main__":
    OpticiaApp().run()
