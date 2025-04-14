import 'package:flutter/material.dart';
import 'package:nutri_mealo/pages/signup/setup_profile_page_third.dart';

class SetupProfilePageSecond extends StatefulWidget {
  const SetupProfilePageSecond({super.key});

  @override
  State<SetupProfilePageSecond> createState() => _SetupProfilePageSecondState();
}

class _SetupProfilePageSecondState extends State<SetupProfilePageSecond> {
  final TextEditingController _allergicController = TextEditingController();
  final TextEditingController _otherAllergicController =
      TextEditingController();
  final TextEditingController _otherDietaryController = TextEditingController();

  List<String> _selectedDietaryPreferences = [];
  final List<String> _selectedTastePreferences = [];

  final List<String> dietaryOptions = ['Veg', 'Non-Veg', 'Others'];
  final List<String> tasteOptions = [
    'Sweet',
    'Sour',
    'Salty',
    'Spicy',
    'Bitter',
    'Umami',
    'Astringent',
  ];

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
          padding: const EdgeInsets.symmetric(horizontal: 30),
          children: [
            const SizedBox(height: 30),
            setupProfileContentField(),
            const SizedBox(height: 50),
            allergicSpecificationField(),
            const SizedBox(height: 35),
            dietaryPreferencesField(),
            if (_selectedDietaryPreferences.contains('Others'))
              Padding(
                padding: const EdgeInsets.only(top: 10),
                child: TextField(
                  controller: _otherDietaryController,
                  decoration: InputDecoration(
                    labelText: 'Please specify',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ),
            const SizedBox(height: 35),
            tastePreferencesField(),
            const SizedBox(height: 200),
            nextButtonField(),
            const SizedBox(height: 5),
            skipButtonField(),
            const SizedBox(height: 50),
          ],
        ),
      ),
    );
  }

  Widget skipButtonField() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 100),
      child: TextButton(
        onPressed: () {
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (_) => SetupProfilePageThird()),
          );
        },
        child: const Text(
          "Skip for now?",
          style: TextStyle(fontSize: 16, color: Color(0xff16C47F)),
        ),
      ),
    );
  }

  Column allergicSpecificationField() {
    final List<String> allergyOptions = [
      'None',
      'Peanuts',
      'Shellfish',
      'Dairy',
      'Gluten',
      'Eggs',
      'Others',
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Allergic Specification",
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 5),
        DropdownButtonFormField<String>(
          value:
              _allergicController.text.isEmpty
                  ? null
                  : _allergicController.text,
          hint: const Text('Select your allergy (if any)'),
          onChanged: (value) {
            setState(() {
              _allergicController.text = value ?? '';
              if (value != 'Others') {
                _otherAllergicController.clear();
              }
            });
          },
          items:
              allergyOptions
                  .map(
                    (allergy) =>
                        DropdownMenuItem(value: allergy, child: Text(allergy)),
                  )
                  .toList(),
          decoration: InputDecoration(
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
          ),
        ),
        if (_allergicController.text == 'Others') ...[
          const SizedBox(height: 10),
          TextField(
            controller: _otherAllergicController,
            decoration: InputDecoration(
              hintText: 'Please specify your allergy',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
        ],
      ],
    );
  }

  Column dietaryPreferencesField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Dietary Preferences",
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 5),
        Wrap(
          spacing: 10,
          children:
              dietaryOptions.map((option) {
                final isSelected = _selectedDietaryPreferences.contains(option);
                return FilterChip(
                  label: Text(option),
                  selected: isSelected,
                  onSelected: (selected) {
                    setState(() {
                      if (selected) {
                        if (option == 'Others') {
                          _selectedDietaryPreferences = [option];
                        } else {
                          _selectedDietaryPreferences.removeWhere(
                            (e) => e == 'Others',
                          );
                          _selectedDietaryPreferences.add(option);
                        }
                      } else {
                        _selectedDietaryPreferences.remove(option);
                      }
                    });
                  },
                );
              }).toList(),
        ),
      ],
    );
  }

  Column tastePreferencesField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Taste Preferences",
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 5),
        Wrap(
          spacing: 10,
          children:
              tasteOptions.map((taste) {
                final isSelected = _selectedTastePreferences.contains(taste);
                return FilterChip(
                  label: Text(taste),
                  selected: isSelected,
                  onSelected: (selected) {
                    setState(() {
                      if (selected) {
                        _selectedTastePreferences.add(taste);
                      } else {
                        _selectedTastePreferences.remove(taste);
                      }
                    });
                  },
                );
              }).toList(),
        ),
      ],
    );
  }

  Center setupProfileContentField() {
    return const Center(
      child: Text(
        "Setup Profile",
        style: TextStyle(
          fontSize: 28,
          fontWeight: FontWeight.bold,
          color: Colors.black,
        ),
      ),
    );
  }

  Padding nextButtonField() {
    return Padding(
      padding: const EdgeInsets.only(left: 50, right: 50),
      child: ElevatedButton(
        onPressed: () {
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (_) => SetupProfilePageThird()),
          );
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xffF93827),
          minimumSize: const Size(300, 60),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(28),
          ),
        ),
        child: const Text(
          'Next',
          style: TextStyle(color: Colors.white, fontSize: 20),
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
    );
  }
}
