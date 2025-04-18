import 'package:flutter/material.dart';
import 'package:nutri_mealo/pages/login/login_page_enter_details.dart';

class PressedLogoutCardPage extends StatefulWidget {
  const PressedLogoutCardPage({super.key});

  @override
  State<PressedLogoutCardPage> createState() => _PressedLogoutCardPageState();
}

class _PressedLogoutCardPageState extends State<PressedLogoutCardPage> {
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
            const SizedBox(height: 60),
            logoutContentField(),
            const SizedBox(height: 50),
            logoutImageField(),
            const SizedBox(height: 50),
            yesNoButtonRow(),
            const SizedBox(height: 50),
          ],
        ),
      ),
    );
  }

  Padding logoutImageField() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Image.asset(
        'assets/images/logout_image.png',
        width: 250,
        height: 400,
        fit: BoxFit.contain,
      ),
    );
  }

  Column logoutContentField() {
    return Column(
      children: [
        Text(
          'Logout?',
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Colors.black,
            fontSize: 30,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 50),
        Padding(
          padding: const EdgeInsets.all(10.0),
          child: Text(
            'Are you sure you want to logout \nfrom your account?',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.black,
              fontSize: 20,
              fontWeight: FontWeight.w300,
            ),
          ),
        ),
      ],
    );
  }

  void _showLogoutConfirmationPopup(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          contentPadding: const EdgeInsets.all(24),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text('😔', style: TextStyle(fontSize: 40)),
              const SizedBox(height: 20),
              const Text(
                'Do you really want to logout?',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 30),
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pushReplacement(
                    MaterialPageRoute(builder: (_) => LoginPageEnterDetails()),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xffF93827),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 40,
                    vertical: 14,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(28),
                  ),
                ),
                child: const Text(
                  'Confirm',
                  style: TextStyle(fontSize: 18, color: Colors.white),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget yesNoButtonRow() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 50),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          // Yes Button
          Expanded(
            child: ElevatedButton(
              onPressed: () {
                _showLogoutConfirmationPopup(context);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xffF93827),
                minimumSize: const Size(100, 60),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(28),
                ),
              ),
              child: const Text(
                'Yes',
                style: TextStyle(color: Colors.white, fontSize: 20),
              ),
            ),
          ),
          const SizedBox(width: 20), // space between buttons
          // No Button
          Expanded(
            child: ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xffFF9D23),
                minimumSize: const Size(100, 60),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(28),
                ),
              ),
              child: const Text(
                'No',
                style: TextStyle(color: Colors.white, fontSize: 20),
              ),
            ),
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
