import 'dart:math';

class Interpolation {
  final List<Point> points;

  Point findOrdinateFor(num x) {
    double res = 0;

    for (var i = 0; i < points.length; i++) {
      double numerator = 1;

      for (var j = 0; j < points.length; j++) {
        if (j != i) numerator *= (x - points[j].x);
      }

      double denominator = 1;

      for (var j = 0; j < points.length; j++) {
        if (j != i) denominator *= (points[i].x - points[j].x);
      }

      res += (numerator / denominator) * points[i].y;
      assert(!res.isNaN && !res.isInfinite);
    }

    return Point(x, (res * 1000).round() / 1000);
  }

  const Interpolation(this.points);
}

/* void main() {
  const i = Interpolation(
    [
      Point(-2, -22),
      Point(-1, -10),
      Point(2, -10),
      Point(3, -2),
    ],
  );

  print(i.findOrdinateFor(-1.5));
}
 */