import 'package:flutter/material.dart';
import 'game_model.dart';
import 'math.dart';
import 'theme.dart';

BoxDecoration _darkPanel() => BoxDecoration(
      color: Colors.white.withValues(alpha: 0.05),
      border: Border.all(color: Colors.white.withValues(alpha: 0.12)),
      borderRadius: BorderRadius.circular(12),
    );

class CurrentCard extends StatelessWidget {
  final GameModel model;
  const CurrentCard({super.key, required this.model});

  @override
  Widget build(BuildContext context) {
    final c = model.current;
    return Container(
      constraints: const BoxConstraints(minHeight: 140),
      padding: const EdgeInsets.fromLTRB(18, 16, 18, 16),
      decoration: BoxDecoration(
        color: AppColors.paper,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.4), blurRadius: 22, offset: const Offset(0, 8))],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (c == null)
            const Text('Clique em “Sortear carta” para começar a caça.',
                style: TextStyle(color: AppColors.paperMuted, fontSize: 16))
          else if (c.type == 'result') ...[
            _tag('Resultado · ache a equação que dá este número', AppColors.setN, const Color(0xFF0C447C)),
            const SizedBox(height: 10),
            FittedBox(
              fit: BoxFit.scaleDown,
              alignment: Alignment.centerLeft,
              child: MathView(c.node!, color: AppColors.paperInk, size: 42),
            ),
          ] else ...[
            _tag('Conjunto · ache uma equação com resultado neste conjunto', AppColors.setI, const Color(0xFF3C3489)),
            const SizedBox(height: 6),
            Text(c.set!, style: TextStyle(fontSize: 58, fontWeight: FontWeight.bold, color: AppColors.ofSet(c.set!), height: 1)),
            Text(c.hint!, style: const TextStyle(color: AppColors.paperMuted, fontSize: 13)),
          ],
          if (c != null) ...[const SizedBox(height: 12), _status()],
        ],
      ),
    );
  }

  Widget _status() {
    switch (model.phase) {
      case 'won':
        final p = model.activePlayer;
        return Row(children: [
          const Text('✔ ', style: TextStyle(color: Color(0xFF138A64))),
          Text(p?.name ?? '', style: const TextStyle(color: Color(0xFF138A64), fontWeight: FontWeight.w600)),
          const Text(' achou! +1 ponto', style: TextStyle(color: Color(0xFF138A64))),
        ]);
      case 'timeout':
        return const Text('Tempo esgotado — equações certas destacadas no tabuleiro.',
            style: TextStyle(color: Color(0xFFB07B14)));
      default:
        return const Text('Procurando…', style: TextStyle(color: AppColors.paperMuted));
    }
  }

  Widget _tag(String text, Color bg, Color fg) => Container(
        padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 4),
        decoration: BoxDecoration(color: bg.withValues(alpha: 0.22), borderRadius: BorderRadius.circular(7)),
        child: Text(text, style: TextStyle(color: fg, fontSize: 11, fontWeight: FontWeight.w600)),
      );
}

class TimerBar extends StatelessWidget {
  final GameModel model;
  const TimerBar({super.key, required this.model});

