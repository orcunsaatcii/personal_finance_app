import 'package:d_chart/d_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:personal_finance_app/constants/constants.dart';
import 'package:personal_finance_app/models/transaction/transaction_dao.dart';
import 'package:personal_finance_app/models/transaction/transactions.dart';
import 'package:personal_finance_app/models/user/user_dao.dart';
import 'package:personal_finance_app/providers/statistic_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class StatPage extends ConsumerStatefulWidget {
  const StatPage({super.key});

  @override
  ConsumerState<StatPage> createState() => _StatPageState();
}

class _StatPageState extends ConsumerState<StatPage> {
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

  Map<String, double> groupTransactionsByDescription(
      List<Transactions> transactions) {
    Map<String, double> groupedData = {};

    for (var transaction in transactions) {
      if (groupedData.containsKey(transaction.description)) {
        groupedData[transaction.description] =
            groupedData[transaction.description]! + transaction.amount;
      } else {
        groupedData[transaction.description] = transaction.amount;
      }
    }

    return groupedData;
  }

  List<Color> pieColors = [
    Colors.red,
    Colors.blue,
    Colors.green,
    Colors.yellow,
    Colors.purple,
    Colors.orange,
    Colors.pink,
    Colors.teal,
    Colors.cyan,
    Colors.brown,
  ];

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    bool showIncomeStatistic = ref.watch(statisticButtonProvider);

