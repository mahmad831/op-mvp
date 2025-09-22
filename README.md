# Opticia — Full Version

Features:
- Face Register/Login (on-device, secure)
- Real-time gaze tracking (camera stream) with smoothing & fallback
- Calibration (per-axis scale) saved to SharedPreferences
- Dwell-to-click with adjustable threshold
- Settings persisted: sensitivity, dwell, sound
- Re-register face (register again), logout (clear face data)
- Modern Material 3 UI
- Codemagic config optimized for reliable builds

## Build on Codemagic
1) Push repo to GitHub with this root layout (pubspec.yaml and codemagic.yaml at top level).
2) On Codemagic: Add application → Use codemagic.yaml → run "Android Debug APK".
3) Download `app-debug.apk` from Artifacts.
