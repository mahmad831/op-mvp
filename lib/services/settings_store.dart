import 'package:shared_preferences/shared_preferences.dart';

class SettingsStore {
  static const _kSpeed = 'opticia_speed';
  static const _kDwell = 'opticia_dwell';
  static const _kSound = 'opticia_sound';
  static const _kCalibA = 'opticia_calib_a'; // scale X
  static const _kCalibB = 'opticia_calib_b'; // scale Y

  static Future<void> saveSpeed(double v) async {
    final sp = await SharedPreferences.getInstance();
    sp.setDouble(_kSpeed, v);
  }
  static Future<double> loadSpeed() async {
    final sp = await SharedPreferences.getInstance();
    return sp.getDouble(_kSpeed) ?? 1.0;
  }

  static Future<void> saveDwell(double v) async {
    final sp = await SharedPreferences.getInstance();
    sp.setDouble(_kDwell, v);
  }
  static Future<double> loadDwell() async {
    final sp = await SharedPreferences.getInstance();
    return sp.getDouble(_kDwell) ?? 0.9;
  }

  static Future<void> saveSound(bool v) async {
    final sp = await SharedPreferences.getInstance();
    sp.setBool(_kSound, v);
  }
  static Future<bool> loadSound() async {
    final sp = await SharedPreferences.getInstance();
    return sp.getBool(_kSound) ?? true;
  }

  static Future<void> saveCalibration(double a, double b) async {
    final sp = await SharedPreferences.getInstance();
    sp.setDouble(_kCalibA, a);
    sp.setDouble(_kCalibB, b);
  }
  static Future<(double,double)> loadCalibration() async {
    final sp = await SharedPreferences.getInstance();
    return (sp.getDouble(_kCalibA) ?? 1.0, sp.getDouble(_kCalibB) ?? 1.0);
  }
}
