import 'dart:math';
import 'package:flutter/material.dart';
import 'package:google_mlkit_face_detection/google_mlkit_face_detection.dart';

class GazeTracker {
  double sensitivity = 1.0; // 0.5..2.0
  double sx = 1.0; // calibration X scale
  double sy = 1.0; // calibration Y scale

  Offset estimate(Face f){
    final lm = f.landmarks;
    final lEye = lm[FaceLandmarkType.leftEye]?.position;
    final rEye = lm[FaceLandmarkType.rightEye]?.position;
    final nose = lm[FaceLandmarkType.noseBase]?.position;

    if (lEye != null && rEye != null && nose != null) {
      final lEx = lEye.x.toDouble();
      final rEx = rEye.x.toDouble();
      final lEy = lEye.y.toDouble();
      final rEy = rEye.y.toDouble();
      final nX  = nose.x.toDouble();
      final nY  = nose.y.toDouble();

      final centerX = (lEx + rEx) / 2.0;
      final eyeSpan = (rEx - lEx).abs().clamp(1.0, 9999.0);
      final dx = (nX - centerX) / eyeSpan;            // normalized
      final dy = (nY - min(lEy, rEy)) / eyeSpan;
      return Offset(dx * sensitivity * sx, dy * sensitivity * 0.8 * sy);
    }

    // Fallback using bbox
    final bb = f.boundingBox;
    final w = max(1.0, bb.width);
    final h = max(1.0, bb.height);
    final dx = ((bb.center.dx - (bb.left + w/2)) / w) * 2;
    final dy = ((bb.center.dy - (bb.top  + h/2)) / h) * 2;
    return Offset(dx * 0.5 * sensitivity * sx, dy * 0.5 * sensitivity * sy);
  }
}
