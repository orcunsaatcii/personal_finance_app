import 'package:flutter_riverpod/flutter_riverpod.dart';

class BottomNavbarNotifier extends StateNotifier<int> {
  BottomNavbarNotifier() : super(0);

  void changePage(int currentIndex) {
    state = currentIndex;
  }
}

final bottomNavbarProvider = StateNotifierProvider<BottomNavbarNotifier, int>(
  (ref) => BottomNavbarNotifier(),
);
