import 'package:flutter/material.dart';
import 'board.dart';
import 'game_model.dart';
import 'panels.dart';
import 'theme.dart';

void main() => runApp(const NumerikaApp());

class NumerikaApp extends StatelessWidget {
  const NumerikaApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Numérika',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: AppColors.desk,
        useMaterial3: true,
      ),
      home: const GameScreen(),
    );
  }
}

class GameScreen extends StatefulWidget {
  const GameScreen({super.key});

  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  final GameModel model = GameModel();

  @override
  void dispose() {
    model.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: ListenableBuilder(
          listenable: model,
          builder: (context, _) => SingleChildScrollView(
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 900),
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(16, 20, 16, 48),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      _header(),
                      const SizedBox(height: 16),
                      _topRow(),
                      const SizedBox(height: 14),
                      Controls(model: model),
                      const SizedBox(height: 16),
                      Board(model: model),
                      const SizedBox(height: 16),
                      const SetLegend(),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _header() {
    return Row(
      children: [
        Container(
          width: 44,
          height: 44,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: AppColors.board,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: Colors.white.withValues(alpha: 0.12)),
          ),
          child: Text('√', style: chalkStyle(26)),
        ),
        const SizedBox(width: 12),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Numérika', style: chalkStyle(24, weight: FontWeight.w600)),
            const Text('caça aos reais · notação científica e conjuntos · 9º ano',
                style: TextStyle(color: AppColors.chalkDim, fontSize: 13)),
          ],
        ),
      ],
    );
  }

  Widget _topRow() {
    return LayoutBuilder(builder: (context, cons) {
      final card = CurrentCard(model: model);
      final side = Column(
        children: [
          TimerBar(model: model),
          const SizedBox(height: 12),
          Scoreboard(model: model),
        ],
      );
      if (cons.maxWidth < 560) {
        return Column(children: [card, const SizedBox(height: 12), side]);
      }
      return Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(flex: 3, child: card),
          const SizedBox(width: 14),
          Expanded(flex: 2, child: side),
        ],
      );
    });
  }
}
