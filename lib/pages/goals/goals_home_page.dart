import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

class GoalsHomePage extends StatefulWidget {
  const GoalsHomePage({super.key});

  @override
  State<GoalsHomePage> createState() => _GoalsHomePageState();
}

class _GoalsHomePageState extends State<GoalsHomePage> {
  int streak = 0;
  int coins = 0;
  List<String> fulfilledDays = [];
  DateTime _focusedMonth = DateTime.now();

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
    });
  }

  bool _isDayFulfilled(DateTime day) {
    final formatted = DateFormat('yyyy-MM-dd').format(day);
    return fulfilledDays.contains(formatted);
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

          row.add(
            Expanded(
              child: Container(
                margin: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color:
                      isFulfilled
                          ? const Color(0xff16C47F)
                          : Colors.transparent,
                  borderRadius: BorderRadius.circular(8),
                ),
                padding: const EdgeInsets.symmetric(vertical: 10),
                child: Center(
                  child: Text(
                    "$dayCounter",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: isFulfilled ? Colors.white : Colors.black,
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

  Widget _buildBadgeItem(String label, {bool unlocked = false}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: unlocked ? const Color(0xff16C47F) : Colors.grey.shade400,
        borderRadius: BorderRadius.circular(30),
        boxShadow: [
          if (unlocked)
            const BoxShadow(
              color: Colors.black26,
              blurRadius: 4,
              offset: Offset(2, 3),
            ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.emoji_events,
            color: unlocked ? Colors.white : Colors.black38,
            size: 30,
          ),
          const SizedBox(height: 4),
          Text(
            "$label Days",
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: unlocked ? Colors.white : Colors.black,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: commonAppBar(),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Coins and Streak Row
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

            // Calendar Container
            Container(
              decoration: BoxDecoration(
                color: Colors.grey.shade100,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.black26),
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
                  // ⬇️ Insert here
                  Row(
                    children: [
                      for (var day in [
                        'Mon',
                        'Tue',
                        'Wed',
                        'Thu',
                        'Fri',
                        'Sat',
                        'Sun',
                      ])
                        Expanded(
                          child: Center(
                            child: Text(
                              day,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 14,
                              ),
                            ),
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  ..._buildCalendar(_focusedMonth),
                ],
              ),
            ),

            const SizedBox(height: 28),

            // Badges section
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header row
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Badges',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        // Navigate to view all
                      },
                      child: const Text(
                        'VIEW ALL',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: Colors.teal,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _buildBadgeItem("7", unlocked: streak >= 7),
                    _buildBadgeItem("14", unlocked: streak >= 14),
                    _buildBadgeItem("21", unlocked: streak >= 21),
                  ],
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
