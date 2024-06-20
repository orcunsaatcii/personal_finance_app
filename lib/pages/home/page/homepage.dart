import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:personal_finance_app/constants/constants.dart';
import 'package:personal_finance_app/models/category.dart';
import 'package:personal_finance_app/models/category_dao.dart';
import 'package:personal_finance_app/models/transaction_dao.dart';
import 'package:personal_finance_app/models/user_dao.dart';
import 'package:personal_finance_app/pages/auth/login/loginpage.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Future<void> logout() async {
    final sp = await SharedPreferences.getInstance();
    await sp.remove('email');
    if (mounted) {
      Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => const LoginPage(),
          ));
    }
  }

  Future<void> addtransaction() async {
    List<String> transactions = [
      "INSERT INTO transactions (user_id, category_id, amount, date, description) VALUES (1, 15, 2245.73, '2024-07-01', 'Monthly salary')",
      "INSERT INTO transactions (user_id, category_id, amount, date, description) VALUES (1, 23, 850.00, '2024-07-25', 'Monthly rent')",
      "INSERT INTO transactions (user_id, category_id, amount, date, description) VALUES (1, 28, 186.50, '2024-07-20', 'Groceries and supplies')",
      "INSERT INTO transactions (user_id, category_id, amount, date, description) VALUES (1, 25, 120.00, '2024-07-28', 'Utilities')",
      "INSERT INTO transactions (user_id, category_id, amount, date, description) VALUES (7, 21, 1610.45, '2024-07-15', 'Freelance project payment')",
      "INSERT INTO transactions (user_id, category_id, amount, date, description) VALUES (7, 27, 250.00, '2024-07-10', 'Education payment')",
      "INSERT INTO transactions (user_id, category_id, amount, date, description) VALUES (7, 23, 850.00, '2024-07-25', 'Monthly rent')",
      "INSERT INTO transactions (user_id, category_id, amount, date, description) VALUES (7, 16, 423.23, '2024-07-28', 'Bonus')",
      "INSERT INTO transactions (user_id, category_id, amount, date, description) VALUES (8, 15, 1412.83, '2024-06-01', 'Monthly salary')",
      "INSERT INTO transactions (user_id, category_id, amount, date, description) VALUES (8, 22, 953.53, '2024-07-25', 'Monthly food')",
      "INSERT INTO transactions (user_id, category_id, amount, date, description) VALUES (8, 28, 138.20, '2024-07-14', 'Groceries')",
      "INSERT INTO transactions (user_id, category_id, amount, date, description) VALUES (8, 34, 715.75, '2024-07-16', 'Personal care')",
      "INSERT INTO transactions (user_id, category_id, amount, date, description) VALUES (9, 15, 1802.10, '2024-06-01', 'Monthly salary')",
      "INSERT INTO transactions (user_id, category_id, amount, date, description) VALUES (9, 20, 950.00, '2024-07-25', 'Tax refund')",
      "INSERT INTO transactions (user_id, category_id, amount, date, description) VALUES (9, 28, 238.60, '2024-07-14', 'Groceries')",
      "INSERT INTO transactions (user_id, category_id, amount, date, description) VALUES (9, 33, 699.90, '2024-07-16', 'Household item shopping')",
      "INSERT INTO transactions (user_id, category_id, amount, date, description) VALUES (1, 15, 2225.40, '2024-08-01', 'Monthly salary')",
      "INSERT INTO transactions (user_id, category_id, amount, date, description) VALUES (1, 18, 500.00, '2024-08-05', 'Scholarship')",
      "INSERT INTO transactions (user_id, category_id, amount, date, description) VALUES (1, 21, 750.00, '2024-08-12', 'Freelance work')",
      "INSERT INTO transactions (user_id, category_id, amount, date, description) VALUES (1, 24, 150.00, '2024-08-20', 'Entertainment')",
      "INSERT INTO transactions (user_id, category_id, amount, date, description) VALUES (1, 29, 842.90, '2024-08-25', 'Clothing expense')",
      "INSERT INTO transactions (user_id, category_id, amount, date, description) VALUES (7, 26, 650.00, '2024-08-01', 'Flight ticket')",
      "INSERT INTO transactions (user_id, category_id, amount, date, description) VALUES (7, 31, 170.00, '2024-08-10', 'TEMA charity')",
      "INSERT INTO transactions (user_id, category_id, amount, date, description) VALUES (7, 23, 900.00, '2024-08-25', 'Monthly rent')",
      "INSERT INTO transactions (user_id, category_id, amount, date, description) VALUES (7, 19, 834.25, '2024-08-15', 'Investment')",
      "INSERT INTO transactions (user_id, category_id, amount, date, description) VALUES (8, 1, 1522.87, '2024-08-01', 'Monthly salary')",
      "INSERT INTO transactions (user_id, category_id, amount, date, description) VALUES (8, 32, 190.00, '2024-08-12', 'Youtube Subscription')",
      "INSERT INTO transactions (user_id, category_id, amount, date, description) VALUES (8, 23, 950.00, '2024-08-25', 'Rent')",
      "INSERT INTO transactions (user_id, category_id, amount, date, description) VALUES (8, 25, 255.20, '2024-08-20', 'Utilities')",
      "INSERT INTO transactions (user_id, category_id, amount, date, description) VALUES (9, 15, 1886.05, '2024-06-01', 'Monthly salary')",
      "INSERT INTO transactions (user_id, category_id, amount, date, description) VALUES (9, 35, 950.00, '2024-07-25', 'Healthcore expense')",
      "INSERT INTO transactions (user_id, category_id, amount, date, description) VALUES (9, 30, 1535.80, '2024-07-14', 'Travel')",
      "INSERT INTO transactions (user_id, category_id, amount, date, description) VALUES (9, 29, 735.55, '2024-07-16', 'Clothing')",
    ];

    for (var transaction in transactions) {
      try {
        await TransactionsDao().insertTransactionWithQuery(transaction);
        print('Transaction added');
      } catch (e) {
        print('EROOOOOOOOOOOORR');
      }
    }
  }

  @override
  void initState() {
    super.initState();
    addtransaction();
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

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
                        Text(
                          'Hello Orçun!',
                          style:
                              Theme.of(context).textTheme.titleLarge!.copyWith(
                                    color: Colors.white,
                                  ),
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
              Padding(
                padding: EdgeInsets.symmetric(
                    horizontal: screenWidth * 0.08, vertical: 80.0),
                child: const Column(
                  children: [
                    Text('Income | Expense Buttons...'),
                  ],
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
                          onPressed: () {},
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
                        Text(
                          '3.000,00 €',
                          style:
                              Theme.of(context).textTheme.titleMedium!.copyWith(
                                    fontWeight: FontWeight.bold,
                                  ),
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
                        Text(
                          '-1.534,29 €',
                          style:
                              Theme.of(context).textTheme.titleMedium!.copyWith(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.red,
                                  ),
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
                                    fontWeight: FontWeight.bold,
                                  ),
                        ),
                        Text(
                          '+1.465,71 €',
                          style:
                              Theme.of(context).textTheme.titleMedium!.copyWith(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.green,
                                  ),
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
