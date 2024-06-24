import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:personal_finance_app/pages/home/page/home_page.dart';
import 'package:personal_finance_app/pages/profile/page/profile_page.dart';
import 'package:personal_finance_app/pages/stat/page/stat_page.dart';
import 'package:personal_finance_app/providers/bottom_navbar_provider.dart';

class PageManager extends ConsumerStatefulWidget {
  const PageManager({super.key});

  @override
  ConsumerState<PageManager> createState() => _PageManagerState();
}

class _PageManagerState extends ConsumerState<PageManager> {
  static const List<Widget> _pages = <Widget>[
    HomePage(),
    StatPage(),
    ProfilePage(),
  ];

  @override
  Widget build(BuildContext context) {
    int currentIndex = ref.watch(bottomNavbarProvider);

    return Scaffold(
      body: _pages.elementAt(currentIndex),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: currentIndex,
        iconSize: 30,
        selectedItemColor: const Color.fromARGB(255, 1, 10, 70),
        unselectedItemColor: Colors.grey,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.pie_chart),
            label: 'Stat',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
        onTap: (value) {
          ref.read(bottomNavbarProvider.notifier).changePage(value);
        },
      ),
    );
  }
}
