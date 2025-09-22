import 'dart:math';

class FaceAuth {
  static double cosine(List<double> a, List<double> b) {
    double dot = 0, na = 0, nb = 0;
    for (int i = 0; i < a.length; i++) {
      dot += a[i] * b[i];
      na += a[i] * a[i];
      nb += b[i] * b[i];
    }
    return dot / (sqrt(na) * sqrt(nb) + 1e-6);
  }
  static bool isMatch(List<double> a, List<double> b, {double thresh = 0.92}) =>
      cosine(a, b) >= thresh;
}
