import 'package:flutter/material.dart';
class ManualScreen extends StatelessWidget { const ManualScreen({super.key}); @override Widget build(BuildContext c){ return Scaffold(appBar: AppBar(title: const Text('User Manual')), body: Padding(padding: const EdgeInsets.all(16), child: Card(child: ListView(padding: const EdgeInsets.all(16), children: const [
  Text('Welcome to Opticia', style: TextStyle(fontSize: 18,fontWeight: FontWeight.bold)), SizedBox(height:8),
  Text('• Control cursor using eye movement.\n• Dwell to click.\n• Adjustable sensitivity, dwell, and sound.\n• Use calibration to tune reach to corners.'), SizedBox(height:16),
  Text('Tips for Best Experience', style: TextStyle(fontWeight: FontWeight.bold)), SizedBox(height:6),
  Text('• Good, even lighting.\n• Hold device at eye level.\n• Keep head steady while clicking.\n• Adjust speed and dwell to taste.'),
])))); }}