    return Scaffold(
      appBar: AppBar(
        toolbarHeight: screenHeight * 0.07,
        title: const Text('Statistic'),
      ),
      body: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              InkWell(
                onTap: () {
                  ref
                      .read(statisticButtonProvider.notifier)
                      .toggleStatistic(true);
                },
                child: Container(
                  width: screenWidth / 2,
                  height: screenHeight * 0.07,
                  decoration: BoxDecoration(
                    border: Border(
                      bottom: BorderSide(
                        color: showIncomeStatistic
                            ? Colors.deepPurple
                            : Colors.grey,
                        width: 3,
                      ),
                    ),
                  ),
                  child: Center(
                    child: Text(
                      'Income',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                  ),
                ),
              ),
              InkWell(
                onTap: () {
                  ref
                      .read(statisticButtonProvider.notifier)
                      .toggleStatistic(false);
                },
                child: Container(
                  width: screenWidth / 2,
                  height: screenHeight * 0.07,
                  decoration: BoxDecoration(
                    border: Border(
                      bottom: BorderSide(
                        color: !showIncomeStatistic
                            ? Colors.deepPurple
                            : Colors.grey,
                        width: 3,
                      ),
                    ),
                  ),
                  child: Center(
                    child: Text(
                      'Expense',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                  ),
                ),
              ),
            ],
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 15),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    flex: 4,
                    child: FutureBuilder<List<Transactions>>(
                      future: showIncomeStatistic
                          ? showUsersIncomes()
                          : showUsersExpenses(),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return Container();
                        } else if (snapshot.hasError) {
                          return const Center(
                            child: Text('Error: Fetching statistics'),
                          );
                        } else if (snapshot.hasData) {
                          if (snapshot.data!.isEmpty) {
                            return const Center(
                              child: Text('There is no statistic right now'),
                            );
                          } else {
                            final transactions = snapshot.data!;
                            final groupedData =
                                groupTransactionsByDescription(transactions);
                            int colorIndex = 0;
                            double totalTransaction = 0;
                            for (var transaction in transactions) {
                              totalTransaction += transaction.amount;
                            }
                            return Stack(
                              children: [
                                DChartPieO(
                                  data: groupedData.entries
                                      .map(
                                        (entry) => OrdinalData(
                                          domain: entry.key,
                                          measure: entry.value,
                                          color: pieColors[
                                              colorIndex++ % pieColors.length],
                                        ),
                                      )
                                      .toList(),
                                  configRenderPie:
                                      const ConfigRenderPie(arcWidth: 30),
                                  animate: true,
                                ),
                                Center(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        showIncomeStatistic
                                            ? 'TOTAL INCOME'
                                            : 'TOTAL EXPENSE',
                                        style: Theme.of(context)
                                            .textTheme
                                            .titleLarge!
                                            .copyWith(
                                              color: Colors.grey,
                                            ),
                                      ),
                                      const SizedBox(height: 10),
                                      Text(
                                        showIncomeStatistic
                                            ? '+${totalTransaction.toStringAsFixed(2)} €'
                                            : '-${totalTransaction.toStringAsFixed(2)} €',
                                        style: Theme.of(context)
                                            .textTheme
                                            .headlineMedium!
                                            .copyWith(
                                              color: showIncomeStatistic
                                                  ? Colors.green
                                                  : Colors.red,
                                              fontWeight: FontWeight.bold,
                                            ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            );
                          }
                        } else {
                          return const Center(
                            child: Text('No data available'),
                          );
                        }
                      },
                    ),
                  ),
                  Expanded(
                    flex: 4,
                    child: FutureBuilder<List<Transactions>>(
                      future: showIncomeStatistic
                          ? showUsersIncomes()
                          : showUsersExpenses(),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return Container();
                        } else if (snapshot.hasError) {
                          return const Center(
                            child: Text('Error: Fetching statistics'),
                          );
                        } else if (snapshot.hasData) {
                          if (snapshot.data!.isEmpty) {
                            return const Center(
                              child: Text('There is no statistic right now'),
                            );
                          } else {
                            final transactions = snapshot.data!;
                            final groupedData =
                                groupTransactionsByDescription(transactions);
                            int colorIndex = 0;
                            double totalTransaction = 0;
                            for (var transaction in transactions) {
                              totalTransaction += transaction.amount;
                            }
                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  showIncomeStatistic
                                      ? 'Income Breakdown'
                                      : 'Expense Breakdown',
                                  style: Theme.of(context)
                                      .textTheme
                                      .titleLarge!
                                      .copyWith(
                                        fontWeight: FontWeight.bold,
                                      ),
                                ),
                                sizedBoxHeight(20),
                                Expanded(
                                  child: ListView.builder(
                                    itemCount: groupedData.length,
                                    itemBuilder: (context, index) {
                                      final entry =
                                          groupedData.entries.elementAt(index);
                                      return Column(
                                        children: [
                                          sizedBoxHeight(20),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            children: [
                                              SizedBox(
                                                width: screenWidth / 3,
                                                child: Text(
                                                  entry.key,
                                                  style: Theme.of(context)
                                                      .textTheme
                                                      .titleMedium,
                                                ),
                                              ),
                                              SizedBox(
                                                width: screenWidth / 3,
                                                child: Text(
                                                  showIncomeStatistic
                                                      ? '+${entry.value.toStringAsFixed(2)} €'
                                                      : '-${entry.value.toStringAsFixed(2)} €',
                                                  style: Theme.of(context)
                                                      .textTheme
                                                      .titleMedium!
                                                      .copyWith(
                                                        color:
                                                            showIncomeStatistic
                                                                ? Colors.green
                                                                : Colors.red,
                                                      ),
                                                ),
                                              ),
                                              Container(
                                                width: screenWidth * 0.14,
                                                height: screenHeight * 0.04,
                                                decoration: BoxDecoration(
                                                  color: pieColors[
                                                      colorIndex++ %
                                                          pieColors.length],
                                                  borderRadius:
                                                      BorderRadiusDirectional
                                                          .circular(5),
                                                ),
                                                child: Center(
                                                  child: Text(
                                                    '${((entry.value / totalTransaction) * 100).toStringAsFixed(2)}%',
                                                    style: const TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                          sizedBoxHeight(20),
                                          const Divider(),
                                        ],
                                      );
                                    },
                                  ),
                                ),
                              ],
                            );
                          }
                        } else {
                          return const Center(
                            child: Text('No data available'),
                          );
                        }
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
