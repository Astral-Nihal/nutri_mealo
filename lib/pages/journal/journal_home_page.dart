import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:nutri_mealo/pages/profile/profile_home_page.dart';

class JournalHomePage extends StatefulWidget {
  const JournalHomePage({super.key});

  @override
  State<JournalHomePage> createState() => _JournalHomePageState();
}

class _JournalHomePageState extends State<JournalHomePage> {
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
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: commonAppBar(),
        body: ListView(
          children: [
            const SizedBox(height: 10),
            menuBarField(context),
            const SizedBox(height: 20),
            weeklyDateCards(),
            const SizedBox(height: 40),
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
    );
  }

  Widget mealCard({required IconData icon, required String title}) {
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
              //_showMealPopup(title);
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
