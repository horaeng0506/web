import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import 'models/timer_model.dart';

void main() {
  runApp(const TimerWebApp());
}

class TimerWebApp extends StatelessWidget {
  const TimerWebApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => TimerModel(),
      child: MaterialApp(
        title: 'Timer Web',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(
            seedColor: const Color(0xFF4D64FF),
            brightness: Brightness.light,
          ),
          useMaterial3: true,
        ),
        home: const TimerDashboard(),
      ),
    );
  }
}

class TimerDashboard extends StatelessWidget {
  const TimerDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    final model = context.watch<TimerModel>();
    final width = MediaQuery.of(context).size.width;
    final cardWidth = width < 500 ? width - 40 : 420.0;

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
          child: ConstrainedBox(
            constraints: BoxConstraints(maxWidth: cardWidth + 32),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                _TargetCard(model: model, maxWidth: cardWidth),
                const SizedBox(height: 16),
                _QuickAdjustRow(model: model),
                const SizedBox(height: 12),
                _ToggleButton(model: model),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _TargetCard extends StatelessWidget {
  const _TargetCard({required this.model, required this.maxWidth});

  final TimerModel model;
  final double maxWidth;

  @override
  Widget build(BuildContext context) {
    final targetFormatter = DateFormat('a h:mm:ss');
    final nowFormatter = DateFormat('yyyy.MM.dd HH:mm:ss');

    return Container(
      width: maxWidth,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.08),
            blurRadius: 16,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            '목표 시각',
            style: Theme.of(context).textTheme.labelSmall?.copyWith(
              color: Theme.of(context).colorScheme.outline,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            targetFormatter.format(model.displayedTarget),
            style: Theme.of(context).textTheme.displaySmall?.copyWith(
              fontWeight: FontWeight.w600,
              fontFeatures: const [FontFeature.tabularFigures()],
            ),
          ),
          const SizedBox(height: 8),
          Text(
            nowFormatter.format(model.now),
            style: Theme.of(context).textTheme.labelSmall?.copyWith(
              color: Theme.of(context).colorScheme.outline,
            ),
          ),
        ],
      ),
    );
  }
}

class _QuickAdjustRow extends StatelessWidget {
  const _QuickAdjustRow({required this.model});

  final TimerModel model;

  @override
  Widget build(BuildContext context) {
    final buttons = [
      _QuickAdjustButton(
        label: '+1시간',
        onPressed: () => model.addInterval(const Duration(hours: 1)),
      ),
      _QuickAdjustButton(
        label: '+30분',
        onPressed: () => model.addInterval(const Duration(minutes: 30)),
      ),
      _QuickAdjustButton(
        label: '+10분',
        onPressed: () => model.addInterval(const Duration(minutes: 10)),
      ),
    ];

    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth < 480) {
          return Column(
            children: [
              for (final button in buttons) ...[
                SizedBox(width: double.infinity, child: button),
                const SizedBox(height: 8),
              ],
            ],
          );
        }

        return Row(
          children: [
            for (final button in buttons) ...[
              Expanded(child: button),
              if (button != buttons.last) const SizedBox(width: 10),
            ],
          ],
        );
      },
    );
  }
}

class _QuickAdjustButton extends StatelessWidget {
  const _QuickAdjustButton({required this.label, required this.onPressed});

  final String label;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return FilledButton.tonal(
      onPressed: onPressed,
      style: FilledButton.styleFrom(
        padding: const EdgeInsets.symmetric(vertical: 14),
      ),
      child: Text(label),
    );
  }
}

class _ToggleButton extends StatelessWidget {
  const _ToggleButton({required this.model});

  final TimerModel model;

  @override
  Widget build(BuildContext context) {
    final isFrozen = model.isFrozen;
    final Color background = isFrozen
        ? Theme.of(context).colorScheme.primary
        : Theme.of(context).colorScheme.error;

    final Color foreground = Theme.of(context).colorScheme.onPrimary;

    return SizedBox(
      width: double.infinity,
      child: FilledButton(
        onPressed: model.toggleFreeze,
        style: FilledButton.styleFrom(
          padding: const EdgeInsets.symmetric(vertical: 18),
          backgroundColor: background,
          foregroundColor: foreground,
        ),
        child: Text(isFrozen ? '일하는 중' : '딴짓거리 중'),
      ),
    );
  }
}
