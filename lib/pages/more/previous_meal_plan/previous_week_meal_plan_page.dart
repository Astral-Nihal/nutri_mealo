import 'dart:math';
import 'package:flutter/material.dart';
import 'package:nutri_mealo/pages/more/recipes/recipes_page.dart';

class PreviousWeekMealPlanPage extends StatefulWidget {
  final int weekNumber;
  final String weekRange;

  const PreviousWeekMealPlanPage({
    super.key,
    required this.weekNumber,
    required this.weekRange,
  });

  @override
  State<PreviousWeekMealPlanPage> createState() =>
      _PreviousWeekMealPlanPageState();
}

class _PreviousWeekMealPlanPageState extends State<PreviousWeekMealPlanPage> {
  final List<String> days = [
    'Monday',
    'Tuesday',
    'Wednesday',
    'Thursday',
    'Friday',
    'Saturday',
    'Sunday',
  ];

  final List<String> mealTypes = [
    'Breakfast',
    'Morning Snack',
    'Lunch',
    'Evening Snack',
    'Dinner',
  ];

  final List<String> allDishes = [
    'Idly with Sambar',
    'Dosa with Chutney',
    'Poha',
    'Upma',
    'Aloo Paratha',
    'Pancakes',
    'Poori with Masala',
    'Banana',
    'Chickpeas',
    'Apple',
    'Sprouts',
    'Orange',
    'Yogurt',
    'Grapes',
    'Mutton Biryani',
    'Veg Fried Rice',
    'Lemon Rice with Papad',
    'Fish Curry with Rice',
    'Rajma Chawal',
    'Paneer Butter Masala with Naan',
    'Chicken Biryani',
    'Chicken Momo',
    'Boiled Corn',
    'Samosa',
    'Roasted Makhana',
    'Bhel Puri',
    'Popcorn',
    'French Fries',
    'Roti with Mixed Veg Curry',
    'Chappathi with Paneer Masala',
    'Egg Curry with Rice',
    'Vegetable Sandwich',
    'Dhokla & Chutney',
    'Paratha with Curd',
    'Pulao with Raita',
    'Dal Tadka & Rice',
    'Veg Wrap',
    'Fried Rice',
    'Oats with Milk',
    'Cornflakes with Fruits',
  ];

  late Map<String, List<String>> generatedMeals;
  late List<bool> _isExpanded;

  @override
  void initState() {
    super.initState();
    _isExpanded = List.generate(days.length, (_) => false);
    generatedMeals = _generateWeeklyMealPlan();
  }

  Map<String, List<String>> _generateWeeklyMealPlan() {
    final random = Random(widget.weekNumber); // Use weekNumber as seed
    final Map<String, List<String>> weekMeals = {};
    Set<String> previousDayMeals = {};

    for (String day in days) {
      Set<String> currentDayMeals = {};
      while (currentDayMeals.length < 5) {
        String dish = allDishes[random.nextInt(allDishes.length)];
        if (!currentDayMeals.contains(dish) &&
            !previousDayMeals.contains(dish)) {
          currentDayMeals.add(dish);
        }
      }

      List<String> meals = [];
      for (int i = 0; i < 5; i++) {
        meals.add('${mealTypes[i]} - ${currentDayMeals.elementAt(i)}');
      }

      weekMeals[day] = meals;
      previousDayMeals = currentDayMeals;
    }

    return weekMeals;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: commonAppBar(),
      body: ListView(
        padding: const EdgeInsets.symmetric(vertical: 16),
        children: [
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: Text(
              'Previous Meal Plan',
              style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
            ),
          ),
          const SizedBox(height: 6),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Text(
              'Week ${widget.weekNumber} (${widget.weekRange})',
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Colors.black87,
              ),
            ),
          ),
          const SizedBox(height: 10),
          ...List.generate(days.length, (index) {
            final day = days[index];
            return _buildExpandableCard(
              index: index,
              title: day,
              child: _buildMealDetails(day),
            );
          }),
        ],
      ),
    );
  }

  AppBar commonAppBar() {
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 0,
      title: const Text(
        'Nutri-mealo',
        style: TextStyle(
          color: Color(0xff16C47F),
          fontSize: 32,
          fontWeight: FontWeight.bold,
        ),
      ),
      centerTitle: true,
    );
  }

  Widget _buildMealDetails(String day) {
    final meals = generatedMeals[day] ?? [];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ...meals.map(
          (meal) => Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
            child: Text(
              meal,
              style: const TextStyle(
                fontSize: 16,
                fontStyle: FontStyle.italic,
                color: Colors.black87,
              ),
            ),
          ),
        ),
        const SizedBox(height: 12),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: Align(
            alignment: Alignment.centerRight,
            child: IconButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const RecipesPage()),
                );
              },
              icon: const Icon(Icons.menu_book, color: Colors.black),
              style: IconButton.styleFrom(
                backgroundColor: const Color(0xff16C47F),
                padding: const EdgeInsets.all(8),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
          ),
        ),
        const SizedBox(height: 10),
      ],
    );
  }

  Widget _buildExpandableCard({
    required int index,
    required String title,
    required Widget child,
  }) {
    final isOpen = _isExpanded[index];

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: const BorderSide(color: Colors.black54),
        ),
        color: Colors.grey.shade200,
        child: Column(
          children: [
            GestureDetector(
              onTap: () {
                setState(() {
                  for (int i = 0; i < _isExpanded.length; i++) {
                    _isExpanded[i] = i == index ? !_isExpanded[i] : false;
                  }
                });
              },
              child: Column(
                children: [
                  ListTile(
                    leading: const Icon(Icons.calendar_month_rounded),
                    title: Text(
                      title,
                      style: const TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 16,
                      ),
                    ),
                    trailing: AnimatedRotation(
                      turns: isOpen ? 0.5 : 0,
                      duration: const Duration(milliseconds: 200),
                      child: const Icon(Icons.keyboard_arrow_down_outlined),
                    ),
                  ),
                  if (isOpen)
                    Container(
                      height: 1,
                      width: double.infinity,
                      color: Colors.black38,
                      margin: const EdgeInsets.symmetric(horizontal: 16),
                    ),
                ],
              ),
            ),
            AnimatedSize(
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeInOut,
              child: ClipRect(
                child:
                    isOpen
                        ? Padding(
                          padding: const EdgeInsets.only(top: 12),
                          child: child,
                        )
                        : const SizedBox.shrink(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
