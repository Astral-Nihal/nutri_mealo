import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:nutri_mealo/pages/more/recipes/recipes_page.dart';
import 'package:nutri_mealo/pages/profile/profile_home_page.dart';
import 'package:shared_preferences/shared_preferences.dart';

class JournalHomePage extends StatefulWidget {
  const JournalHomePage({super.key});

  @override
  State<JournalHomePage> createState() => _JournalHomePageState();
}

class Meal {
  final String name;
  final String sideDishes;
  final String proteinInfo;
  final String imagePath;

  Meal({
    required this.name,
    required this.sideDishes,
    required this.proteinInfo,
    required this.imagePath,
  });
}

class _JournalHomePageState extends State<JournalHomePage> {
  Future<void> _saveAteStatusForDate(DateTime date) async {
    final prefs = await SharedPreferences.getInstance();
    final key = 'ateStatus_${DateFormat('yyyy-MM-dd').format(date)}';

    Map<String, String> stringMap = {};
    ateStatus.forEach((keyMeal, value) {
      if (value != null) stringMap[keyMeal] = value;
    });

    await prefs.setString(key, stringMap.toString());
  }

  Future<void> _loadAteStatusForDate(DateTime date) async {
    final prefs = await SharedPreferences.getInstance();
    final key = 'ateStatus_${DateFormat('yyyy-MM-dd').format(date)}';
    final stored = prefs.getString(key);

    Map<String, String?> result = {};
    if (stored != null && stored.contains(':')) {
      stored.replaceAll(RegExp(r'[{}]'), '').split(',').forEach((entry) {
        final pair = entry.split(':');
        if (pair.length == 2) {
          result[pair[0].trim()] = pair[1].trim();
        }
      });
    }

    setState(() {
      ateStatus = result;
    });
  }

  Set<String> fulfilledDates = {};

  int userCoins = 0;
  bool rewardGivenToday = false;

  @override
  void initState() {
    super.initState();
    _loadUserCoins();
    _loadFulfilledDates();
    _loadAteStatusForDate(_selectedDate); // <- Load protein data
  }

