import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'data.dart';
import 'doodles_painter.dart';
import 'game_model.dart';
import 'math.dart';
import 'theme.dart';

const double _cellAr = 0.6;

class Board extends StatelessWidget {
  final GameModel model;
  const Board({super.key, required this.model});

  @override
  Widget build(BuildContext context) {
    final rows = model.layoutRows;
    final ratio = kCols / (_cellAr * rows);

    return Container(
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [AppColors.wood2, AppColors.wood],
        ),
        borderRadius: BorderRadius.circular(10),
        boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.45), blurRadius: 18, offset: const Offset(0, 8))],
      ),
      padding: const EdgeInsets.all(14),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(5),
            child: AspectRatio(
              aspectRatio: ratio,
              child: ColoredBox(
                color: AppColors.board,
                child: LayoutBuilder(builder: (ctx, cons) => _buildField(cons.maxWidth, cons.maxHeight, rows)),
              ),
            ),
          ),
          const SizedBox(height: 10),
          Container(
            height: 10,
            decoration: BoxDecoration(
              gradient: const LinearGradient(colors: [AppColors.wood, Color(0xFF43331F)]),
              borderRadius: BorderRadius.circular(4),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildField(double w, double h, int rows) {
    final cw = w / kCols;
    final ch = h / rows;
    final contentW = cw * 0.86;
    final contentH = ch * 0.5;

    final children = <Widget>[
      Positioned.fill(child: RepaintBoundary(child: CustomPaint(painter: DoodlesPainter()))),
    ];

    for (final plan in model.tilePlans) {
      final rad = plan.rotDeg * math.pi / 180;
      final cosT = math.cos(rad).abs();
      final sinT = math.sin(rad).abs();
      final rw = contentW * cosT + contentH * sinT;
      final rh = contentW * sinT + contentH * cosT;
      final maxJX = math.max(0.0, (cw - rw) / 2 - 1.0);
      final maxJY = math.max(0.0, (ch - rh) / 2 - 1.0);
      final centerX = (plan.col + 0.5) * cw + plan.jx * maxJX;
      final centerY = (plan.row + 0.5) * ch + plan.jy * maxJY;

      children.add(Positioned(
        left: centerX - contentW / 2,
        top: centerY - contentH / 2,
        width: contentW,
        height: contentH,
        child: Transform.rotate(
          angle: rad,
          child: _EquationTile(
            eq: plan.eq,
            state: _stateOf(plan.eq.id),
            onTap: () => model.tap(plan.eq),
          ),
        ),
      ));
    }

    return Stack(clipBehavior: Clip.hardEdge, children: children);
  }

  String _stateOf(String id) {
    if (model.foundId == id) return 'correct';
    if (model.wrongIds.contains(id)) return 'wrong';
    if (model.phase != 'searching' && model.revealedIds.contains(id)) return 'revealed';
    return 'idle';
  }
}

class _EquationTile extends StatelessWidget {
  final Equation eq;
  final String state;
  final VoidCallback onTap;
  const _EquationTile({required this.eq, required this.state, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final color = switch (state) {
      'correct' => AppColors.ok,
      'wrong' => AppColors.bad,
      'revealed' => AppColors.setQ,
      _ => AppColors.chalk,
    };
    final border = state == 'idle' ? Colors.transparent : color;

    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Container(
        alignment: Alignment.center,
        padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 2),
        decoration: BoxDecoration(
          border: Border.all(color: border, width: 2),
          borderRadius: BorderRadius.circular(40),
        ),
        child: FittedBox(
          fit: BoxFit.scaleDown,
          child: MathView(eq.expr, color: color, size: 26),
        ),
      ),
    );
  }
}
