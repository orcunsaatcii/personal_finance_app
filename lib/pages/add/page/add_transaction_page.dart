import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:personal_finance_app/constants/constants.dart';
import 'package:personal_finance_app/models/category/category.dart';
import 'package:personal_finance_app/models/category/category_dao.dart';
import 'package:personal_finance_app/models/transaction/transaction_dao.dart';
import 'package:personal_finance_app/models/user/user_dao.dart';
import 'package:personal_finance_app/providers/category_provider.dart';
import 'package:personal_finance_app/providers/new_transaction_provider.dart';
import 'package:personal_finance_app/providers/transactions_provider.dart';
import 'package:personal_finance_app/services/database/database_helper.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sqflite/sqflite.dart';

class AddTransactionPage extends ConsumerStatefulWidget {
  const AddTransactionPage({super.key});

  @override
  ConsumerState<AddTransactionPage> createState() => _AddTransactionPageState();
}

class _AddTransactionPageState extends ConsumerState<AddTransactionPage> {
  Category? _selectedCategory;
  DateTime? _selectedDate;
  final _amountController = TextEditingController();
  final _descriptionController = TextEditingController();

  Future<void> selectDate() async {
    final lastDate = DateTime.now();
    final firstDate = DateTime.utc(DateTime.now().year - 1);
    DateTime? date = await showDatePicker(
      context: context,
      firstDate: firstDate,
      lastDate: lastDate,
    );

    if (date == null) {
      return;
    }

    setState(() {
      _selectedDate = date;
    });
  }

