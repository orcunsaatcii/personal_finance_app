import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:personal_finance_app/constants/constants.dart';
import 'package:personal_finance_app/models/category.dart';
import 'package:personal_finance_app/models/category_dao.dart';
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

  /* Future<void> addtransaction() async {
    List<Map<String, dynamic>> transactions = [
      {'Salary': 'income'},
      {'Bonus': 'income'},
      {'Rental income': 'income'},
      {'Scholarship': 'income'},
      {'Investment': 'income'},
      {'Tax refund': 'income'},
      {'Freelance': 'income'},
      {'Food': 'expense'},
      {'Rent': 'expense'},
      {'Entertainment': 'expense'},
      {'Utilities': 'expense'},
      {'Transportation': 'expense'},
      {'Education': 'expense'},
      {'Groceries': 'expense'},
      {'Clothing': 'expense'},
      {'Travel': 'expense'},
      {'Charity': 'expense'},
      {'Subscription': 'expense'},
      {'Household items': 'expense'},
      {'Personal care': 'expense'},
      {'Healthcore': 'expense'},
    ];

    for (var category in categories) {
      for (var i in category.entries) {
        try {
          await CategoryDao().insertCategory(i.key.toString(), i.value);
          print('Categories added');
        } catch (e) {
          print('EROOOOOOOOOOOORR');
        }
      }
    }
  }*/

  Future<void> addUsers() async {
    List<String> queries = [
      "INSERT INTO users (name, email, password) VALUES ('Alice', 'alice@example.com', 'password123')",
      "INSERT INTO users (name, email, password) VALUES ('Bob', 'bob@example.com', 'password456')",
      "INSERT INTO users (name, email, password) VALUES ('Charlie', 'charlie@example.com', 'password789')"
    ];

    for (var query in queries) {
      try {
        await UsersDao().insertUserQuery(query);
        print('Users added');
      } catch (e) {
        print('EROOOOOOOOOOOORR');
      }
    }
  }

  @override
  void initState() {
    super.initState();
    //addCategory();
    addUsers();
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
