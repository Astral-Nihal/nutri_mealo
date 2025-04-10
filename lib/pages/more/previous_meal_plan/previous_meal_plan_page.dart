import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:nutri_mealo/pages/more/previous_meal_plan/previous_week_meal_plan_page.dart';

class PreviousMealPlanPage extends StatelessWidget {
  const PreviousMealPlanPage({super.key});

  List<Map<String, String>> generatePastWeeks(int count) {
    final now = DateTime.now();
    final List<Map<String, String>> weeks = [];

    for (int i = 0; i < count; i++) {
      final referenceDate = now.subtract(Duration(days: i * 7));
      final int weekday = referenceDate.weekday; // Monday = 1, Sunday = 7

      final startOfWeek = referenceDate.subtract(
        Duration(days: weekday - 1),
      ); // Go back to Monday
      final endOfWeek = startOfWeek.add(const Duration(days: 6)); // Sunday

      final formatter = DateFormat('MMM d');
      final weekRange =
          '${formatter.format(startOfWeek)} - ${formatter.format(endOfWeek)}';

      weeks.add({'title': 'Week ${count - i}', 'range': weekRange});
    }

    return weeks;
  }

  @override
  Widget build(BuildContext context) {
    final pastWeeks = generatePastWeeks(5);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: _commonAppBar(),
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Previous Meal Plan',
              style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: ListView.builder(
                itemCount: pastWeeks.length,
                itemBuilder: (context, index) {
                  final week = pastWeeks[index];
                  final weekNumber = int.parse(week['title']!.split(' ').last);
                  return _buildWeekCard(
                    icon: Icons.calendar_today,
                    title: '${week['title']} (${week['range']})',
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder:
                              (_) => PreviousWeekMealPlanPage(
                                weekNumber: weekNumber,
                                weekRange: week['range']!,
                              ),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  AppBar _commonAppBar() {
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 0,
      centerTitle: true,
      title: const Text(
        'Nutri-mealo',
        style: TextStyle(
          color: Color(0xff16C47F),
          fontSize: 32,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildWeekCard({
    required IconData icon,
    required String title,
    required VoidCallback onPressed,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 6),
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: const BorderSide(color: Colors.black54),
        ),
        color: Colors.grey.shade200,
        child: ListTile(
          leading: Icon(icon, size: 30, color: Colors.black87),
          title: Text(
            title,
            style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
          ),
          trailing: IconButton(
            icon: const Icon(Icons.keyboard_arrow_right_outlined),
            onPressed: onPressed,
          ),
          onTap: onPressed,
        ),
      ),
    );
  }
}