  Future<void> saveNewTransaction() async {
    final sp = await SharedPreferences.getInstance();
    final user = await UsersDao()
        .getLoggedInUser(sp.getString('email')!, sp.getString('password')!);

    if (mounted) {
      if (_selectedCategory == null ||
          _selectedDate == null ||
          _amountController.text.isEmpty ||
          _descriptionController.text.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              'Please fill the all blank fields.',
            ),
          ),
        );
      } else {
        if (double.tryParse(_amountController.text) == null ||
            double.tryParse(_amountController.text)! <= 0) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text(
                'Please enter a valid amount.',
              ),
            ),
          );
        } else {
          final category = await CategoryDao().searchCategory(
            _selectedCategory!.name.toString(),
            _selectedCategory!.type.toString(),
          );
          final double enteredAmount = double.tryParse(_amountController.text)!;
          final int year = _selectedDate!.year;
          final int month = _selectedDate!.month;
          final int day = _selectedDate!.day;
          final String enteredDate = '$year-$month-$day';

          try {
            await ref.read(transactionsProvider.notifier).saveNewTransaction(
                  user['user_id'],
                  category['category_id'],
                  enteredAmount,
                  enteredDate,
                  _descriptionController.text,
                );

            Navigator.pop(context);
          } catch (e) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  e.toString(),
                ),
              ),
            );
          }
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    bool newTransactionType = ref.watch(newTransactionTypeProvider);

    final categoriesAsyncValue = newTransactionType
        ? ref.watch(incomeCategoriesProvider)
        : ref.watch(expenseCategoriesProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('New Transaction'),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(
            horizontal: screenWidth * 0.08, vertical: 20.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Stack(
                children: [
                  Container(
                    height: screenHeight * 0.10,
                    width: screenWidth * 0.84,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                      color: const Color.fromARGB(255, 38, 38, 64),
                      boxShadow: const [
                        BoxShadow(
                          color: Colors.blue,
                          blurRadius: 10,
                          blurStyle: BlurStyle.inner,
                          offset: Offset(-4, -4),
                        ),
                      ],
                    ),
                  ),
                  Positioned(
                    top: 10,
                    bottom: 10,
                    right: 10,
                    left: 10,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        InkWell(
                          onTap: () {
                            ref
                                .read(newTransactionTypeProvider.notifier)
                                .toggleTransactionType(true);

                            setState(() {
                              _selectedCategory = null;
                            });
                          },
                          child: Container(
                            height: screenHeight * 0.08,
                            width: screenWidth * 0.38,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(15),
                              gradient: newTransactionType
                                  ? const LinearGradient(
                                      colors: [
                                        Color.fromARGB(255, 48, 48, 78),
                                        Color.fromARGB(255, 92, 92, 116),
                                      ],
                                      begin: Alignment.bottomRight,
                                      end: Alignment.topLeft,
                                    )
                                  : null,
                              boxShadow: newTransactionType
                                  ? const [
                                      BoxShadow(
                                        color: Colors.white,
                                        blurRadius: 4,
                                        blurStyle: BlurStyle.outer,
                                      )
                                    ]
                                  : null,
                            ),
                            child: Center(
                              child: Text(
                                'Income',
                                style: Theme.of(context)
                                    .textTheme
                                    .titleLarge!
                                    .copyWith(
                                      color: newTransactionType
                                          ? Colors.white
                                          : Colors.grey,
                                    ),
                              ),
                            ),
                          ),
                        ),
                        const Spacer(),
                        InkWell(
                          onTap: () {
                            ref
                                .read(newTransactionTypeProvider.notifier)
                                .toggleTransactionType(false);

                            setState(() {
                              _selectedCategory = null;
                            });
                          },
                          child: Container(
                            height: screenHeight * 0.08,
                            width: screenWidth * 0.38,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(15),
                              gradient: !newTransactionType
                                  ? const LinearGradient(
                                      colors: [
                                        Color.fromARGB(255, 48, 48, 78),
                                        Color.fromARGB(255, 92, 92, 116),
                                      ],
                                      begin: Alignment.bottomRight,
                                      end: Alignment.topLeft,
                                    )
                                  : null,
                              boxShadow: !newTransactionType
                                  ? const [
                                      BoxShadow(
                                        color: Colors.white,
                                        blurRadius: 4,
                                        blurStyle: BlurStyle.outer,
                                      )
                                    ]
                                  : null,
                            ),
                            child: Center(
                              child: Text(
                                'Expense',
                                style: Theme.of(context)
                                    .textTheme
                                    .titleLarge!
                                    .copyWith(
                                      color: !newTransactionType
                                          ? Colors.white
                                          : Colors.grey,
                                    ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              sizedBoxHeight(20),
              Text(
                'Category',
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              sizedBoxHeight(20),
              categoriesAsyncValue.when(
                data: (categories) {
                  return Container(
                    height: screenHeight * 0.10,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                      gradient: const LinearGradient(
                        colors: [
                          Color.fromARGB(255, 48, 48, 78),
                          Color.fromARGB(255, 92, 92, 116),
                        ],
                        begin: Alignment.bottomRight,
                        end: Alignment.topLeft,
                      ),
                      boxShadow: const [
                        BoxShadow(
                          color: Colors.blue,
                          blurRadius: 10,
                          blurStyle: BlurStyle.inner,
                          offset: Offset(-4, -4),
                        ),
                      ],
                    ),
                    child: Center(
                      child: DropdownButton<Category>(
                        underline: const SizedBox.shrink(),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 50.0, vertical: 5.0),
                        iconSize: 40,
                        icon: const Icon(
                          Icons.keyboard_arrow_down,
                          color: Colors.white,
                        ),
                        menuMaxHeight: 300,
                        isExpanded: true,
                        value: _selectedCategory,
                        style: Theme.of(context).textTheme.titleLarge!.copyWith(
                              color: Colors.white,
                            ),
                        dropdownColor: const Color.fromARGB(255, 48, 48, 78),
                        hint: Center(
                          child: Text(
                            'Select Category',
                            style: Theme.of(context)
                                .textTheme
                                .titleLarge!
                                .copyWith(
                                  color: Colors.white,
                                ),
                          ),
                        ),
                        items: categories.map<DropdownMenuItem<Category>>(
                            (Category category) {
                          return DropdownMenuItem<Category>(
                            value: category,
                            child: Center(
                              child: Text(category.name),
                            ),
                          );
                        }).toList(),
                        onChanged: (Category? newValue) {
                          setState(() {
                            _selectedCategory = newValue;
                          });
                        },
                      ),
                    ),
                  );
                },
                loading: () => const CircularProgressIndicator(),
                error: (err, stack) => Text('Error: $err'),
              ),
              sizedBoxHeight(10),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Expanded(
                    child: Container(
                      height: screenHeight * 0.10,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                        gradient: const LinearGradient(
                          colors: [
                            Color.fromARGB(255, 48, 48, 78),
                            Color.fromARGB(255, 92, 92, 116),
                          ],
                          begin: Alignment.bottomRight,
                          end: Alignment.topLeft,
                        ),
                        boxShadow: const [
                          BoxShadow(
                            color: Colors.blue,
                            blurRadius: 10,
                            blurStyle: BlurStyle.inner,
                            offset: Offset(-4, -4),
                          ),
                        ],
                      ),
                      child: Center(
                        child: _selectedDate == null
                            ? Text(
                                'Select Date',
                                style: Theme.of(context)
                                    .textTheme
                                    .titleLarge!
                                    .copyWith(
                                      color: Colors.white,
                                    ),
                              )
                            : Text(
                                DateFormat.yMd()
                                    .format(_selectedDate!)
                                    .toString(),
                                style: Theme.of(context)
                                    .textTheme
                                    .titleLarge!
                                    .copyWith(
                                      color: Colors.white,
                                    ),
                              ),
                      ),
                    ),
                  ),
                  sizedBoxWidth(10),
                  InkWell(
                    onTap: selectDate,
                    child: Container(
                      height: screenHeight * 0.10,
                      width: screenHeight * 0.10,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                        gradient: const LinearGradient(
                          colors: [
                            Color.fromARGB(255, 48, 48, 78),
                            Color.fromARGB(255, 92, 92, 116),
                          ],
                          begin: Alignment.bottomRight,
                          end: Alignment.topLeft,
                        ),
                        boxShadow: const [
                          BoxShadow(
                            color: Colors.blue,
                            blurRadius: 10,
                            blurStyle: BlurStyle.inner,
                            offset: Offset(-4, -4),
                          ),
                        ],
                      ),
                      child: Center(
                        child: _selectedDate == null
                            ? const Icon(
                                Icons.calendar_month_outlined,
                                color: Colors.white,
                                size: 40,
                              )
                            : const Icon(
                                Icons.restart_alt,
                                color: Colors.white,
                                size: 40,
                              ),
                      ),
                    ),
                  ),
                ],
              ),
              sizedBoxHeight(30),
              SizedBox(
                child: Center(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 50.0, vertical: 5.0),
                    child: Column(
                      children: [
                        Text(
                          'Enter Amount Below',
                          style: Theme.of(context).textTheme.headlineSmall,
                        ),
                        TextField(
                          controller: _amountController,
                          showCursor: false,
                          decoration: const InputDecoration(
                            hintText: '0',
                            suffixIcon: Text(
                              '€',
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 50,
                              ),
                            ),
                            border: InputBorder.none,
                          ),
                          textAlign: TextAlign.center,
                          style: Theme.of(context)
                              .textTheme
                              .displayMedium!
                              .copyWith(
                                color: Colors.black,
                              ),
                          keyboardType: TextInputType.number,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              sizedBoxHeight(20),
              Text(
                'Description',
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              sizedBoxHeight(20),
              Container(
                height: screenHeight * 0.10,
                clipBehavior: Clip.hardEdge,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                  gradient: const LinearGradient(
                    colors: [
                      Color.fromARGB(255, 48, 48, 78),
                      Color.fromARGB(255, 92, 92, 116),
                    ],
                    begin: Alignment.bottomRight,
                    end: Alignment.topLeft,
                  ),
                  boxShadow: const [
                    BoxShadow(
                      color: Colors.blue,
                      blurRadius: 10,
                      blurStyle: BlurStyle.inner,
                      offset: Offset(-4, -4),
                    ),
                  ],
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15.0),
                  child: TextField(
                    controller: _descriptionController,
                    maxLines: 3,
                    cursorColor: Colors.white,
                    decoration: const InputDecoration(
                      border: InputBorder.none,
                    ),
                    style: Theme.of(context).textTheme.titleLarge!.copyWith(
                          color: Colors.white,
                        ),
                  ),
                ),
              ),
              sizedBoxHeight(20),
              InkWell(
                onTap: saveNewTransaction,
                child: Container(
                  height: screenHeight * 0.07,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    gradient: const LinearGradient(
                      colors: [
                        Color.fromARGB(255, 0, 200, 255),
                        Color.fromARGB(255, 6, 88, 155),
                      ],
                      begin: Alignment.centerLeft,
                      end: Alignment.centerRight,
                    ),
                  ),
                  child: Center(
                    child: Text(
                      'Save',
                      style: Theme.of(context).textTheme.titleLarge!.copyWith(
                            color: Colors.white,
                          ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
