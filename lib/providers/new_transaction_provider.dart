import 'package:flutter_riverpod/flutter_riverpod.dart';

class NewTransactionTypeNotifier extends StateNotifier<bool> {
  NewTransactionTypeNotifier() : super(true);

  void toggleTransactionType(bool selection) {
    state = selection;
  }
}

final newTransactionTypeProvider =
    StateNotifierProvider<NewTransactionTypeNotifier, bool>(
  (ref) => NewTransactionTypeNotifier(),
);
