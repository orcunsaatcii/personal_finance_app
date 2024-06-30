import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:personal_finance_app/models/transaction/transaction_dao.dart';
import 'package:personal_finance_app/models/transaction/transactions.dart';
import 'package:personal_finance_app/models/user/user_dao.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TransactionNotifier extends StateNotifier<Future<List<Transactions>>> {
  TransactionNotifier() : super(Future.value([])) {
    _loadAllTransactions();
  }

  Future<void> _loadAllTransactions() async {
    final sp = await SharedPreferences.getInstance();
    final user = await UsersDao().getLoggedInUser(
      sp.getString('email')!,
      sp.getString('password')!,
    );

    final transactionDao = TransactionsDao();
    state = transactionDao.allTransactions(user['user_id']);
  }

  Future<void> saveNewTransaction(int userId, int categoryId, double amount,
      String date, String desc) async {
    await TransactionsDao()
        .insertTransaction(userId, categoryId, amount, date, desc);
    _loadAllTransactions();
  }
}

final transactionsProvider =
    StateNotifierProvider<TransactionNotifier, Future<List<Transactions>>>(
  (ref) => TransactionNotifier(),
);
