import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:nutri_mealo/pages/goals/view_all_badges_page.dart';

class GoalsHomePage extends StatefulWidget {
  const GoalsHomePage({super.key});

  @override
  State<GoalsHomePage> createState() => _GoalsHomePageState();
}

class _GoalsHomePageState extends State<GoalsHomePage> {
  int streak = 0;
  int coins = 0;
  int availableFreezes = 0;
  List<String> fulfilledDays = [];
  List<String> frozenDays = [];
  DateTime _focusedMonth = DateTime.now();
  List<int> unlockedBadges = [];

  @override
  void initState() {
    super.initState();
    _loadStreakData();
  }

  Future<void> _loadStreakData() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      streak = prefs.getInt('streak') ?? 0;
      coins = prefs.getInt('coins') ?? 0;
      fulfilledDays = prefs.getStringList('fulfilledDays') ?? [];
      frozenDays = prefs.getStringList('frozenDays') ?? [];
      availableFreezes = prefs.getInt('availableFreezes') ?? 0;
    });

    if (streak >= 7) unlockedBadges.add(7);
    if (streak >= 14) unlockedBadges.add(14);
    if (streak >= 21) unlockedBadges.add(21);
  }

  Future<void> _saveStreakData() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('streak', streak);
    await prefs.setInt('coins', coins);
    await prefs.setStringList('fulfilledDays', fulfilledDays);
    await prefs.setStringList('frozenDays', frozenDays);
    await prefs.setInt('availableFreezes', availableFreezes);
  }

  bool _isDayFulfilled(DateTime day) {
    final formatted = DateFormat('yyyy-MM-dd').format(day);
    return fulfilledDays.contains(formatted);
  }

  bool _isDayFrozen(DateTime day) {
    final formatted = DateFormat('yyyy-MM-dd').format(day);
    return frozenDays.contains(formatted);
  }

  void _changeMonth(int offset) {
    setState(() {
      _focusedMonth = DateTime(
        _focusedMonth.year,
        _focusedMonth.month + offset,
        1,
      );
    });
  }

  Future<void> _buyStreakFreeze() async {
    if (coins >= 200 && availableFreezes < 3) {
      setState(() {
        coins -= 200;
        availableFreezes++;
      });
      await _saveStreakData();
    }
  }

  Future<void> _enableStreakFreeze() async {
    final yesterday = DateTime.now().subtract(const Duration(days: 1));
    final yesterdayStr = DateFormat('yyyy-MM-dd').format(yesterday);

    if (!fulfilledDays.contains(yesterdayStr) &&
        !frozenDays.contains(yesterdayStr) &&
        availableFreezes > 0) {
      setState(() {
        frozenDays.add(yesterdayStr);
        availableFreezes--;
      });
      await _saveStreakData();

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Streak freeze applied for yesterday!'),
          backgroundColor: Colors.blueAccent,
        ),
      );
    } else {
      String reason;
      if (fulfilledDays.contains(yesterdayStr)) {
        reason = "You already fulfilled your quota yesterday!";
      } else if (frozenDays.contains(yesterdayStr)) {
        reason = "You already used freeze on yesterday!";
      } else if (availableFreezes <= 0) {
        reason = "No available freezes left!";
      } else {
        reason = "You can't freeze today. Try tomorrow!";
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(reason), backgroundColor: Colors.black),
      );
    }
  }

  List<Widget> _buildCalendar(DateTime month) {
    final firstDayOfMonth = DateTime(month.year, month.month, 1);
    final daysInMonth = DateTime(month.year, month.month + 1, 0).day;
    final startingWeekday = firstDayOfMonth.weekday;
    final List<Widget> rows = [];

    int dayCounter = 1;
    for (int week = 0; week < 6; week++) {
      List<Widget> row = [];
      for (int weekday = 1; weekday <= 7; weekday++) {
        if ((week == 0 && weekday < startingWeekday) ||
            dayCounter > daysInMonth) {
          row.add(Expanded(child: Container()));
        } else {
          final currentDate = DateTime(month.year, month.month, dayCounter);
          final isFulfilled = _isDayFulfilled(currentDate);
          final isFrozen = _isDayFrozen(currentDate);

          Color bgColor = Colors.transparent;
          if (isFulfilled) {
            bgColor = const Color(0xff16C47F); // green
          } else if (isFrozen) {
            bgColor = Colors.blueAccent; // blue for frozen
          }

          row.add(
            Expanded(
              child: Container(
                margin: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: bgColor,
                  borderRadius: BorderRadius.circular(8),
                ),
                padding: const EdgeInsets.symmetric(vertical: 10),
                child: Center(
                  child: Text(
                    "$dayCounter",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color:
                          isFulfilled || isFrozen ? Colors.white : Colors.black,
                    ),
                  ),
                ),
              ),
            ),
          );
          dayCounter++;
        }
      }
      rows.add(Row(children: row));
    }

    return rows;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: commonAppBar(),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _rewardInfoBox(Icons.attach_money, 'Coins', coins.toString()),
                const SizedBox(width: 20),
                _rewardInfoBox(
                  Icons.local_fire_department,
                  'Streak',
                  streak.toString(),
                ),
              ],
            ),
            const SizedBox(height: 20),

            // Calendar
            Container(
              decoration: BoxDecoration(
                color: Colors.grey.shade100,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.black),
              ),
              padding: const EdgeInsets.all(12),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.chevron_left),
                        onPressed: () => _changeMonth(-1),
                      ),
                      Text(
                        DateFormat('MMMM yyyy').format(_focusedMonth),
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.chevron_right),
                        onPressed: () => _changeMonth(1),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children:
                        ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'].map((
                          day,
                        ) {
                          return Expanded(
                            child: Center(
                              child: Text(
                                day,
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14,
                                ),
                              ),
                            ),
                          );
                        }).toList(),
                  ),
                  const SizedBox(height: 8),
                  ..._buildCalendar(_focusedMonth),
                ],
              ),
            ),

            const SizedBox(height: 10),
            // Badges Section
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Badges',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => ViewAllBadgesPage()),
                    );
                  },
                  child: const Text(
                    'VIEW ALL',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Color(0xff16C47F),
                    ),
                  ),
                ),
              ],
            ),
            Container(
              height: 120,
              padding: const EdgeInsets.symmetric(horizontal: 12),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.black),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _buildBadgeItem("7", unlocked: unlockedBadges.contains(7)),
                  VerticalDivider(),
                  _buildBadgeItem("14", unlocked: unlockedBadges.contains(14)),
                  VerticalDivider(),
                  _buildBadgeItem("21", unlocked: unlockedBadges.contains(21)),
                ],
              ),
            ),

            const SizedBox(height: 15),
            const Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Streak Freeze',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(height: 8),
            freezeStreakWidget(),
          ],
        ),
      ),
    );
  }

  Widget freezeStreakWidget() {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.black),
        borderRadius: BorderRadius.circular(12),
        color: Colors.white,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Icon(Icons.ac_unit, color: Colors.cyan, size: 48),
              const SizedBox(width: 10),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '$availableFreezes/3 Streak Freeze',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  const Text(
                    '(per month)',
                    style: TextStyle(fontSize: 12, color: Colors.grey),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: const [
                      Text('Buy 1 freeze ', style: TextStyle(fontSize: 14)),
                      SizedBox(width: 15),
                      Text(
                        '200',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.amber,
                        ),
                      ),
                      Icon(Icons.monetization_on, color: Colors.amber),
                    ],
                  ),
                ],
              ),
            ],
          ),
          Column(
            children: [
              ElevatedButton(
                onPressed: availableFreezes > 0 ? _enableStreakFreeze : null,
                style: ElevatedButton.styleFrom(backgroundColor: Colors.cyan),
                child: const Text(
                  'Enable',
                  style: TextStyle(color: Colors.white),
                ),
              ),
              const SizedBox(height: 8),
              ElevatedButton(
                onPressed:
                    coins >= 200 && availableFreezes < 3
                        ? _buyStreakFreeze
                        : null,
                style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
                child: const Text('Buy', style: TextStyle(color: Colors.white)),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildBadgeItem(String label, {bool unlocked = false}) {
    String imagePath;
    switch (label) {
      case "7":
        imagePath = 'assets/badge/7_days_badge.png';
        break;
      case "14":
        imagePath = 'assets/badge/14_days_badge.png';
        break;
      case "21":
        imagePath = 'assets/badge/21_days_badge.png';
        break;
      default:
        imagePath = 'assets/badge/1.png';
    }

    return SizedBox(
      width: 120,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Stack(
              alignment: Alignment.center,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: ColorFiltered(
                    colorFilter:
                        unlocked
                            ? const ColorFilter.mode(
                              Colors.transparent,
                              BlendMode.multiply,
                            )
                            : const ColorFilter.mode(
                              Colors.grey,
                              BlendMode.saturation,
                            ),
                    child: Image.asset(
                      imagePath,
                      height: 80,
                      width: 80,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return const Icon(
                          Icons.error,
                          size: 80,
                          color: Colors.red,
                        );
                      },
                    ),
                  ),
                ),
                if (!unlocked)
                  Positioned(
                    top: 0,
                    right: 0,
                    child: Icon(
                      Icons.lock,
                      color: Colors.black.withOpacity(0.6),
                      size: 24,
                    ),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _rewardInfoBox(IconData icon, String label, String value) {
    return Container(
      width: 130,
      height: 80,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.grey.shade200,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.black54),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: Colors.black, size: 26),
          const SizedBox(height: 4),
          Text(
            '$label: $value',
            style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
          ),
        ],
      ),
    );
  }

  AppBar commonAppBar() {
    return AppBar(
      automaticallyImplyLeading: false,
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
