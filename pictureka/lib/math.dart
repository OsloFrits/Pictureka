import 'package:flutter/material.dart';
import 'theme.dart';

abstract class MathNode {
  const MathNode();
}

class Txt extends MathNode {
  final String s;
  const Txt(this.s);
}

class Sup extends MathNode {
  final String base;
  final String exp;
  const Sup(this.base, this.exp);
}

class Frac extends MathNode {
  final String num;
  final String den;
  const Frac(this.num, this.den);
}

class Sqrt extends MathNode {
  final String rad;
  final String coef;
  const Sqrt(this.rad, [this.coef = '']);
}

class MRow extends MathNode {
  final List<MathNode> items;
  const MRow(this.items);
}

Txt t(String s) => Txt(s);
Sup pw(String b, String e) => Sup(b, e);
Frac fr(String n, String d) => Frac(n, d);
Sqrt sq(String r, [String c = '']) => Sqrt(r, c);
MRow row(List<MathNode> items) => MRow(items);

class MathView extends StatelessWidget {
  final MathNode node;
  final Color color;
  final double size;
  const MathView(this.node, {super.key, this.color = AppColors.chalk, this.size = 24});

  @override
  Widget build(BuildContext context) => _build(node, size);

  Widget _build(MathNode n, double s) {
    if (n is Txt) {
      return Text(n.s, style: chalkStyle(s, color: color));
    }
    if (n is MRow) {
      return Row(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [for (final c in n.items) _build(c, s)],
      );
    }
    if (n is Sup) {
      return Row(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(n.base, style: chalkStyle(s, color: color)),
          Transform.translate(
            offset: Offset(0, -s * 0.30),
            child: Text(n.exp, style: chalkStyle(s * 0.62, color: color)),
          ),
        ],
      );
    }
    if (n is Frac) {
      return IntrinsicWidth(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 2),
              child: Text(n.num, textAlign: TextAlign.center, style: chalkStyle(s * 0.82, color: color)),
            ),
            Container(height: 1.4, color: color),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 2),
              child: Text(n.den, textAlign: TextAlign.center, style: chalkStyle(s * 0.82, color: color)),
            ),
          ],
        ),
      );
    }
    if (n is Sqrt) {
      return Row(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          if (n.coef.isNotEmpty) Text(n.coef, style: chalkStyle(s, color: color)),
          Text('√', style: chalkStyle(s, color: color)),
          Container(
            decoration: BoxDecoration(border: Border(top: BorderSide(color: color, width: 1.5))),
            padding: const EdgeInsets.only(top: 1, left: 2, right: 1),
            child: Text(n.rad, style: chalkStyle(s, color: color)),
          ),
        ],
      );
    }
    return const SizedBox.shrink();
  }
}
