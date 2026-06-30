import 'package:flutter/material.dart';
import 'math.dart';


class Equation {
  final String id;
  final MathNode expr;
  final MathNode result;
  final double? value;
  final String? key;
  final String set;
  final int level;
  const Equation({
    required this.id,
    required this.expr,
    required this.result,
    this.value,
    this.key,
    required this.set,
    required this.level,
  });
}

final List<Equation> equations = [
  Equation(id: 'n_2p3p1', expr: row([pw('2', '3'), t(' + 1')]), result: t('9'), value: 9, set: 'N', level: 1),
  Equation(id: 'n_sqrt144', expr: sq('144'), result: t('12'), value: 12, set: 'N', level: 1),
  Equation(id: 'n_5sq', expr: pw('5', '2'), result: t('25'), value: 25, set: 'N', level: 1),
  Equation(id: 'n_10sq', expr: pw('10', '2'), result: t('100'), value: 100, set: 'N', level: 1),
  Equation(id: 'n_sqrt2x2', expr: row([sq('2'), t(' · '), sq('2')]), result: t('2'), value: 2, set: 'N', level: 2),
  Equation(id: 'n_2e3', expr: row([t('2×'), pw('10', '3')]), result: t('2000'), value: 2000, set: 'N', level: 1),
  Equation(id: 'n_6e2', expr: row([t('6×'), pw('10', '2')]), result: t('600'), value: 600, set: 'N', level: 1),
  Equation(
    id: 'n_prod',
    expr: row([t('(2×'), pw('10', '3'), t(') · ('), t('4×'), pw('10', '2'), t(')')]),
    result: t('800000'),
    value: 800000,
    set: 'N',
    level: 3,
  ),
  Equation(id: 'n_2p4', expr: pw('2', '4'), result: t('16'), value: 16, set: 'N', level: 1),
  Equation(id: 'n_sqrt49', expr: sq('49'), result: t('7'), value: 7, set: 'N', level: 1),
  Equation(id: 'n_1p10', expr: pw('1', '10'), result: t('1'), value: 1, set: 'N', level: 1),
  Equation(id: 'n_0x8', expr: t('0 × 8'), result: t('0'), value: 0, set: 'N', level: 1),
  Equation(id: 'n_32e5', expr: row([t('3,2×'), pw('10', '5')]), result: t('320000'), value: 320000, set: 'N', level: 2),
  Equation(id: 'n_sqrt4', expr: sq('4'), result: t('2'), value: 2, set: 'N', level: 2),

  Equation(id: 'z_m2x4', expr: t('−2 × 4'), result: t('−8'), value: -8, set: 'Z', level: 1),
  Equation(id: 'z_3m10', expr: t('3 − 10'), result: t('−7'), value: -7, set: 'Z', level: 1),
  Equation(id: 'z_m5m5', expr: t('−5 − 5'), result: t('−10'), value: -10, set: 'Z', level: 1),
  Equation(id: 'z_2m22', expr: t('2 − 22'), result: t('−20'), value: -20, set: 'Z', level: 1),
  Equation(id: 'z_m1x3', expr: t('−1 × 3'), result: t('−3'), value: -3, set: 'Z', level: 1),
  Equation(id: 'z_0m1', expr: t('0 − 1'), result: t('−1'), value: -1, set: 'Z', level: 1),
  Equation(id: 'z_50m150', expr: t('50 − 150'), result: t('−100'), value: -100, set: 'Z', level: 2),
  Equation(id: 'z_4m54', expr: t('4 − 54'), result: t('−50'), value: -50, set: 'Z', level: 2),

  Equation(id: 'q_meio_quarto', expr: row([fr('1', '2'), t(' + '), fr('1', '4')]), result: fr('3', '4'), value: 3 / 4, set: 'Q', level: 2),
  Equation(id: 'q_05x3', expr: t('0,5 × 3'), result: t('1,5'), value: 1.5, set: 'Q', level: 1),
  Equation(id: 'q_1div4', expr: t('1 ÷ 4'), result: t('0,25'), value: 1 / 4, set: 'Q', level: 1),
  Equation(id: 'q_15em4', expr: row([t('1,5×'), pw('10', '−4')]), result: t('0,00015'), value: 0.00015, set: 'Q', level: 2),
  Equation(id: 'q_1div3', expr: t('1 ÷ 3'), result: fr('1', '3'), value: 1 / 3, set: 'Q', level: 2),
  Equation(id: 'q_1div5', expr: t('1 ÷ 5'), result: t('0,2'), value: 1 / 5, set: 'Q', level: 1),
  Equation(id: 'q_1div2', expr: t('1 ÷ 2'), result: t('0,5'), value: 1 / 2, set: 'Q', level: 1),
  Equation(id: 'q_m5div2', expr: t('−5 ÷ 2'), result: t('−2,5'), value: -2.5, set: 'Q', level: 2),

  Equation(id: 'i_sqrt2p2', expr: row([sq('2'), t(' + '), sq('2')]), result: sq('2', '2'), key: '2sqrt2', set: 'I', level: 3),
  Equation(id: 'i_sqrt2x5', expr: row([sq('2'), t(' · '), sq('5')]), result: sq('10'), key: 'sqrt10', set: 'I', level: 3),
  Equation(id: 'i_sqrt8', expr: sq('8'), result: sq('2', '2'), key: '2sqrt2', set: 'I', level: 3),
  Equation(id: 'i_pi', expr: t('π + 0'), result: t('π'), key: 'pi', set: 'I', level: 1),
  Equation(id: 'i_sqrt5', expr: row([sq('5'), t(' · 1')]), result: sq('5'), key: 'sqrt5', set: 'I', level: 1),
  Equation(id: 'i_negsq2', expr: row([t('0 − '), sq('2')]), result: sq('2', '−'), key: 'neg_sqrt2', set: 'I', level: 2),
  Equation(id: 'i_sqrt3', expr: row([sq('3'), t(' + 0')]), result: sq('3'), key: 'sqrt3', set: 'I', level: 1),
  Equation(id: 'i_sqrt7', expr: row([sq('7'), t(' · 1')]), result: sq('7'), key: 'sqrt7', set: 'I', level: 1),
];

