import 'dart:io';

import 'package:flutter/services.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHelper {
  static const String dbName = 'finance.db';

  static Future<Database> initDb() async {
    String dbPath = join(await getDatabasesPath(), dbName);

    if (!await databaseExists(dbPath)) {
      print('database copied');
      ByteData data = await rootBundle.load('db/$dbName');
      List<int> bytes =
          data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);
      await File(dbPath).writeAsBytes(bytes, flush: true);
    }
    return openDatabase(dbPath);
  }
}
