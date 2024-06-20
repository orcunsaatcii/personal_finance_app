import 'package:personal_finance_app/models/category.dart';
import 'package:personal_finance_app/services/database/database_helper.dart';

class CategoryDao {
  Future<List<Category>> allCategories() async {
    final db = await DatabaseHelper.initDb();

    List<Map<String, dynamic>> allData =
        await db.rawQuery('SELECT * FROM categories');

    return List.generate(allData.length, (index) {
      var data = allData[index];

      return Category(
          categoryId: data['categoryId'],
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
}
