import 'package:flutter/material.dart';
import 'package:nutri_mealo/pages/profile/edit_profile/edit_profile_page3.dart';

class EditProfilePage2 extends StatefulWidget {
  const EditProfilePage2({super.key});

  @override
  State<EditProfilePage2> createState() => _EditProfilePage2State();
}

class _EditProfilePage2State extends State<EditProfilePage2> {
  final TextEditingController _allergicController = TextEditingController();
  final TextEditingController _otherAllergicController =
      TextEditingController();
  final TextEditingController _otherDietaryController = TextEditingController();

  List<String> _selectedDietaryPreferences = [];
  final List<String> _selectedTastePreferences = [];
  String? _selectedPhysicalActivity;

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
  final List<String> physicalActivityOptions = ['Low', 'Moderate', 'Heavy'];

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: commonAppBar(),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: ListView(
            children: [
              const SizedBox(height: 30),
              editProfileContentField(),
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
      ),
    );
  }

  void _showConfirmationPopup() {
    showDialog(
      context: context,
      barrierDismissible: false, // Forces user to tap the button
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: const Text(
            'Skip?',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          content: const Text('Are you sure you want to skip to next page?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => EditProfilePage3()),
                );
              },
              child: const Text(
                'Yes',
                style: TextStyle(color: Color(0xff16C47F)),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget skipButtonField() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 100),
      child: TextButton(
        onPressed: () {
          _showConfirmationPopup();
        },
        child: const Text(
          "Skip?",
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
              allergyOptions.map((allergy) {
                return DropdownMenuItem(value: allergy, child: Text(allergy));
              }).toList(),
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

  Column physicalActivityField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Physical Activity",
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 5),
        Row(
          children: [
            Expanded(
              child: DropdownButtonFormField<String>(
                value: _selectedPhysicalActivity,
                hint: const Text('Select your physical activity'),
                onChanged: (value) {
                  setState(() {
                    _selectedPhysicalActivity = value;
                  });
                },
                items:
                    ['Low', 'Moderate', 'Heavy']
                        .map(
                          (activity) => DropdownMenuItem(
                            value: activity,
                            child: Text(activity),
                          ),
                        )
                        .toList(),
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ),
            if (_selectedPhysicalActivity != null)
              IconButton(
                icon: const Icon(Icons.clear, color: Colors.red),
                onPressed: () {
                  setState(() {
                    _selectedPhysicalActivity = null;
                  });
                },
              ),
          ],
        ),
      ],
    );
  }

  Row editProfileContentField() {
    return Row(
      children: [
        SizedBox(width: 150),
        Center(
          child: Text(
            'Edit Profile',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
        ),
        const SizedBox(width: 48),
      ],
    );
  }

  Padding nextButtonField() {
    return Padding(
      padding: const EdgeInsets.only(left: 50, right: 50),
      child: ElevatedButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => EditProfilePage3()),
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
