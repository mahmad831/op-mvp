import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class FaceStore {
  static const _kKey = 'opticia_face_vec';
  static Future<void> save(List<double> vec) async {
    final sp = await SharedPreferences.getInstance();
    sp.setString(_kKey, jsonEncode(vec));
  }
  static Future<List<double>?> load() async {
    final sp = await SharedPreferences.getInstance();
    final s = sp.getString(_kKey);
    if (s == null) return null;
    return (jsonDecode(s) as List).map((e) => (e as num).toDouble()).toList();
  }
  static Future<void> clear() async {
    final sp = await SharedPreferences.getInstance();
    sp.remove(_kKey);
  }
}
