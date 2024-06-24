import 'package:personal_finance_app/models/transactions.dart';
import 'package:personal_finance_app/services/database/database_helper.dart';

class TransactionsDao {
  Future<List<Transactions>> allTransactions(int userId) async {
    final db = await DatabaseHelper.initDb();

    List<Map<String, dynamic>> allData = await db
        .rawQuery('SELECT * FROM transactions WHERE user_id = ?', [userId]);

    return List.generate(allData.length, (index) {
      var data = allData[index];

      return Transactions(
        transactionId: data['transaction_id'],
        userId: data['user_id'],
        categoryId: data['category_id'],
        amount: data['amount'],
        date: data['date'],
        description: data['description'],
      );
    });
  }

  Future<void> insertTransaction(int userId, int categoryId, double amount,
      String date, String description) async {
    final db = await DatabaseHelper.initDb();

    var data = <String, dynamic>{};
    data['userId'] = userId;
    data['categoryId'] = categoryId;
    data['amount'] = amount;
    data['date'] = date;
    data['description'] = description;

    await db.insert('transactions', data);
  }

  Future<void> insertTransactionWithQuery(query) async {
    final db = await DatabaseHelper.initDb();
    try {
      await db.rawInsert(query);
    } catch (e) {
      print('Error inserting transaction: $e');
    }
  }

  Future<List<Transactions>> usersExpneses(int userId) async {
    final db = await DatabaseHelper.initDb();

    List<Map<String, dynamic>> expenses = await db.rawQuery(
        'SELECT * FROM categories NATURAL JOIN transactions WHERE user_id = ? and type = ?',
        [userId, 'expense']);

    return List.generate(
      expenses.length,
      (index) {
        final expense = expenses[index];
        return Transactions(
            transactionId: expense['transaction_id'],
            userId: expense['user_id'],
            categoryId: expense['category_id'],
            amount: expense['amount'],
            date: expense['date'],
            description: expense['description']);
      },
    );
  }

  Future<List<Transactions>> usersIncomes(int userId) async {
    final db = await DatabaseHelper.initDb();

    List<Map<String, dynamic>> incomes = await db.rawQuery(
        'SELECT * FROM categories NATURAL JOIN transactions WHERE user_id = ? and type = ?',
        [userId, 'income']);

    return List.generate(
      incomes.length,
      (index) {
        final income = incomes[index];
        return Transactions(
            transactionId: income['transaction_id'],
            userId: income['user_id'],
            categoryId: income['category_id'],
            amount: income['amount'],
            date: income['date'],
            description: income['description']);
      },
    );
  }
}