class GameCard {
  final String type;
  final MathNode? node;
  final double? value;
  final String? key;
  final String? set;
  final String? hint;
  final int level;
  const GameCard({required this.type, this.node, this.value, this.key, this.set, this.hint, required this.level});
}

const List<GameCard> setCards = [
  GameCard(type: 'set', set: 'N', hint: 'resultado natural: 0, 1, 2, 3, …', level: 1),
  GameCard(type: 'set', set: 'Z', hint: 'resultado inteiro negativo', level: 1),
  GameCard(type: 'set', set: 'Q', hint: 'resultado fração ou decimal (não inteiro)', level: 2),
  GameCard(type: 'set', set: 'I', hint: 'resultado irracional (raízes não exatas, π…)', level: 2),
];

class Doodle {
  final String id;
  final double x, y, w, h, op;
  const Doodle(this.id, this.x, this.y, this.w, this.h, this.op);
  Rect rectIn(Size s) => Rect.fromLTWH(x * s.width, y * s.height, w * s.width, h * s.height);
}

const List<Doodle> doodleList = [
  Doodle('circle', 0.02, 0.03, 0.15, 0.16, 0.55),
  Doodle('parabola', 0.71, 0.02, 0.16, 0.17, 0.52),
  Doodle('triangle', 0.02, 0.70, 0.18, 0.20, 0.52),
  Doodle('cube', 0.79, 0.65, 0.19, 0.21, 0.52),
  Doodle('sine', 0.40, 0.02, 0.16, 0.15, 0.40),
  Doodle('integral', 0.41, 0.71, 0.18, 0.21, 0.42),
  Doodle('scatter', 0.84, 0.33, 0.14, 0.17, 0.44),
  Doodle('hyperbola', 0.02, 0.40, 0.15, 0.16, 0.42),
  Doodle('sphere', 0.84, 0.02, 0.14, 0.16, 0.44),
  Doodle('angle', 0.64, 0.43, 0.15, 0.16, 0.44),
  Doodle('hist', 0.56, 0.20, 0.15, 0.16, 0.42),
];
