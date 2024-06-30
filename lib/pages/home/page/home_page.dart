import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:personal_finance_app/constants/constants.dart';
import 'package:personal_finance_app/models/category/category_dao.dart';
import 'package:personal_finance_app/models/transaction/transaction_dao.dart';
import 'package:personal_finance_app/models/transaction/transactions.dart';
import 'package:personal_finance_app/models/user/user_dao.dart';
import 'package:personal_finance_app/pages/add/page/add_transaction_page.dart';
import 'package:personal_finance_app/pages/auth/login/loginpage.dart';
import 'package:personal_finance_app/pages/home/widgets/transaction_item.dart';
import 'package:personal_finance_app/providers/transactions_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomePage extends ConsumerStatefulWidget {
  const HomePage({super.key});

  @override
  ConsumerState<HomePage> createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage> {
  Future<void> logout() async {
    if (mounted) {
      final sp = await SharedPreferences.getInstance();
      sp.remove('email');
      sp.remove('password');
      Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => const LoginPage(),
          ));
    }
  }

  Future<List<Transactions>> showUsersExpenses() async {
    final sp = await SharedPreferences.getInstance();

    final user = await UsersDao()
        .getLoggedInUser(sp.getString('email')!, sp.getString('password')!);
    return await TransactionsDao().usersExpneses(user['user_id']);
  }

  Future<List<Transactions>> showUsersIncomes() async {
    final sp = await SharedPreferences.getInstance();

    final user = await UsersDao()
        .getLoggedInUser(sp.getString('email')!, sp.getString('password')!);
    return await TransactionsDao().usersIncomes(user['user_id']);
  }

  Future<double> showSavingRate() async {
    final sp = await SharedPreferences.getInstance();
    final user = await UsersDao()
        .searchUser(sp.getString('email')!, sp.getString('password')!);

    final expenses = await TransactionsDao().usersExpneses(user['user_id']);
    final incomes = await TransactionsDao().usersIncomes(user['user_id']);

    double totalIncome = 0;
    double totalExpnese = 0;

    for (var expense in expenses) {
      totalExpnese += expense.amount;
    }
    for (var income in incomes) {
      totalIncome += income.amount;
    }

    return totalIncome - totalExpnese;
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    final transactionsAsyncValue = ref.watch(transactionsProvider);

    return Scaffold(
      body: Stack(
        children: [
          Column(
            children: [
              Container(
                height: screenHeight * 0.30,
                width: screenWidth,
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Color.fromARGB(255, 1, 10, 70),
                      Color.fromARGB(255, 0, 22, 167),
                    ],
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                  ),
                ),
                child: SafeArea(
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                        horizontal: screenWidth * 0.08, vertical: 10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Hello ${'o' 'name'}asd!',
                              style: Theme.of(context)
                                  .textTheme
                                  .titleLarge!
                                  .copyWith(
                                    color: Colors.white,
                                  ),
                            ),
                            IconButton(
                              onPressed: logout,
                              icon: const Icon(
                                Icons.logout,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                        Text(
                          'Welcome back',
                          style:
                              Theme.of(context).textTheme.titleMedium!.copyWith(
                                    color: Colors.grey,
                                  ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Expanded(
                child: Padding(
                  padding: EdgeInsets.symmetric(
                      horizontal: screenWidth * 0.08, vertical: 40.0),
                  child: Column(
                    children: [
                      Expanded(
                        child: FutureBuilder<List<Transactions>>(
                          future: transactionsAsyncValue,
                          builder: (context, snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return Container();
                            } else if (snapshot.hasError) {
                              return const Center(
                                  child: Text('Error loading transactions'));
                            } else if (!snapshot.hasData ||
                                snapshot.data!.isEmpty) {
                              return const Center(
                                  child: Text('No transactions found'));
                            }
                            return ListView.builder(
                              itemCount: snapshot.data!.length,
                              itemBuilder: (context, index) {
                                final transaction = snapshot.data![index];

                                return FutureBuilder<bool>(
                                  future: CategoryDao().isExpenseOrIncome(
                                      transaction.categoryId),
                                  builder: (context,
                                      AsyncSnapshot<bool> transactionSnapshot) {
                                    if (transactionSnapshot.connectionState ==
                                        ConnectionState.waiting) {
                                      return Container();
                                    } else if (transactionSnapshot.hasError) {
                                      return Center(
                                          child: Text(
                                              'Error: ${transactionSnapshot.error}'));
                                    } else if (transactionSnapshot.hasData) {
                                      final bool isExpense =
                                          transactionSnapshot.data!;
                                      String transactionType =
                                          !isExpense ? 'expense' : 'income';
                                      return TransactionItem(
                                        transaction: transaction,
                                        transactionType: transactionType,
                                      );
                                    } else {
                                      return const Center(
                                          child: Text(
                                              'No transaction data available'));
                                    }
                                  },
                                );
                              },
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          Positioned(
            left: screenWidth * 0.08,
            right: screenWidth * 0.08,
            top: screenHeight * 0.15,
            child: Container(
              height: screenHeight * 0.22,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(15),
                boxShadow: const [
                  BoxShadow(color: Colors.grey, blurRadius: 5),
                ],
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: 10.0, vertical: 10.0),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Text(
                          'Budget Summary',
                          style: Theme.of(context)
                              .textTheme
                              .headlineSmall!
                              .copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                        ),
                        const Spacer(),
                        IconButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    const AddTransactionPage(),
                              ),
                            );
                          },
                          icon: const Icon(
                            Icons.add,
                            color: Colors.black,
                            size: 30,
                          ),
                        ),
                      ],
                    ),
                    const LinearProgressIndicator(
                      valueColor: AlwaysStoppedAnimation(Colors.red),
                      value: 50 / 100,
                    ),
                    sizedBoxHeight(20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Incomes',
                          style:
                              Theme.of(context).textTheme.titleMedium!.copyWith(
                                    color: Colors.grey,
                                  ),
                        ),
                        FutureBuilder<List<Transactions>>(
                          future: showUsersIncomes(),
                          builder: (context, snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return const Center(
                                child: SizedBox(
                                  width: 10.0,
                                  height: 10.0,
                                  child: CircularProgressIndicator(),
                                ),
                              );
                            } else if (snapshot.hasError) {
                              return const Center(child: Text('......'));
                            } else if (!snapshot.hasData ||
                                snapshot.data!.isEmpty) {
                              return const Center(child: Text('......'));
                            } else {
                              double totalIncome = 0;
                              final incomes = snapshot.data;

                              for (var income in incomes!) {
                                totalIncome += income.amount;
                              }
                              return Text(
                                '+${totalIncome.toStringAsFixed(2)} €',
                                style: Theme.of(context)
                                    .textTheme
                                    .titleMedium!
                                    .copyWith(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.green,
                                    ),
                              );
                            }
                          },
                        ),
                      ],
                    ),
                    sizedBoxHeight(5),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Expenses',
                          style:
                              Theme.of(context).textTheme.titleMedium!.copyWith(
                                    color: Colors.grey,
                                  ),
                        ),
                        FutureBuilder<List<Transactions>>(
                          future: showUsersExpenses(),
                          builder: (context, snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return const Center(
                                child: SizedBox(
                                  width: 10.0,
                                  height: 10.0,
                                  child: CircularProgressIndicator(),
                                ),
                              );
                            } else if (snapshot.hasError) {
                              return const Center(child: Text('......'));
                            } else if (!snapshot.hasData ||
                                snapshot.data!.isEmpty) {
                              return const Center(child: Text('......'));
                            } else {
                              double totalExpense = 0;
                              final expenses = snapshot.data;

                              for (var expense in expenses!) {
                                totalExpense += expense.amount;
                              }
                              return Text(
                                '-${totalExpense.toStringAsFixed(2)} €',
                                style: Theme.of(context)
                                    .textTheme
                                    .titleMedium!
                                    .copyWith(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.red,
                                    ),
                              );
                            }
                          },
                        ),
                      ],
                    ),
                    const Divider(),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Saving Rate',
                          style:
                              Theme.of(context).textTheme.titleMedium!.copyWith(
                                    color: Colors.grey,
                                  ),
                        ),
                        FutureBuilder<double>(
                          future: showSavingRate(),
                          builder: (context, snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return const Center(
                                child: SizedBox(
                                  width: 10.0,
                                  height: 10.0,
                                  child: CircularProgressIndicator(),
                                ),
                              );
                            } else if (snapshot.hasError) {
                              return const Center(child: Text('......'));
                            } else if (!snapshot.hasData) {
                              return const Center(child: Text('......'));
                            } else {
                              final savingRate = snapshot.data!;
                              return Text(
                                (savingRate < 0)
                                    ? '${savingRate.toStringAsFixed(2)} €'
                                    : '+${savingRate.toStringAsFixed(2)} €',
                                style: Theme.of(context)
                                    .textTheme
                                    .titleMedium!
                                    .copyWith(
                                      fontWeight: FontWeight.bold,
                                      color: (savingRate < 0)
                                          ? Colors.red
                                          : Colors.green,
                                    ),
                              );
                            }
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
