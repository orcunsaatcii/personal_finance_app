import 'package:flutter_riverpod/flutter_riverpod.dart';

class StatisticButtonNotifier extends StateNotifier<bool> {
  StatisticButtonNotifier() : super(true);

  void toggleStatistic(bool selection) {
    state = selection;
  }
}

final statisticButtonProvider =
    StateNotifierProvider<StatisticButtonNotifier, bool>(
  (ref) => StatisticButtonNotifier(),
);
