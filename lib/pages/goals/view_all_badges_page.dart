import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ViewAllBadgesPage extends StatefulWidget {
  const ViewAllBadgesPage({super.key});

  @override
  State<ViewAllBadgesPage> createState() => _ViewAllBadgesPageState();
}

class _ViewAllBadgesPageState extends State<ViewAllBadgesPage> {
  int streak = 0; // Initialize streak to 0
  List<int> unlockedBadges = [];

  @override
  void initState() {
    super.initState();
    _loadStreakData();
    _loadMonthlyBadgeData(); // Load unlocked months
  }

  List<int> unlockedMonthBadges = [];

  Future<void> _loadMonthlyBadgeData() async {
    final prefs = await SharedPreferences.getInstance();
    final fulfilledDays = prefs.getStringList('fulfilledDays') ?? [];

    // Create a map to count days fulfilled in each month
    Map<int, int> fulfilledCount = {}; // month -> count
    Map<int, int> totalDays = {}; // month -> total days

    for (String dateStr in fulfilledDays) {
      final date = DateTime.tryParse(dateStr);
      if (date != null && date.year == DateTime.now().year) {
        final month = date.month;
        fulfilledCount[month] = (fulfilledCount[month] ?? 0) + 1;
      }
    }

    // Calculate total days for each month (this year only)
    for (int month = 1; month <= 12; month++) {
      final now = DateTime.now();
      final total =
          DateTime(now.year, month + 1, 0).day; // last day of the month
      totalDays[month] = total;

      if ((fulfilledCount[month] ?? 0) >= total) {
        unlockedMonthBadges.add(month); // Unlock the badge
      }
    }

    setState(() {}); // Refresh UI
  }

  // Method to load streak from SharedPreferences
  Future<void> _loadStreakData() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      streak = prefs.getInt('streak') ?? 0; // Load streak value or default to 0
    });

    // Check streak to unlock badges
    if (streak >= 7) {
      unlockedBadges.add(7); // Unlock 7 days badge
    }
    if (streak >= 14) {
      unlockedBadges.add(14); // Unlock 14 days badge
    }
    if (streak >= 21) {
      unlockedBadges.add(21); // Unlock 21 days badge
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: commonAppBar(),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Center(
              child: Text(
                'Badges',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(height: 32),

            // Beginner Badges Title
            const Text(
              'Beginner Badges',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 16),

            // Badges Section with Container similar to Goals Home Page
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
            const SizedBox(height: 32),

            // Yearly Badges Title
            const Text(
              '2025 Badges',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 16),

            // Month Badges Grid
            _buildMonthlyBadgesGrid(),
          ],
        ),
      ),
    );
  }

  Widget _buildMonthlyBadgesGrid() {
    final months = [
      '1',
      '2',
      '3',
      '4',
      '5',
      '6',
      '7',
      '8',
      '9',
      '10',
      '11',
      '12',
    ];

    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: Colors.black),
        borderRadius: BorderRadius.circular(16),
      ),
      clipBehavior: Clip.antiAlias, // Ensures children respect rounded corners
      child: Table(
        border: TableBorder.symmetric(
          inside: BorderSide(color: Colors.black, width: 0.5),
        ),
        children: List.generate(4, (row) {
          return TableRow(
            children: List.generate(3, (col) {
              final index = row * 3 + col;
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: _buildMonthBadgeItem(months[index]),
              );
            }),
          );
        }),
      ),
    );
  }

  Widget _buildMonthBadgeItem(String month) {
    int monthNum = int.parse(month);
    String imagePath = 'assets/badge/$month.png';

    bool unlocked = unlockedMonthBadges.contains(monthNum);

    return Container(
      alignment: Alignment.center,
      child: Stack(
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
                  return Container(
                    height: 80,
                    width: 80,
                    color: Colors.grey.shade300,
                    child: Center(
                      child: Text(
                        month,
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
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
                size: 20,
              ),
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
      width: 120, // Set a fixed width
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
        decoration: BoxDecoration(
          color: Colors.transparent,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Stack(
              alignment: Alignment.center,
              children: [
                // Wrapping the ColorFiltered widget only around the image
                ClipRRect(
                  borderRadius: BorderRadius.circular(12), // Round corners
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
                // If unlocked is false, show the lock icon on top of the badge
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
      elevation: 0,
    );
  }
}
