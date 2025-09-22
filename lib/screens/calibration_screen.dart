import 'package:flutter/material.dart';
import '../services/settings_store.dart';

class CalibrationScreen extends StatefulWidget {
  const CalibrationScreen({super.key});
  @override State<CalibrationScreen> createState()=>_CalibrationScreenState();
}

class _CalibrationScreenState extends State<CalibrationScreen> {
  double _scaleX = 1.0, _scaleY = 1.0;

  @override
  void initState() {
    super.initState();
    () async {
      final (a,b) = await SettingsStore.loadCalibration();
      setState(() { _scaleX = a; _scaleY = b; });
    }();
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Scaffold(
      appBar: AppBar(title: const Text('Calibration')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                Text('Adjust gaze sensitivity per axis', style: TextStyle(fontWeight: FontWeight.w700, color: cs.onSurface)),
                const SizedBox(height: 8),
                const Align(alignment: Alignment.centerLeft, child: Text('Horizontal scale')),
                Slider(min:0.5, max:2.0, value:_scaleX, onChanged:(v)=>setState(()=>_scaleX=v)),
                const Align(alignment: Alignment.centerLeft, child: Text('Vertical scale')),
                Slider(min:0.5, max:2.0, value:_scaleY, onChanged:(v)=>setState(()=>_scaleY=v)),
                const SizedBox(height: 10),
                FilledButton(onPressed: () async {
                  await SettingsStore.saveCalibration(_scaleX, _scaleY);
                  if (!mounted) return; Navigator.pop(context);
                }, child: const Text('Save')),
                const SizedBox(height: 8),
                const Text('Tip: Look at screen corners while adjusting so the cursor can reach them.'),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