  void _loadFulfilledDates() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      fulfilledDates = prefs.getStringList('fulfilledDates')?.toSet() ?? {};
    });
  }

  Future<void> _markTodayAsFulfilled() async {
    final today = DateTime.now();
    final formattedDate = DateFormat('yyyy-MM-dd').format(today);

    final prefs = await SharedPreferences.getInstance();
    List<String> fulfilledDates = prefs.getStringList('fulfilledDays') ?? [];

    if (!fulfilledDates.contains(formattedDate)) {
      fulfilledDates.add(formattedDate);
      await prefs.setStringList('fulfilledDays', fulfilledDates);

      // Add coins
      int coins = prefs.getInt('coins') ?? 0;
      await prefs.setInt('coins', coins + 10);

      // Increase streak
      int streak = prefs.getInt('streak') ?? 0;
      await prefs.setInt('streak', streak + 1);
    }
  }

  void _checkIfDayIsFulfilled() {
    bool allMealsAte = dailyMeals.keys.every(
      (mealTitle) => ateStatus[mealTitle] == 'yes',
    );
    if (allMealsAte) {
      _markTodayAsFulfilled();
      _checkAllMealsReward(); // if you have coins & streak updates
    }
  }

  void _loadUserCoins() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      userCoins = prefs.getInt('userCoins') ?? 0;
    });
  }

  void _checkAllMealsReward() async {
    bool allMarkedYes = dailyMeals.keys.every(
      (mealTitle) => ateStatus[mealTitle] == 'yes',
    );

    if (allMarkedYes && !rewardGivenToday) {
      final prefs = await SharedPreferences.getInstance();
      int currentCoins = prefs.getInt('userCoins') ?? 0;

      int rewardAmount = 10;
      int updatedCoins = currentCoins + rewardAmount;

      await prefs.setInt('userCoins', updatedCoins);

      setState(() {
        userCoins = updatedCoins;
        rewardGivenToday = true;
      });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              "🎉 You earned $rewardAmount coins for eating all meals!",
            ),
            // backgroundColor: Colors.green,
          ),
        );
      }
    }
  }

  double getProteinPercentage() {
    double totalProtein = 0.0;
    double maxPossibleProtein = 0.0;

    dailyMeals.forEach((mealTitle, meal) {
      final match = RegExp(r'([\d.]+)').firstMatch(meal.proteinInfo);
      if (match != null) {
        double protein = double.parse(match.group(1)!);
        if (ateStatus[mealTitle] == 'yes') {
          totalProtein += protein;
        }
        maxPossibleProtein += protein;
      }
    });

    return (totalProtein / maxPossibleProtein).clamp(0.0, 1.0);
  }

  Color getProgressColor(double percentage) {
    if (percentage < 0.4) return Colors.red;
    if (percentage < 0.7) return Colors.amber;
    return Colors.green;
  }

  Map<String, String?> ateStatus = {}; // value can be 'yes', 'no', or null

  Map<String, bool> likedMeals = {};
  Map<String, bool> dislikedMeals = {};

  final Map<String, Meal> dailyMeals = {
    'Breakfast': Meal(
      name: 'Idly',
      sideDishes: 'Sambar\nCoconut Chutney',
      proteinInfo: '11.2 gm (per 100g)',
      imagePath: 'assets/images/idly_sample.png',
    ),
    'Morning Snack': Meal(
      name: 'Banana',
      sideDishes: '—',
      proteinInfo: '1.1 gm (per 100g)',
      imagePath: 'assets/images/banana.jpg',
    ),
    'Lunch': Meal(
      name: 'Rice & Dal',
      sideDishes: 'Curd\nPapad',
      proteinInfo: '6.2 gm (per 100g)',
      imagePath: 'assets/images/lunch.jpg',
    ),
    'Evening Snack': Meal(
      name: 'Sundal',
      sideDishes: 'Tea',
      proteinInfo: '8.0 gm (per 100g)',
      imagePath: 'assets/images/sundal.jpg',
    ),
    'Dinner': Meal(
      name: 'Chapati',
      sideDishes: 'Vegetable Kurma',
      proteinInfo: '9.0 gm (per 100g)',
      imagePath: 'assets/images/chapati.jpg',
    ),
  };

  DateTime _selectedDate = DateTime.now();

  bool _isToday(DateTime date) {
    final now = DateTime.now();
    return now.year == date.year &&
        now.month == date.month &&
        now.day == date.day;
  }

  String _getWeekday(DateTime date) {
    const weekdays = [
      'Monday',
      'Tuesday',
      'Wednesday',
      'Thursday',
      'Friday',
      'Saturday',
      'Sunday',
    ];
    return weekdays[date.weekday - 1];
  }

  @override
  Widget build(BuildContext context) {
    final proteinPercent = getProteinPercentage();

    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: commonAppBar(),
        body: Column(
          children: [
            const SizedBox(height: 10),
            menuBarField(context),
            const SizedBox(height: 20),
            weeklyDateCards(),
            const SizedBox(height: 40),
            Expanded(
              child: ListView(
                children: [
                  mealCard(icon: Icons.breakfast_dining, title: 'Breakfast'),
                  const SizedBox(height: 10),
                  mealCard(icon: Icons.local_cafe, title: 'Morning Snack'),
                  const SizedBox(height: 10),
                  mealCard(icon: Icons.lunch_dining, title: 'Lunch'),
                  const SizedBox(height: 10),
                  mealCard(icon: Icons.local_pizza, title: 'Evening Snack'),
                  const SizedBox(height: 10),
                  mealCard(icon: Icons.room_service, title: 'Dinner'),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Daily Protein Intake",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                  const SizedBox(height: 8),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: LinearProgressIndicator(
                      value: proteinPercent,
                      minHeight: 16,
                      valueColor: AlwaysStoppedAnimation<Color>(
                        getProgressColor(proteinPercent),
                      ),
                      backgroundColor: Colors.grey.shade300,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    "${(proteinPercent * 100).toStringAsFixed(1)}% of daily protein goal",
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 14,
                      color: getProgressColor(proteinPercent),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget mealCard({required IconData icon, required String title}) {
    final meal = dailyMeals[title];

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: const BorderSide(color: Colors.black54),
        ),
        color: Colors.grey.shade200,
        child: ListTile(
          leading: Icon(icon, size: 30),
          title: Text(
            title,
            style: const TextStyle(fontWeight: FontWeight.w600),
          ),
          trailing: IconButton(
            icon: const Icon(Icons.keyboard_arrow_right_outlined),
            onPressed: () {
              if (meal != null) {
                _showMealPopup(context, title, meal);
              }
            },
          ),
        ),
      ),
    );
  }

  Widget weeklyDateCards() {
    final screenWidth = MediaQuery.of(context).size.width;
    final startOfWeek = _selectedDate.subtract(
      Duration(days: _selectedDate.weekday - 1),
    ); // Monday
    final weekDates = List.generate(
      7,
      (index) => startOfWeek.add(Duration(days: index)),
    );

    final cardSpacing = 4.0;
    final totalSpacing = cardSpacing * (weekDates.length - 1);
    final horizontalPadding = 24.0; // 12 left + 12 right
    final cardWidth = (screenWidth - horizontalPadding - totalSpacing) / 7;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: SizedBox(
        height: 80,
        child: Row(
          children: List.generate(weekDates.length, (index) {
            final date = weekDates[index];
            final isSelected =
                date.year == _selectedDate.year &&
                date.month == _selectedDate.month &&
                date.day == _selectedDate.day;

            return Padding(
              padding: EdgeInsets.only(
                right: index != weekDates.length - 1 ? cardSpacing : 0,
              ),
              child: GestureDetector(
                onTap: () {
                  setState(() {
                    _selectedDate = date;
                  });
                  _loadAteStatusForDate(date);
                },
                child: Container(
                  width: cardWidth,
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  decoration: BoxDecoration(
                    color:
                        isSelected
                            ? const Color(0xff16C47F)
                            : Colors.grey.shade200,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.black54),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        DateFormat('MMM').format(date).toUpperCase(),
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        date.day.toString(),
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        DateFormat('E').format(date),
                        style: const TextStyle(fontSize: 12),
                      ),
                    ],
                  ),
                ),
              ),
            );
          }),
        ),
      ),
    );
  }

  Padding menuBarField(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12.0),
      child: Row(
        children: [
          // 📅 Date Picker Button
          _circularIconButton(
            icon: Icons.date_range,
            onTap: () async {
              DateTime? picked = await showDatePicker(
                context: context,
                initialDate: _selectedDate,
                firstDate: DateTime(1900),
                lastDate: DateTime.now(),
              );
              if (picked != null) {
                setState(() {
                  _selectedDate = picked;
                });
              }
            },
          ),

          const SizedBox(width: 8),

          // ◀️ Left Arrow
          _circularIconButton(
            icon: Icons.keyboard_arrow_left_outlined,
            onTap: () {
              setState(() {
                _selectedDate = _selectedDate.subtract(const Duration(days: 1));
              });
            },
          ),

          // 📅 Center Calendar Info
          Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.calendar_today, color: Colors.grey, size: 20),
                const SizedBox(width: 8),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "${_selectedDate.day}/${_selectedDate.month}/${_selectedDate.year}",
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    Text(
                      _isToday(_selectedDate)
                          ? 'Today'
                          : _getWeekday(_selectedDate),
                      style: const TextStyle(
                        fontSize: 12,
                        color: Colors.grey,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          // ▶️ Right Arrow
          _circularIconButton(
            icon: Icons.keyboard_arrow_right_outlined,
            onTap:
                _isTodayOrAfter(_selectedDate)
                    ? null
                    : () {
                      setState(() {
                        _selectedDate = _selectedDate.add(
                          const Duration(days: 1),
                        );
                      });
                    },
            disabled: _isTodayOrAfter(_selectedDate),
          ),

          const SizedBox(width: 8),

          // 👤 Profile Icon
          _circularIconButton(
            icon: Icons.account_circle,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => ProfileHomePage()),
              );
            },
            iconSize: 30,
          ),
        ],
      ),
    );
  }

  Widget _circularIconButton({
    required IconData icon,
    required VoidCallback? onTap,
    double iconSize = 24,
    bool disabled = false,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4.0),
      child: Material(
        color: disabled ? Colors.grey[300] : Colors.grey[200],
        shape: const CircleBorder(),
        child: InkWell(
          onTap: disabled ? null : onTap,
          customBorder: const CircleBorder(),
          splashColor: Colors.grey.withOpacity(0.3),
          child: Container(
            padding: const EdgeInsets.all(12.0),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: Colors.black54,
              ), // <-- Added border here
            ),
            child: Icon(
              icon,
              size: iconSize,
              color: disabled ? Colors.grey : Colors.black,
            ),
          ),
        ),
      ),
    );
  }

  bool _isTodayOrAfter(DateTime date) {
    final now = DateTime.now();
    return date.year > now.year ||
        (date.year == now.year && date.month > now.month) ||
        (date.year == now.year &&
            date.month == now.month &&
            date.day >= now.day);
  }

  void _showMealPopup(BuildContext context, String title, Meal meal) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setStateDialog) {
            return Dialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Close button
                  Align(
                    alignment: Alignment.topRight,
                    child: IconButton(
                      icon: const Icon(Icons.close),
                      onPressed: () => Navigator.of(context).pop(),
                    ),
                  ),
                  // Meal Image
                  ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Image.asset(
                      meal.imagePath,
                      width: 300,
                      fit: BoxFit.cover,
                    ),
                  ),
                  const SizedBox(height: 8),
                  // Meal info
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Text(
                                "Dish Name  •  ${meal.name}",
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            IconButton(
                              icon: const Icon(
                                Icons.menu_book,
                                color: Colors.black,
                              ),
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => RecipesPage(),
                                  ),
                                );
                              },
                              style: IconButton.styleFrom(
                                backgroundColor: const Color(0xff16C47F),
                                padding: const EdgeInsets.all(8),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 6),
                        Text.rich(
                          TextSpan(
                            text: "Side Dish: ",
                            style: const TextStyle(fontWeight: FontWeight.bold),
                            children: [
                              TextSpan(
                                text: meal.sideDishes,
                                style: const TextStyle(
                                  fontWeight: FontWeight.normal,
                                  color: Colors.teal,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text.rich(
                          TextSpan(
                            text: "Protein Amount: ",
                            style: const TextStyle(fontWeight: FontWeight.bold),
                            children: [
                              TextSpan(
                                text: meal.proteinInfo,
                                style: const TextStyle(color: Colors.teal),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 12),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            // 👍👎 Buttons
                            Row(
                              children: [
                                IconButton(
                                  icon: Icon(
                                    likedMeals[title] == true
                                        ? Icons.thumb_up
                                        : Icons.thumb_up_outlined,
                                    color: Colors.green,
                                  ),
                                  onPressed: () {
                                    final isLikedNow =
                                        !(likedMeals[title] ?? false);

                                    setState(() {
                                      likedMeals[title] = isLikedNow;
                                      if (isLikedNow) {
                                        dislikedMeals[title] = false;
                                      }
                                    });

                                    setStateDialog(() {});

                                    if (isLikedNow) {
                                      // Only show the favorites dialog if user just liked the meal
                                      _showFavoriteConfirmation(
                                        context,
                                        meal.name,
                                      );
                                    }
                                  },
                                ),

                                const SizedBox(width: 10),
                                IconButton(
                                  icon: Icon(
                                    dislikedMeals[title] == true
                                        ? Icons.thumb_down
                                        : Icons.thumb_down_outlined,
                                    color: Colors.red,
                                  ),
                                  onPressed: () {
                                    setState(() {
                                      dislikedMeals[title] =
                                          !(dislikedMeals[title] ?? false);
                                      if (dislikedMeals[title] == true) {
                                        likedMeals[title] = false;
                                      }
                                    });
                                    setStateDialog(() {});
                                  },
                                ),
                              ],
                            ),
                            // 🍽️ Ate? Buttons
                            Column(
                              children: [
                                const Text(
                                  'Ate?',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Row(
                                  children: [
                                    // ✅ YES BUTTON
                                    Opacity(
                                      opacity:
                                          (ateStatus[title] == null ||
                                                  ateStatus[title] == 'yes')
                                              ? 1.0
                                              : 0.4,
                                      child: ElevatedButton(
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: Colors.green,
                                        ),
                                        onPressed: () {
                                          setState(() {
                                            ateStatus[title] = 'yes';
                                            _saveAteStatusForDate(
                                              _selectedDate,
                                            );
                                          });
                                          setStateDialog(() {});
                                          _checkIfDayIsFulfilled();
                                        },
                                        child: const Text(
                                          "Yes",
                                          style: TextStyle(color: Colors.white),
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: 10),

                                    // ❌ NO BUTTON
                                    Opacity(
                                      opacity:
                                          (ateStatus[title] == null ||
                                                  ateStatus[title] == 'no')
                                              ? 1.0
                                              : 0.4,
                                      child: ElevatedButton(
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: Colors.orange,
                                        ),
                                        onPressed: () {
                                          setState(() {
                                            ateStatus[title] = 'no';
                                            _saveAteStatusForDate(
                                              _selectedDate,
                                            );
                                          });
                                          setStateDialog(() {});
                                        },
                                        child: const Text(
                                          "No",
                                          style: TextStyle(color: Colors.white),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  void _showFavoriteConfirmation(BuildContext context, String mealName) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: const Text("Add to Favorites?"),
          content: Text(
            "Would you like to add \"$mealName\" to your favorites?",
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                // You can handle "No" here if needed
              },
              child: const Text("No"),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop(); // close this popup
                // TODO: Add logic to mark as favorite here
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text("\"$mealName\" added to favorites!"),
                    duration: const Duration(seconds: 2),
                  ),
                );
              },
              child: const Text("Yes"),
            ),
          ],
        );
      },
    );
  }

  AppBar commonAppBar() {
    return AppBar(
      backgroundColor: Colors.white,
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
}
