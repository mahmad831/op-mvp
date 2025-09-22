import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:flutter/foundation.dart'; // for WriteBuffer
import 'package:google_mlkit_face_detection/google_mlkit_face_detection.dart';
import '../services/gaze_tracker.dart';
import '../widgets/gaze_cursor.dart';
import 'settings/sensitivity_screen.dart';
import 'settings/sound_screen.dart';
import 'settings/manual_screen.dart';
import '../services/settings_store.dart';

class HomeScreen extends StatefulWidget { const HomeScreen({super.key}); @override State<HomeScreen> createState()=>_HomeScreenState(); }

class _HomeScreenState extends State<HomeScreen> {
  CameraController? _c; FaceDetector? _d; final _tracker = GazeTracker();
  Offset _cursor = const Offset(160,260); bool _clicking = false; DateTime _gazeStart = DateTime.now();
  bool _running = false; double _alpha = 0.25;

  @override void initState(){ super.initState(); _loadPrefs(); }
  Future<void> _loadPrefs() async {
    final speed = await SettingsStore.loadSpeed();
    final dwell = await SettingsStore.loadDwell();
    final (a,b) = await SettingsStore.loadCalibration();
    setState(() {
      _tracker.sensitivity = speed; _gazeStart = DateTime.now();
      _tracker.sx = a; _tracker.sy = b;
    });
  }

  Future<void> _start() async {
    if (_running) return;
    _running = true;
    final cams = await availableCameras();
    final front = cams.firstWhere((c)=>c.lensDirection==CameraLensDirection.front, orElse: ()=>cams.first);
    _c = CameraController(front, ResolutionPreset.medium, enableAudio: false);
    await _c!.initialize();
    _d = FaceDetector(options: FaceDetectorOptions(enableContours: true, enableLandmarks: true, performanceMode: FaceDetectorMode.accurate, minFaceSize: 0.15));
    bool busy = false;
    await _c!.startImageStream((CameraImage img) async {
      if (busy || !_running || !mounted) return;
      busy = true;
      try{
        final input = _toInputImage(img, _c!.description);
        final faces = await _d!.processImage(input);
        if (faces.isNotEmpty) {
          final off = _tracker.estimate(faces.first);
          final size = MediaQuery.of(context).size;
          final px = (_cursor.dx + off.dx * 10.0);
          final py = (_cursor.dy + off.dy * 10.0);
          final smoothed = Offset(
            _cursor.dx * (1 - _alpha) + px * _alpha,
            _cursor.dy * (1 - _alpha) + py * _alpha,
          );
          final clamped = Offset(
            smoothed.dx.clamp(8.0, size.width - 8.0),
            smoothed.dy.clamp(100.0, size.height - 100.0),
          );
          setState(()=>_cursor = clamped);
          final now = DateTime.now();
          final still = (off.dx.abs() < 0.05 && off.dy.abs() < 0.05);
          if (still && now.difference(_gazeStart).inMilliseconds > (await SettingsStore.loadDwell()*1000).toInt()) {
            setState(()=>_clicking=true);
            await Future.delayed(const Duration(milliseconds: 120));
            if (!mounted) return;
            setState(()=>_clicking=false);
            _gazeStart = DateTime.now();
          }
          if (!still) _gazeStart = now;
        }
      } catch (_) {} finally { busy = false; }
    });
    setState((){});
  }

  InputImage _toInputImage(CameraImage image, CameraDescription desc) {
    final WriteBuffer allBytes = WriteBuffer();
    for (final Plane plane in image.planes) { allBytes.putUint8List(plane.bytes); }
    final bytes = allBytes.done().buffer.asUint8List();
    final Size size = Size(image.width.toDouble(), image.height.toDouble());
    final rotation = _rotationFromCamera(desc.sensorOrientation);
    final format = InputImageFormat.nv21;
    final planeData = image.planes.map((Plane plane) => InputImagePlaneMetadata(bytesPerRow: plane.bytesPerRow, height: plane.height, width: plane.width)).toList();
    final metadata = InputImageMetadata(size: size, rotation: rotation, format: format, bytesPerRow: image.planes.first.bytesPerRow, planeData: planeData);
    return InputImage.fromBytes(bytes: bytes, metadata: metadata);
  }

