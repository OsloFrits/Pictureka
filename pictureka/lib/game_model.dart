import 'dart:async';
import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'data.dart';
import 'theme.dart';

const int kCols = 9;
const double kMaxRotDeg = 14;
const double kDuration = 40;
const int kSetCopies = 3;

class Player {
  final String name;
  final Color color;
  int score;
  Player(this.name, this.color, [this.score = 0]);
}

final List<({String name, Color color})> _teams = [
  (name: 'Equipe azul', color: AppColors.setN),
  (name: 'Equipe verde', color: AppColors.setZ),
  (name: 'Equipe âmbar', color: AppColors.setQ),
  (name: 'Equipe roxa', color: AppColors.setI),
];

class TilePlan {
  final Equation eq;
  final int col, row;
  final double jx, jy, rotDeg;
  const TilePlan(this.eq, this.col, this.row, this.jx, this.jy, this.rotDeg);
}

int _seed(String s) {
  var h = 2166136261;
  for (var i = 0; i < s.length; i++) {
    h ^= s.codeUnitAt(i);
    h = (h * 16777619) & 0x7FFFFFFF;
  }
  return h;
}

bool matches(Equation e, GameCard? c) {
  if (c == null) return false;
  if (c.type == 'set') return e.set == c.set;
  if (c.key != null) return e.key == c.key;
  if (e.key != null) return false;
  return (e.value! - c.value!).abs() < 1e-9;
}

class GameModel extends ChangeNotifier {
  List<Equation> tiles = [];
  List<TilePlan> tilePlans = [];
  int layoutRows = 13;

  List<GameCard> _deck = [];
  int _deckPos = 0;
  GameCard? current;

  String phase = 'idle';

  List<Player> players = [];
  int activeIdx = 0;
  int numPlayers = 2;
  int level = 0;

  String foundId = '';
  final Set<String> wrongIds = {};
  final Set<String> revealedIds = {};

  Timer? _ticker;
  double remaining = 0;
  double total = 0;

  GameModel() {
    newGame();
  }

  Player? get activePlayer => players.isEmpty ? null : players[activeIdx];

  void newGame() {
    players = _teams.take(numPlayers).map((t) => Player(t.name, t.color)).toList();
    activeIdx = 0;
    tiles = List.of(equations)..shuffle(math.Random(DateTime.now().microsecondsSinceEpoch));
    _computeLayout();
    _buildDeck();
    current = null;
    phase = 'idle';
    _clearMarks();
    _stopTimer();
    remaining = 0;
    total = 0;
    notifyListeners();
  }

  void _clearMarks() {
    foundId = '';
    wrongIds.clear();
    revealedIds.clear();
  }

  List<GameCard> _buildResultCards() {
    final map = <String, GameCard>{};
    for (final e in equations) {
      final k = e.key != null ? 'k:${e.key}' : 'v:${e.value}';
      if (!map.containsKey(k)) {
        map[k] = GameCard(type: 'result', node: e.result, value: e.value, key: e.key, level: e.level);
      } else if (e.level < map[k]!.level) {
        final old = map[k]!;
        map[k] = GameCard(type: 'result', node: old.node, value: old.value, key: old.key, level: e.level);
      }
    }
    return map.values.toList();
  }

  void _buildDeck() {
    var results = _buildResultCards();
    var sets = [for (final c in setCards) ...List.filled(kSetCopies, c)];
    if (level != 0) {
      results = results.where((c) => c.level == level).toList();
      sets = sets.where((c) => c.level == level).toList();
    }
    _deck = [...results, ...sets]..shuffle(math.Random(DateTime.now().microsecondsSinceEpoch));
    _deckPos = 0;
  }

  bool _reserved(double cx, double cy, double cw, double ch) {
    const dpad = 0.012;
    final exX = cw * 0.5 + dpad;
    final exY = ch * 0.5 + dpad;
    for (final d in doodleList) {
      if (cx > d.x - exX && cx < d.x + d.w + exX && cy > d.y - exY && cy < d.y + d.h + exY) {
        return true;
      }
    }
    return false;
  }

  void _computeLayout() {
    final n = tiles.length;
    int rows = 11;
    List<List<int>> free = [];
    for (; rows <= 18; rows++) {
      final cw = 1 / kCols, ch = 1 / rows;
      free = [];
      for (var r = 0; r < rows; r++) {
        for (var c = 0; c < kCols; c++) {
          final cx = (c + 0.5) * cw, cy = (r + 0.5) * ch;
          if (!_reserved(cx, cy, cw, ch)) free.add([c, r]);
        }
      }
      if (free.length >= n + 6) break;
    }
    layoutRows = rows;
    free.shuffle(math.Random(_seed('${tiles.first.id}:$n:$rows')));

    final plans = <TilePlan>[];
    for (var i = 0; i < n; i++) {
      final eq = tiles[i];
      final cell = i < free.length ? free[i] : [i % kCols, (i ~/ kCols) % rows];
      final rnd = math.Random(_seed(eq.id));
      final jx = rnd.nextDouble() * 2 - 1;
      final jy = rnd.nextDouble() * 2 - 1;
      final rot = (rnd.nextDouble() * 2 - 1) * kMaxRotDeg;
      plans.add(TilePlan(eq, cell[0], cell[1], jx, jy, rot));
    }
    tilePlans = plans;
  }

  void _startTimer() {
    _stopTimer();
    total = kDuration;
    remaining = kDuration;
    _ticker = Timer.periodic(const Duration(milliseconds: 100), (tk) {
      remaining = (remaining - 0.1);
      if (remaining <= 0) {
        remaining = 0;
        _stopTimer();
        phase = 'timeout';
        _computeReveal();
      }
      notifyListeners();
    });
  }

  void _stopTimer() {
    _ticker?.cancel();
    _ticker = null;
  }

  void _computeReveal() {
    revealedIds
      ..clear()
      ..addAll(tiles.where((e) => matches(e, current)).map((e) => e.id));
  }

  void drawCard() {
    if (_deckPos >= _deck.length) _buildDeck();
    current = _deck[_deckPos++];
    _clearMarks();
    phase = 'searching';
    _startTimer();
    notifyListeners();
  }

  void tap(Equation e) {
    if (phase != 'searching') return;
    if (matches(e, current)) {
      foundId = e.id;
      players[activeIdx].score++;
      phase = 'won';
      _stopTimer();
    } else {
      wrongIds.add(e.id);
    }
    notifyListeners();
  }

  void reveal() {
    if (phase != 'searching') return;
    _stopTimer();
    phase = 'timeout';
    _computeReveal();
    notifyListeners();
  }

  void nextCard() {
    if (players.isNotEmpty) activeIdx = (activeIdx + 1) % players.length;
    drawCard();
  }

  void restart() => newGame();

  void setLevel(int l) {
    level = l;
    _buildDeck();
    notifyListeners();
  }

  void setPlayers(int n) {
    numPlayers = n;
    newGame();
  }

  @override
  void dispose() {
    _stopTimer();
    super.dispose();
  }
}
