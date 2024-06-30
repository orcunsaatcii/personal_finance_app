import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:personal_finance_app/models/category/category.dart';
import 'package:personal_finance_app/models/category/category_dao.dart';

final incomeCategoriesProvider = FutureProvider<List<Category>>((ref) async {
  final categoryDao = CategoryDao();
  return categoryDao.incomeCategories();
});

final expenseCategoriesProvider = FutureProvider<List<Category>>((ref) async {
  final categoryDao = CategoryDao();
  return categoryDao.expenseCategories();
});
