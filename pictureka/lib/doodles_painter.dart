import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'data.dart';
import 'theme.dart';

class _M {
  final double s, ox, oy;
  _M(Rect r)
      : s = math.min(r.width, r.height) / 100,
        ox = r.left + (r.width - math.min(r.width, r.height)) / 2,
        oy = r.top + (r.height - math.min(r.width, r.height)) / 2;
  Offset p(double x, double y) => Offset(ox + x * s, oy + y * s);
}

class DoodlesPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    for (final d in doodleList) {
      final m = _M(d.rectIn(size));
      final sp = Paint()
        ..color = AppColors.chalk.withValues(alpha: d.op)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2
        ..strokeCap = StrokeCap.round
        ..strokeJoin = StrokeJoin.round
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 0.6);
      final fill = Paint()..color = AppColors.chalk.withValues(alpha: d.op);
      _draw(canvas, m, sp, fill, d.id);
    }
  }

  void _poly(Canvas c, _M m, Paint p, List<List<double>> pts, {bool close = false}) {
    final path = Path()..moveTo(m.p(pts[0][0], pts[0][1]).dx, m.p(pts[0][0], pts[0][1]).dy);
    for (var i = 1; i < pts.length; i++) {
      path.lineTo(m.p(pts[i][0], pts[i][1]).dx, m.p(pts[i][0], pts[i][1]).dy);
    }
    if (close) path.close();
    c.drawPath(path, p);
  }

  void _cubic(Canvas c, _M m, Paint p, List<List<double>> k) {
    final path = Path()..moveTo(m.p(k[0][0], k[0][1]).dx, m.p(k[0][0], k[0][1]).dy);
    for (var i = 1; i + 2 < k.length; i += 3) {
      final c1 = m.p(k[i][0], k[i][1]);
      final c2 = m.p(k[i + 1][0], k[i + 1][1]);
      final e = m.p(k[i + 2][0], k[i + 2][1]);
      path.cubicTo(c1.dx, c1.dy, c2.dx, c2.dy, e.dx, e.dy);
    }
    c.drawPath(path, p);
  }

  void _line(Canvas c, _M m, Paint p, double x1, double y1, double x2, double y2) =>
      c.drawLine(m.p(x1, y1), m.p(x2, y2), p);

  void _draw(Canvas c, _M m, Paint sp, Paint fill, String id) {
    switch (id) {
      case 'circle':
        c.drawCircle(m.p(50, 52), 33 * m.s, sp);
        _line(c, m, sp, 50, 52, 79, 35);
        c.drawCircle(m.p(50, 52), 2.2 * m.s, fill);
        break;
      case 'parabola':
        _line(c, m, sp, 50, 12, 50, 90);
        _line(c, m, sp, 12, 78, 92, 78);
        _cubic(c, m, sp, [[22, 76], [35, 16], [65, 16], [78, 76]]);
        break;
      case 'triangle':
        _poly(c, m, sp, [[16, 80], [84, 80], [84, 30]], close: true);
        _poly(c, m, sp, [[76, 80], [76, 72], [84, 72]]);
        break;
      case 'cube':
        _poly(c, m, sp, [[18, 38], [62, 38], [62, 82], [18, 82]], close: true);
        _poly(c, m, sp, [[38, 20], [82, 20], [82, 64], [38, 64]], close: true);
        _line(c, m, sp, 18, 38, 38, 20);
        _line(c, m, sp, 62, 38, 82, 20);
        _line(c, m, sp, 18, 82, 38, 64);
        _line(c, m, sp, 62, 82, 82, 64);
        break;
      case 'sine':
        _line(c, m, sp, 6, 52, 94, 52);
        _cubic(c, m, sp, [[8, 52], [22, 14], [36, 14], [50, 52], [64, 90], [78, 90], [92, 52]]);
        break;
      case 'integral':
        _poly(c, m, sp, [[16, 10], [16, 84], [92, 84]]);
        _cubic(c, m, sp, [[22, 78], [42, 26], [60, 26], [86, 64]]);
        for (final h in [[30.0, 60.0], [42.0, 48.0], [54.0, 44.0], [66.0, 48.0], [78.0, 58.0]]) {
          _line(c, m, sp, h[0], 78, h[0], h[1]);
        }
        break;
      case 'scatter':
        _line(c, m, sp, 14, 84, 14, 12);
        _line(c, m, sp, 14, 84, 90, 84);
        _line(c, m, sp, 20, 78, 82, 24);
        for (final d in [[30.0, 70.0], [46.0, 58.0], [60.0, 44.0], [74.0, 32.0]]) {
          c.drawCircle(m.p(d[0], d[1]), 2 * m.s, fill);
        }
        break;
      case 'hyperbola':
        _line(c, m, sp, 50, 8, 50, 92);
        _line(c, m, sp, 8, 50, 92, 50);
        _cubic(c, m, sp, [[56, 14], [62, 40], [64, 42], [88, 46]]);
        _cubic(c, m, sp, [[12, 54], [36, 58], [38, 60], [44, 86]]);
        break;
      case 'sphere':
        c.drawCircle(m.p(50, 50), 34 * m.s, sp);
        c.drawOval(Rect.fromCenter(center: m.p(50, 50), width: 68 * m.s, height: 24 * m.s), sp);
        break;
      case 'angle':
        _line(c, m, sp, 16, 80, 88, 80);
        _line(c, m, sp, 16, 80, 82, 24);
        c.drawArc(Rect.fromCircle(center: m.p(16, 80), radius: 26 * m.s), 0, -0.7, false, sp);
        break;
      case 'hist':
        _poly(c, m, sp, [[16, 14], [16, 84], [88, 84]]);
        for (final b in [[24.0, 54.0, 30.0], [40.0, 40.0, 44.0], [56.0, 48.0, 36.0], [72.0, 30.0, 54.0]]) {
          _poly(c, m, sp, [
            [b[0], 84],
            [b[0], 84 - b[2]],
            [b[0] + 11, 84 - b[2]],
            [b[0] + 11, 84],
          ]);
        }
        break;
    }
  }

  @override
  bool shouldRepaint(covariant DoodlesPainter oldDelegate) => false;
}
