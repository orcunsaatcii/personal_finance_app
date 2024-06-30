import 'package:personal_finance_app/models/category/category.dart';
import 'package:personal_finance_app/services/database/database_helper.dart';

class CategoryDao {
  Future<List<Category>> allCategories() async {
    final db = await DatabaseHelper.initDb();

    List<Map<String, dynamic>> allData =
        await db.rawQuery('SELECT * FROM categories');

    return List.generate(allData.length, (index) {
      var data = allData[index];

      return Category(
          categoryId: data['category_id'],
          name: data['name'],
          type: data['type']);
    });
  }

  Future<List<Category>> incomeCategories() async {
    final db = await DatabaseHelper.initDb();

    List<Map<String, dynamic>> allData = await db
        .rawQuery('SELECT * FROM categories WHERE type = ?', ['income']);

    return List.generate(allData.length, (index) {
      var data = allData[index];

      return Category(
          categoryId: data['category_id'],
          name: data['name'],
          type: data['type']);
    });
  }

  Future<List<Category>> expenseCategories() async {
    final db = await DatabaseHelper.initDb();

    List<Map<String, dynamic>> allData = await db
        .rawQuery('SELECT * FROM categories WHERE type = ?', ['expense']);

    return List.generate(allData.length, (index) {
      var data = allData[index];

      return Category(
          categoryId: data['category_id'],
          name: data['name'],
          type: data['type']);
    });
  }

  Future<void> insertCategory(String name, String type) async {
    final db = await DatabaseHelper.initDb();

    var data = <String, dynamic>{};
    data['name'] = name;
    data['type'] = type;

    await db.insert('categories', data);
  }

  Future<void> deleteCategory(int categoryId) async {
    final db = await DatabaseHelper.initDb();

    await db.delete('categories',
        where: 'category_id = ?', whereArgs: [categoryId]);
  }

  Future<bool> isExpenseOrIncome(int categoryId) async {
    final db = await DatabaseHelper.initDb();

    List<Map<String, dynamic>> category = await db.rawQuery(
        'SELECT * from categories WHERE category_id = ?', [categoryId]);

    if (category[0]['type'] == 'income') {
      return true;
    } else {
      return false;
    }
  }

  Future<Map<String, dynamic>> searchCategory(String name, String type) async {
    final db = await DatabaseHelper.initDb();

    List<Map<String, dynamic>> category = await db.rawQuery(
        'SELECT * FROM categories WHERE name = ? and type = ?', [name, type]);

    return category[0];
  }
}
