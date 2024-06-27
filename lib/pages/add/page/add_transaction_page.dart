import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:personal_finance_app/constants/constants.dart';
import 'package:personal_finance_app/models/category.dart';
import 'package:personal_finance_app/providers/category_provider.dart';
import 'package:personal_finance_app/providers/new_transaction_provider.dart';

class AddTransactionPage extends ConsumerStatefulWidget {
  const AddTransactionPage({super.key});

  @override
  ConsumerState<AddTransactionPage> createState() => _AddTransactionPageState();
}

class _AddTransactionPageState extends ConsumerState<AddTransactionPage> {
  Category? _selectedCategory;
  DateTime? _selectedDate;

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

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    bool newTransactionType = ref.watch(newTransactionTypeProvider);
    final categoriesAsyncValue = ref.watch(categoriesProvider);
    return Scaffold(
      appBar: AppBar(
        title: const Text('New Transaction'),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(
            horizontal: screenWidth * 0.08, vertical: 20.0),
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
                          style:
                              Theme.of(context).textTheme.titleLarge!.copyWith(
                                    color: Colors.white,
                                  ),
                        ),
                      ),
                      items: categories
                          .map<DropdownMenuItem<Category>>((Category category) {
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
          ],
        ),
      ),
    );
  }
}
