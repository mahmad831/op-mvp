name: Build Android (Kivy)

on:
  push:
    branches: [ main ]
  workflow_dispatch:

jobs:
  build-apk:
    runs-on: ubuntu-latest
    steps:
      - name: Checkout
        uses: actions/checkout@v4

      # Put Haar cascades into the APK (OpenCV recipe often doesn't bundle them)
      - name: Download OpenCV cascades into assets
        run: |
          mkdir -p assets/haarcascades
          curl -L -o assets/haarcascades/haarcascade_frontalface_default.xml https://raw.githubusercontent.com/opencv/opencv/4.x/data/haarcascades/haarcascade_frontalface_default.xml
          curl -L -o assets/haarcascades/haarcascade_eye_tree_eyeglasses.xml https://raw.githubusercontent.com/opencv/opencv/4.x/data/haarcascades/haarcascade_eye_tree_eyeglasses.xml

      # Build inside the Buildozer Docker image
      - name: Build with Buildozer (Docker)
        env:
          DOCKER_BUILDKIT: 0   # avoid "unsupported media type application/vnd.buildkit..." error
        run: |
          docker run --rm \
            -v "$PWD":/home/user/app \
            -w /home/user/app \
            kivy/buildozer:stable \
            buildozer android debug

      - name: Upload APK
        uses: actions/upload-artifact@v4
        with:
          name: opticia-debug-apk
          path: bin/*.apk
