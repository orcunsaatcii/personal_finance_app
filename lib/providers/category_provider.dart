import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:personal_finance_app/models/category.dart';
import 'package:personal_finance_app/models/category_dao.dart';

final categoriesProvider = FutureProvider<List<Category>>((ref) async {
  final categoryDao = CategoryDao();
  return categoryDao.allCategories();
});