  @override
  Widget build(BuildContext context) {
    final double pct = model.total > 0 ? (model.remaining / model.total).clamp(0.0, 1.0).toDouble() : 0.0;
    final display = model.total > 0 ? '${model.remaining.ceil()}s' : '—';
    final color = pct > 0.5 ? AppColors.ok : (pct > 0.2 ? AppColors.setQ : AppColors.bad);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: _darkPanel(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            const Text('Tempo', style: TextStyle(color: AppColors.chalkDim, fontSize: 13)),
            Text(display, style: const TextStyle(color: AppColors.chalk, fontWeight: FontWeight.w600, fontSize: 13)),
          ]),
          const SizedBox(height: 8),
          ClipRRect(
            borderRadius: BorderRadius.circular(999),
            child: Container(
              height: 8,
              color: Colors.black.withValues(alpha: 0.35),
              child: FractionallySizedBox(
                alignment: Alignment.centerLeft,
                widthFactor: pct,
                child: Container(color: color),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class Scoreboard extends StatelessWidget {
  final GameModel model;
  const Scoreboard({super.key, required this.model});

  @override
  Widget build(BuildContext context) {
    final active = model.activePlayer;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: _darkPanel(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(children: [
            const Text('Vez de ', style: TextStyle(color: AppColors.chalkDim, fontSize: 13)),
            Text(active?.name ?? '',
                style: TextStyle(color: active?.color ?? AppColors.chalk, fontSize: 13, fontWeight: FontWeight.w600)),
          ]),
          const SizedBox(height: 8),
          for (var i = 0; i < model.players.length; i++)
            Container(
              margin: const EdgeInsets.only(bottom: 4),
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
              decoration: BoxDecoration(
                color: i == model.activeIdx ? Colors.white.withValues(alpha: 0.08) : Colors.transparent,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(children: [
                Container(width: 10, height: 10, decoration: BoxDecoration(color: model.players[i].color, shape: BoxShape.circle)),
                const SizedBox(width: 8),
                Expanded(child: Text(model.players[i].name, style: const TextStyle(color: AppColors.chalk, fontSize: 14))),
                Text('${model.players[i].score}',
                    style: const TextStyle(color: AppColors.chalk, fontSize: 14, fontWeight: FontWeight.w600)),
              ]),
            ),
        ],
      ),
    );
  }
}

class Controls extends StatelessWidget {
  final GameModel model;
  const Controls({super.key, required this.model});

  @override
  Widget build(BuildContext context) {
    final phase = model.phase;
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      crossAxisAlignment: WrapCrossAlignment.center,
      children: [
        if (phase == 'idle')
          _btn('Sortear carta', model.drawCard, primary: true)
        else if (phase == 'won' || phase == 'timeout')
          _btn('Próxima carta', model.nextCard, primary: true)
        else
          _btn('Procurando…', null, primary: true),
        _btn('Revelar respostas', phase == 'searching' ? model.reveal : null),
        _btn('Reiniciar', model.restart),
        const SizedBox(width: 8),
        _drop('Nível', model.level, const {0: 'Todos', 1: '★ fácil', 2: '★★ médio', 3: '★★★ desafio'}, model.setLevel),
        _drop('Jogadores', model.numPlayers, const {2: '2', 3: '3', 4: '4'}, model.setPlayers),
      ],
    );
  }

  Widget _btn(String label, VoidCallback? onTap, {bool primary = false}) {
    final enabled = onTap != null;
    return Opacity(
      opacity: enabled ? 1 : 0.45,
      child: Material(
        color: primary ? AppColors.setN : Colors.white.withValues(alpha: 0.06),
        borderRadius: BorderRadius.circular(9),
        child: InkWell(
          borderRadius: BorderRadius.circular(9),
          onTap: onTap,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 9),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(9),
              border: Border.all(color: primary ? AppColors.setN : Colors.white.withValues(alpha: 0.18)),
            ),
            child: Text(label,
                style: TextStyle(
                  color: primary ? const Color(0xFF10243A) : AppColors.chalk,
                  fontWeight: primary ? FontWeight.w700 : FontWeight.w500,
                  fontSize: 14,
                )),
          ),
        ),
      ),
    );
  }

  Widget _drop(String label, int value, Map<int, String> opts, void Function(int) onChanged) {
    return Row(mainAxisSize: MainAxisSize.min, children: [
      Text('$label ', style: const TextStyle(color: AppColors.chalkDim, fontSize: 13)),
      Container(
        padding: const EdgeInsets.symmetric(horizontal: 8),
        decoration: BoxDecoration(
          color: AppColors.desk,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: Colors.white.withValues(alpha: 0.18)),
        ),
        child: DropdownButtonHideUnderline(
          child: DropdownButton<int>(
            value: value,
            isDense: true,
            dropdownColor: const Color(0xFF2A2722),
            style: const TextStyle(color: AppColors.chalk, fontSize: 13),
            iconEnabledColor: AppColors.chalkDim,
            items: [for (final e in opts.entries) DropdownMenuItem(value: e.key, child: Text(e.value))],
            onChanged: (v) {
              if (v != null) onChanged(v);
            },
          ),
        ),
      ),
    ]);
  }
}

class SetLegend extends StatelessWidget {
  const SetLegend({super.key});

  @override
  Widget build(BuildContext context) {
    Widget chip(String s, String label, Color color) => Container(
          padding: const EdgeInsets.symmetric(horizontal: 11, vertical: 6),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.06),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: Colors.white.withValues(alpha: 0.10)),
          ),
          child: Row(mainAxisSize: MainAxisSize.min, children: [
            Text(s, style: TextStyle(color: color, fontWeight: FontWeight.w700, fontSize: 16)),
            const SizedBox(width: 7),
            Text(label, style: const TextStyle(color: AppColors.chalkDim, fontSize: 13)),
          ]),
        );

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: _darkPanel(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Wrap(spacing: 8, runSpacing: 8, children: [
            chip('N', 'resultado natural (0, 1, 2, …)', AppColors.setN),
            chip('Z', 'resultado inteiro negativo', AppColors.setZ),
            chip('Q', 'resultado fração / decimal', AppColors.setQ),
            chip('I', 'resultado irracional', AppColors.setI),
          ]),
          const SizedBox(height: 10),
          const Text(
            'Regra de ouro: o tabuleiro só tem equações. A carta de conjunto (N/Z/Q/I) pede uma '
            'equação cujo resultado tem aquele como menor conjunto; a carta de resultado pede a '
            'equação que dá aquele número. R nunca vira carta.',
            style: TextStyle(color: AppColors.chalkDim, fontSize: 13),
          ),
        ],
      ),
    );
  }
}
