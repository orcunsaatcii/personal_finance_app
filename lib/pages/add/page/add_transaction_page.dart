import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:personal_finance_app/constants/constants.dart';
import 'package:personal_finance_app/providers/new_transaction_provider.dart';

class AddTransactionPage extends ConsumerStatefulWidget {
  const AddTransactionPage({super.key});

  @override
  ConsumerState<AddTransactionPage> createState() => _AddTransactionPageState();
}

class _AddTransactionPageState extends ConsumerState<AddTransactionPage> {
  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    bool newTransactionType = ref.watch(newTransactionTypeProvider);
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
          ],
        ),
      ),
    );
  }
}
