import 'package:flutter/material.dart';
import 'package:nutri_mealo/pages/signup/setup_profile_page_second.dart';

class SetupProfilePage extends StatefulWidget {
  const SetupProfilePage({super.key});

  @override
  State<SetupProfilePage> createState() => _SetupProfilePageState();
}

class _SetupProfilePageState extends State<SetupProfilePage> {
  DateTime? _selectedDate;
  int? _calculatedAge;

  String? _selectedGender;

  bool _dobError = false;

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: commonAppBar(),
        body: Form(
          key: _formKey,
          child: ListView(
            children: [
              const SizedBox(height: 30),
              setupProfileContentField(),
              const SizedBox(height: 30),
              enterNameField(),
              const SizedBox(height: 20),
              enterAgeField(context),
              const SizedBox(height: 20),
              genderSelectionField(),
              const SizedBox(height: 20),
              enterHeightAndWeightFields(),
              const SizedBox(height: 30),
              nextButtonField(),
              const SizedBox(height: 50),
            ],
          ),
        ),
      ),
    );
  }

  Padding enterHeightAndWeightFields() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 50.0, vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Height (in cm)",
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 5),
          TextFormField(
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
              hintText: "Enter your height in cm",
              prefixIcon: Icon(Icons.height),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return "Height is required";
              }
              final height = double.tryParse(value);
              if (height == null || height <= 0 || height > 300) {
                return "Enter a valid height";
              }
              return null;
            },
          ),
          const SizedBox(height: 20),
          const Text(
            "Weight (in kg)",
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 5),
          TextFormField(
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
              hintText: "Enter your weight in kg",
              prefixIcon: Icon(Icons.monitor_weight),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return "Weight is required";
              }
              final weight = double.tryParse(value);
              if (weight == null || weight <= 0 || weight > 500) {
                return "Enter a valid weight";
              }
              return null;
            },
          ),
        ],
      ),
    );
  }

  Padding genderSelectionField() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 50),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Gender",
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),
          RadioListTile<String>(
            title: const Text('Male'),
            value: 'Male',
            groupValue: _selectedGender,
            contentPadding: EdgeInsets.zero,
            visualDensity: VisualDensity.compact,
            onChanged: (value) {
              setState(() {
                _selectedGender = value;
              });
            },
          ),
          RadioListTile<String>(
            title: const Text('Female'),
            value: 'Female',
            groupValue: _selectedGender,
            contentPadding: EdgeInsets.zero,
            visualDensity: VisualDensity.compact,
            onChanged: (value) {
              setState(() {
                _selectedGender = value;
              });
            },
          ),
          RadioListTile<String>(
            title: const Text('Prefer not to say'),
            value: 'Prefer not to say',
            groupValue: _selectedGender,
            contentPadding: EdgeInsets.zero,
            visualDensity: VisualDensity.compact,
            onChanged: (value) {
              setState(() {
                _selectedGender = value;
              });
            },
          ),
        ],
      ),
    );
  }

  int _calculateAge(DateTime birthDate) {
    DateTime today = DateTime.now();
    int age = today.year - birthDate.year;
    if (today.month < birthDate.month ||
        (today.month == birthDate.month && today.day < birthDate.day)) {
      age--;
    }
    return age;
  }

  Padding enterAgeField(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 50),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Date of Birth",
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 5),
          GestureDetector(
            onTap: () async {
              DateTime? pickedDate = await showDatePicker(
                context: context,
                initialDate: DateTime(2000),
                firstDate: DateTime(1900),
                lastDate: DateTime.now(),
              );
              if (pickedDate != null) {
                setState(() {
                  _selectedDate = pickedDate;
                  _calculatedAge = _calculateAge(pickedDate);
                  _dobError = false;
                });
              }
            },
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 15),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  const Icon(
                    Icons.calendar_today,
                    size: 20,
                    color: Colors.grey,
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      _selectedDate == null
                          ? 'Select your date of birth'
                          : '${_selectedDate!.day}/${_selectedDate!.month}/${_selectedDate!.year}',
                      style: const TextStyle(fontSize: 16),
                    ),
                  ),
                  if (_selectedDate != null)
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          _selectedDate = null;
                          _calculatedAge = null;
                        });
                      },
                      child: const Icon(
                        Icons.clear,
                        size: 20,
                        color: Colors.red,
                      ),
                    ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 10),
          if (_calculatedAge != null)
            Text(
              'Age: $_calculatedAge years',
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
            ),
          if (_dobError)
            const Padding(
              padding: EdgeInsets.only(left: 5),
              child: Text(
                'Date of birth is required',
                style: TextStyle(color: Colors.red, fontSize: 13),
              ),
            ),
        ],
      ),
    );
  }

  Padding enterNameField() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 50),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Name",
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 5),
          TextFormField(
            keyboardType: TextInputType.name,
            decoration: InputDecoration(
              hintText: "Enter your name",
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              prefixIcon: const Icon(Icons.person),
            ),
            validator: (value) {
              if (value == null || value.trim().isEmpty) {
                return 'Name is required';
              }
              if (value.trim().length < 3) {
                return 'Name must be at least 3 characters';
              }
              return null;
            },
          ),
        ],
      ),
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
          bool formValid = _formKey.currentState!.validate();
          bool dobValid = _selectedDate != null;

          setState(() {
            _dobError = !dobValid;
          });

          if (formValid && dobValid) {
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(builder: (_) => SetupProfilePageSecond()),
            );
          }
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xffF93827),
          minimumSize: const Size(300, 60),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(28),
          ),
        ),
        child: Text(
          'Next',
          style: const TextStyle(color: Colors.white, fontSize: 20),
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
