import 'package:personal_finance_app/models/users.dart';
import 'package:personal_finance_app/services/database/database_helper.dart';

class UsersDao {
  Future<List<Users>> allUsers() async {
    final db = await DatabaseHelper.initDb();

    List<Map<String, dynamic>> map = await db.rawQuery('SELECT * FROM users');

    return List.generate(map.length, (index) {
      var row = map[index];
      return Users(
          userId: row['user_id'],
          name: row['name'],
          email: row['email'],
          password: row['password']);
    });
  }

  Future<void> insertUser(String name, String email, String password) async {
    final db = await DatabaseHelper.initDb();

    var data = <String, dynamic>{};
    data['name'] = name;
    data['email'] = email;
    data['password'] = password;

    try {
      await db.insert('users', data);
    } catch (e) {
      print('Error inserting user: $e');
    }
  }

  Future<bool> userExists(String email, String password) async {
    final db = await DatabaseHelper.initDb();

    List<Map<String, dynamic>> result = await db.rawQuery(
      'SELECT * from users WHERE email = ? and password = ?',
      [email, password],
    );

    if (result.isEmpty) {
      return false;
    } else {
      return true;
    }
  }
}
