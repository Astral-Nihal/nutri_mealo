import 'package:flutter/material.dart';
import 'package:nutri_mealo/pages/journal/journal_home_page.dart';
import 'package:nutri_mealo/pages/meal_plan/meal_plan_home_page.dart';
import 'package:nutri_mealo/pages/more/more_home_page.dart';
import 'package:nutri_mealo/pages/stats/stats_home_page.dart';

// Import your individual screen widgets
class MainNavigation extends StatefulWidget {
  const MainNavigation({super.key});

  @override
  State<MainNavigation> createState() => _MainNavigationState();
}

class _MainNavigationState extends State<MainNavigation> {
  int _currentIndex = 0;

  final List<Widget> _pages = const [
    JournalHomePage(),
    StatsHomePage(),
    MealPlanHomePage(),
    MealPlanHomePage(),
    MoreHomePage(),
  ];

  final Color _selectedColor = Color(0xffF93827);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_currentIndex],
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          border: Border(top: BorderSide(color: Colors.grey, width: 2)),
        ),
        child: BottomNavigationBar(
          backgroundColor: Colors.white,
          type: BottomNavigationBarType.fixed,
          currentIndex: _currentIndex,
          selectedItemColor: _selectedColor,
          unselectedItemColor: Colors.grey,
          onTap: (int index) {
            setState(() {
              _currentIndex = index;
            });
          },
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.book_outlined),
              label: 'Journal',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.insert_chart_outlined_outlined),
              label: 'Stats',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.restaurant_outlined),
              label: 'Meal Plan',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.emoji_events_outlined),
              label: 'Goals',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.more_horiz_outlined),
              label: 'More',
            ),
          ],
        ),
      ),
    );
  }
}
