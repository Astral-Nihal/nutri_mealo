import 'package:flutter/material.dart';

class MealPlanHomePage extends StatefulWidget {
  const MealPlanHomePage({super.key});

  @override
  State<MealPlanHomePage> createState() => _MealPlanHomePageState();
}

class _MealPlanHomePageState extends State<MealPlanHomePage> {
  final List<String> days = [
    'Monday',
    'Tuesday',
    'Wednesday',
    'Thursday',
    'Friday',
    'Saturday',
    'Sunday',
  ];

  final Map<String, List<String>> mealDetails = {
    'Monday': [
      'Breakfast - Idly with Sambar',
      'Morning Snack - Chickpeas',
      'Lunch - Mutton Biryani',
      'Evening Snack - Chicken Momo',
      'Dinner - Chappathi with Paneer Butter Masala',
    ],
    'Tuesday': [
      'Breakfast - Dosa with Chutney',
      'Morning Snack - Banana',
      'Lunch - Veg Fried Rice',
      'Evening Snack - Boiled Corn',
      'Dinner - Roti with Mixed Veg Curry',
    ],
    'Wednesday': [
      'Breakfast - Poha',
      'Morning Snack - Apple',
      'Lunch - Lemon Rice with Papad',
      'Evening Snack - Samosa',
      'Dinner - Pulao with Raita',
    ],
    'Thursday': [
      'Breakfast - Upma',
      'Morning Snack - Sprouts',
      'Lunch - Fish Curry with Rice',
      'Evening Snack - Roasted Makhana',
      'Dinner - Paratha with Curd',
    ],
    'Friday': [
      'Breakfast - Aloo Paratha',
      'Morning Snack - Orange',
      'Lunch - Rajma Chawal',
      'Evening Snack - Bhel Puri',
      'Dinner - Dhokla & Chutney',
    ],
    'Saturday': [
      'Breakfast - Pancakes',
      'Morning Snack - Yogurt',
      'Lunch - Paneer Butter Masala with Naan',
      'Evening Snack - Popcorn',
      'Dinner - Vegetable Sandwich',
    ],
    'Sunday': [
      'Breakfast - Poori with Masala',
      'Morning Snack - Grapes',
      'Lunch - Chicken Biryani',
      'Evening Snack - French Fries',
      'Dinner - Egg Curry with Rice',
    ],
  };

  late List<bool> _isExpanded;

  @override
  void initState() {
    super.initState();
    _isExpanded = List.generate(days.length, (_) => false);
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
              'Meal Plan',
              style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
            ),
          ),
          const SizedBox(height: 6),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Text(
              'This meal plan is for the week of ${getCurrentWeekRange()}',
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
        'Nutri-Mealo',
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
    final meals = mealDetails[day] ?? [];

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
            child: ElevatedButton.icon(
              onPressed: () {
                // Navigate to recipe page later
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text("Navigate to recipe page"),
                    duration: Duration(milliseconds: 800),
                  ),
                );
              },
              icon: const Icon(Icons.receipt_long_outlined),
              label: const Text("View Recipes"),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.teal,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
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

  String getCurrentWeekRange() {
    DateTime now = DateTime.now();
    DateTime startOfWeek = now.subtract(Duration(days: now.weekday - 1));
    DateTime endOfWeek = startOfWeek.add(const Duration(days: 6));

    String formatDate(DateTime date) {
      return "${_monthName(date.month)} ${date.day}";
    }

    return "${formatDate(startOfWeek)} - ${formatDate(endOfWeek)}";
  }

  String _monthName(int month) {
    const monthNames = [
      '',
      'January',
      'February',
      'March',
      'April',
      'May',
      'June',
      'July',
      'August',
      'September',
      'October',
      'November',
      'December',
    ];
    return monthNames[month];
  }
}
