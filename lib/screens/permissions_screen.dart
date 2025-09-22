import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

class PermissionsScreen extends StatefulWidget {
  const PermissionsScreen({super.key});
  @override
  State<PermissionsScreen> createState() => _PermissionsScreenState();
}

class _PermissionsScreenState extends State<PermissionsScreen> {
  bool camOk = false;
  bool micOk = false;
  bool accessibilitySeen = false;

  @override
  void initState() {
    super.initState();
    () async {
      camOk = await Permission.camera.isGranted;
      micOk = await Permission.microphone.isGranted;
      setState(() {});
    }();
  }

  Future<void> _askCamera() async {
    final s = await Permission.camera.request();
    setState(() => camOk = s.isGranted);
  }

  Future<void> _askMic() async {
    final s = await Permission.microphone.request();
    setState(() => micOk = s.isGranted);
  }

  void _openAccessibilityHint() {
    setState(() => accessibilitySeen = true);
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Enable Accessibility (optional)'),
        content: const Text('For future system-wide control, enable the service in Settings → Accessibility.\nFor this build, Camera is enough to continue.'),
        actions: [ TextButton(onPressed: ()=>Navigator.pop(context), child: const Text('OK')) ],
      ),
    );
  }

  bool get canContinue => camOk;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0F1117),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 40, 20, 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Center(child: CircleAvatar(radius: 46, backgroundColor: Colors.black26)),
              const SizedBox(height: 14),
              const Center(child: Text('Opticia', style: TextStyle(fontSize: 28, fontWeight: FontWeight.w800))),
              const SizedBox(height: 26),
              _GreenTile(label: 'Camera', icon: Icons.photo_camera_outlined, granted: camOk, onTap: _askCamera),
              const SizedBox(height: 14),
              _GreenTile(label: 'Accessibility', icon: Icons.accessibility_new, granted: accessibilitySeen, onTap: _openAccessibilityHint),
              const SizedBox(height: 14),
              _GreenTile(label: 'Microphone', icon: Icons.mic_none_rounded, granted: micOk, onTap: _askMic),
              const Spacer(),
              _GreenCTA(label: 'Next', icon: Icons.arrow_forward, enabled: canContinue,
                onTap: ()=>Navigator.pushReplacementNamed(context, '/auth')),
            ],
          ),
        ),
      ),
    );
  }
}

class _GreenTile extends StatelessWidget {
  final String label; final IconData icon; final bool granted; final VoidCallback onTap;
  const _GreenTile({required this.label, required this.icon, required this.granted, required this.onTap, super.key});
  @override
  Widget build(BuildContext context) {
    const green = Color(0xFF2ECC71);
    return Material(
      color: green, borderRadius: BorderRadius.circular(16),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: onTap,
        child: Container(
          height: 64, padding: const EdgeInsets.symmetric(horizontal: 18),
          child: Row(children: [
            Expanded(child: Text(label, style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w700))),
            Icon(granted ? Icons.check_circle : icon, color: Colors.white),
          ]),
        ),
      ),
    );
  }
}

class _GreenCTA extends StatelessWidget {
  final String label; final IconData icon; final bool enabled; final VoidCallback onTap;
  const _GreenCTA({required this.label, required this.icon, required this.enabled, required this.onTap, super.key});
  @override
  Widget build(BuildContext context) {
    const green = Color(0xFF2ECC71);
    return Opacity(
      opacity: enabled ? 1 : 0.5,
      child: Material(
        color: green, borderRadius: BorderRadius.circular(16),
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: enabled ? onTap : null,
          child: Container(
            height: 64, padding: const EdgeInsets.symmetric(horizontal: 18),
            child: Row(children: [
              Expanded(child: Text(label, style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w700))),
              Icon(icon, color: Colors.white),
            ]),
          ),
        ),
      ),
    );
  }
}
