import 'package:flutter/material.dart';
import 'package:nutri_mealo/pages/signup/setup_profile_page.dart';

class AccountVerificationSuccessful extends StatefulWidget {
  const AccountVerificationSuccessful({super.key});

  @override
  State<AccountVerificationSuccessful> createState() =>
      _AccountVerificationSuccessfulState();
}

class _AccountVerificationSuccessfulState
    extends State<AccountVerificationSuccessful> {
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
            verificationSuccessContentField(),
            const SizedBox(height: 50),
            verificationSuccessImageField(),
            const SizedBox(height: 50),
            nextButtonField(),
            const SizedBox(height: 50),
          ],
        ),
      ),
    );
  }

  Padding verificationSuccessImageField() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Image.asset(
        'assets/images/verified.png',
        width: 250,
        height: 400,
        fit: BoxFit.contain,
      ),
    );
  }

  Column verificationSuccessContentField() {
    return Column(
      children: [
        Text(
          'Verification Successful',
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
            'You are just 2 steps away from \nentering into our app',
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

  Padding nextButtonField() {
    return Padding(
      padding: const EdgeInsets.only(left: 50, right: 50),
      child: ElevatedButton(
        onPressed: () {
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (_) => SetupProfilePage()),
          );
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