  InputImageRotation _rotationFromCamera(int sensorOrientation) {
    switch (sensorOrientation) {
      case 0: return InputImageRotation.rotation0deg;
      case 90: return InputImageRotation.rotation90deg;
      case 180: return InputImageRotation.rotation180deg;
      case 270: return InputImageRotation.rotation270deg;
      default: return InputImageRotation.rotation0deg;
    }
  }

  @override Widget build(BuildContext context){
    final cs = Theme.of(context).colorScheme;
    return Scaffold(
      body: Stack(children:[
        Container(decoration: const BoxDecoration(gradient: LinearGradient(begin: Alignment.topLeft, end: Alignment.bottomRight, colors:[Color(0xFF0F1117), Color(0xFF151A2E)]))),
        SafeArea(child: Padding(padding: const EdgeInsets.fromLTRB(20,20,20,0), child: Row(children:[
          Text("Opticia", style: TextStyle(fontSize: 26, fontWeight: FontWeight.w800, color: cs.primary)),
          const Spacer(),
          TextButton(onPressed: ()=>Navigator.pushNamed(context, '/calibration'), child: const Text('Calibrate')),
        ]))),
        Center(child: Card(child: Padding(padding: const EdgeInsets.all(20), child: Column(mainAxisSize: MainAxisSize.min, children:[
          const SizedBox(height: 6),
          Text("Gaze Control", style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700, color: cs.onSurface)),
          const SizedBox(height: 8),
          Text("Press START and use your eyes to move the cursor.\nHold steady to click.", textAlign: TextAlign.center, style: TextStyle(color: Colors.white.withOpacity(0.7))),
          const SizedBox(height: 18),
          FilledButton(onPressed: _start, child: const Padding(padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12), child: Text('START', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700)))),
        ])))),
        GazeCursor(pos: _cursor, clicking: _clicking),
        Align(alignment: Alignment.bottomCenter, child: Padding(padding: const EdgeInsets.fromLTRB(16,0,16,22), child: Row(children:[
          Expanded(child: _QuickTile(icon: Icons.tune, label: "Sensitivity", onTap: ()=>Navigator.push(context, MaterialPageRoute(builder:(_)=>const SensitivityScreen())))),
          const SizedBox(width: 12),
          Expanded(child: _QuickTile(icon: Icons.volume_up_rounded, label: "Sound", onTap: ()=>Navigator.push(context, MaterialPageRoute(builder:(_)=>const SoundScreen())))),
          const SizedBox(width: 12),
          Expanded(child: _QuickTile(icon: Icons.menu_book_outlined, label: "Manual", onTap: ()=>Navigator.push(context, MaterialPageRoute(builder:(_)=>const ManualScreen())))),
        ]))),
        Positioned(left: 10, top: 42, child: Container(padding: const EdgeInsets.symmetric(horizontal:10, vertical:6), decoration: BoxDecoration(color: const Color(0x99000000), borderRadius: BorderRadius.circular(10)), child: Text('x:${_cursor.dx.toStringAsFixed(0)} y:${_cursor.dy.toStringAsFixed(0)}', style: const TextStyle(fontSize: 12)))),
      ]),
    );
  }

  @override void dispose(){ _running = false; _c?.dispose(); _d?.close(); super.dispose(); }
}

class _QuickTile extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;
  const _QuickTile({required this.icon, required this.label, required this.onTap, super.key});
  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 70,
        decoration: BoxDecoration(color: const Color(0x151A1F2E), borderRadius: BorderRadius.circular(16), border: Border.all(color: Colors.white12)),
        child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [ Icon(icon, color: cs.primary), const SizedBox(width: 8), Text(label, style: const TextStyle(fontWeight: FontWeight.w600)), ]),
      ),
    );
  }
}
