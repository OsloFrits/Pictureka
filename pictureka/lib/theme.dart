import 'package:flutter/material.dart';

class AppColors {
  static const desk = Color(0xFF211F1B);
  static const board = Color(0xFF24382E);
  static const wood = Color(0xFF5B4632);
  static const wood2 = Color(0xFF74583C);

  static const chalk = Color(0xFFEEF0E8);
  static const chalkDim = Color(0xFFB9C0B4);

  static const paper = Color(0xFFF7F3E8);
  static const paperInk = Color(0xFF2A2620);
  static const paperMuted = Color(0xFF6F6A5E);

  static const setN = Color(0xFF7DB4EC);
  static const setZ = Color(0xFF6FD3AB);
  static const setQ = Color(0xFFF2C46B);
  static const setI = Color(0xFFB3AEF0);

  static const ok = Color(0xFF80E0A6);
  static const bad = Color(0xFFF18B89);

  static Color ofSet(String s) {
    switch (s) {
      case 'N':
        return setN;
      case 'Z':
        return setZ;
      case 'Q':
        return setQ;
      default:
        return setI;
    }
  }
}

const List<String> _chalkFallback = ['Segoe Script', 'Bradley Hand', 'Comic Sans MS'];

TextStyle chalkStyle(
  double size, {
  Color color = AppColors.chalk,
  FontWeight weight = FontWeight.w500,
  bool dust = true,
}) {
  return TextStyle(
    fontFamily: 'Segoe Print',
    fontFamilyFallback: _chalkFallback,
    fontSize: size,
    height: 1.0,
    color: color,
    fontWeight: weight,
    shadows: dust ? [Shadow(blurRadius: 0.8, color: color.withValues(alpha: 0.4))] : null,
  );
}
