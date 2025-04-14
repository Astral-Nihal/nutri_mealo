import 'package:flutter/material.dart';

class EditProfilePage3 extends StatefulWidget {
  const EditProfilePage3({super.key});

  @override
  State<EditProfilePage3> createState() => _EditProfilePage3State();
}

class _EditProfilePage3State extends State<EditProfilePage3> {
  // Section 1
  String? _dailyRoutine;
  String? _sittingHours;

  // Section 2
  String? _exerciseDays;
  String? _exerciseType;
  String? _exerciseDuration;

  // Section 3
  String? _nonWorkoutActivity;
  String? _dailySteps;

  bool _areAllFieldsFilled() {
    return _dailyRoutine != null &&
        _sittingHours != null &&
        _exerciseDays != null &&
        _exerciseType != null &&
        _exerciseDuration != null &&
        _nonWorkoutActivity != null &&
        _dailySteps != null;
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: commonAppBar(),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: ListView(
            children: [
              const SizedBox(height: 30),
              sectionTitle("Occupation & Daily Activity Level"),
              questionDropdown(
                question: "What best describes your daily work/study routine?",
                value: _dailyRoutine,
                onChanged: (value) => setState(() => _dailyRoutine = value),
                options: [
                  "Mostly sitting (desk job, student, driver)",
                  "Light movement (teacher, shopkeeper, housewife)",
                  "Moderate movement (nurse, salesperson, waiter)",
                  "Heavy physical work (construction worker, athlete, farmer)",
                ],
              ),
              questionDropdown(
                question:
                    "How many hours do you spend sitting each day (work, travel, screen time)?",
                value: _sittingHours,
                onChanged: (value) => setState(() => _sittingHours = value),
                options: [
                  "More than 8 hours",
                  "6–8 hours",
                  "4–6 hours",
                  "Less than 4 hours",
                ],
              ),
              const SizedBox(height: 35),
              sectionTitle("Exercise & Workout Routine"),
              questionDropdown(
                question:
                    "How many days per week do you engage in exercise or sports?",
                value: _exerciseDays,
                onChanged: (value) => setState(() => _exerciseDays = value),
                options: ["0 days", "1–2 days", "3–4 days", "5 or more days"],
              ),
              questionDropdown(
                question: "What type of exercise do you usually do?",
                value: _exerciseType,
                onChanged: (value) => setState(() => _exerciseType = value),
                options: [
                  "No exercise",
                  "Light exercise (yoga, walking, stretching)",
                  "Moderate exercise (jogging, cycling, bodyweight training)",
                  "Intense exercise (HIIT, weightlifting, competitive sports)",
                ],
              ),
              questionDropdown(
                question: "How long do you exercise per session?",
                value: _exerciseDuration,
                onChanged: (value) => setState(() => _exerciseDuration = value),
                options: [
                  "Less than 15 minutes",
                  "15–30 minutes",
                  "30–60 minutes",
                  "More than 1 hour",
                ],
              ),
              const SizedBox(height: 35),
              sectionTitle("General Lifestyle & Movement"),
              questionDropdown(
                question:
                    "How often do you engage in physical activities outside workouts?",
                value: _nonWorkoutActivity,
                onChanged:
                    (value) => setState(() => _nonWorkoutActivity = value),
                options: [
                  "Rarely (mostly inactive lifestyle)",
                  "Occasionally (some household activities)",
                  "Frequently (walking, standing, moving around)",
                  "Very often (active throughout the day)",
                ],
              ),
              questionDropdown(
                question:
                    "Do you use a fitness tracker to monitor steps? What is your daily step count?",
                value: _dailySteps,
                onChanged: (value) => setState(() => _dailySteps = value),
                options: [
                  "Less than 3,000 steps",
                  "3,000–6,000 steps",
                  "6,000–10,000 steps",
                  "More than 10,000 steps",
                ],
              ),
              const SizedBox(height: 60),
              nextButtonField(),
              const SizedBox(height: 10),
              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }

  Widget sectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Text(
        title,
        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
      ),
    );
  }

  Widget questionDropdown({
    required String question,
    required String? value,
    required void Function(String?) onChanged,
    required List<String> options,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 25),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(question, style: const TextStyle(fontSize: 14)),
          const SizedBox(height: 8),
          DropdownButtonFormField<String>(
            value: value,
            isExpanded: true,
            hint: const Text("Select an option"),
            onChanged: onChanged,
            items:
                options.map((option) {
                  return DropdownMenuItem<String>(
                    value: option,
                    child: Tooltip(
                      message: option,
                      child: Text(
                        option,
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                        softWrap: false,
                      ),
                    ),
                  );
                }).toList(),
            selectedItemBuilder: (context) {
              return options.map((option) {
                return Tooltip(
                  message: option,
                  child: Text(
                    option,
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                    softWrap: false,
                  ),
                );
              }).toList();
            },
            decoration: InputDecoration(
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
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

  Padding nextButtonField() {
    return Padding(
      padding: const EdgeInsets.only(left: 50, right: 50),
      child: ElevatedButton(
        onPressed: () {
          if (_areAllFieldsFilled()) {
            _showConfirmationPopup();
          } else {
            _showIncompletePopup();
          }
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xffF93827),
          minimumSize: const Size(300, 60),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(28),
          ),
        ),
        child: const Text(
          'Save Changes',
          style: TextStyle(color: Colors.white, fontSize: 20),
        ),
      ),
    );
  }

  void _showIncompletePopup() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: const Text(
            'Incomplete',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          content: const Text(
            'Please answer all the questions before proceeding.',
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text(
                'OK',
                style: TextStyle(color: Color(0xffF93827)),
              ),
            ),
          ],
        );
      },
    );
  }

  void _showConfirmationPopup() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: const Text(
            'Success',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          content: const Text('Your changes have been saved.'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.of(context).pop();
                Navigator.of(context).pop();
                Navigator.of(context).pop();
              },
              child: const Text(
                'Close',
                style: TextStyle(color: Color(0xff16C47F)),
              ),
            ),
          ],
        );
      },
    );
  }
}
