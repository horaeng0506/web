import 'dart:async';

import 'package:flutter/foundation.dart';

class TimerModel extends ChangeNotifier {
  TimerModel({Duration tickInterval = const Duration(milliseconds: 200)}) {
    userTarget = DateTime.now().add(const Duration(hours: 1));
    isFrozen = true;
    frozenTarget = userTarget;

    _ticker = Timer.periodic(tickInterval, (_) => notifyListeners());
  }

  late DateTime userTarget;
  bool isFrozen = false;
  DateTime? frozenTarget;
  DateTime? resumeStart;

  Timer? _ticker;

  DateTime get now => DateTime.now();
  DateTime get displayedTarget {
    if (isFrozen) {
      return frozenTarget ?? userTarget;
    }

    if (frozenTarget != null && resumeStart != null) {
      final elapsed = now.difference(resumeStart!);
      return frozenTarget!.add(elapsed);
    }

    return userTarget;
  }

  void toggleFreeze() {
    if (isFrozen) {
      resumeStart = now;
      isFrozen = false;
    } else {
      frozenTarget = displayedTarget;
      resumeStart = null;
      isFrozen = true;
    }
    notifyListeners();
  }

  void addInterval(Duration delta) {
    if (isFrozen) {
      final base = frozenTarget ?? userTarget;
      frozenTarget = base.add(delta);
    } else {
      if (frozenTarget != null && resumeStart != null) {
        frozenTarget = frozenTarget!.add(delta);
      } else {
        userTarget = userTarget.add(delta);
      }
    }
    notifyListeners();
  }

  void setUserTarget(DateTime target) {
    final clamped = target.isBefore(now) ? now : target;
    userTarget = clamped;
    if (!isFrozen) {
      frozenTarget = null;
      resumeStart = null;
    }
    notifyListeners();
  }

  @override
  void dispose() {
    _ticker?.cancel();
    super.dispose();
  }
}
