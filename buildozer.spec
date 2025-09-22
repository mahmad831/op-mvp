[app]
title = Opticia
package.name = opticia
package.domain = org.example
source.dir = .
version = 0.1

# ✅ Use the python-for-android recipe, NOT opencv-python wheel
requirements = python3,kivy,opencv,numpy

orientation = portrait
fullscreen = 0

# Permissions you’ll need
android.permissions = CAMERA, RECORD_AUDIO, VIBRATE

# Android SDK/NDK targets
android.api = 34
android.minapi = 24

[buildozer]
log_level = 2
