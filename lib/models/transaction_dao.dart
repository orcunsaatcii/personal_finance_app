import 'package:personal_finance_app/models/transactions.dart';
import 'package:personal_finance_app/services/database/database_helper.dart';

class TransactionsDao {
  Future<List<Transactions>> allTransactions() async {
    final db = await DatabaseHelper.initDb();

    List<Map<String, dynamic>> allData =
        await db.rawQuery('SELECT * FROM transactions');

    return List.generate(allData.length, (index) {
      var data = allData[index];

      return Transactions(
        transactionId: data['transactionId'],
        userId: data['userId'],
        categoryId: data['categoryId'],
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
}
