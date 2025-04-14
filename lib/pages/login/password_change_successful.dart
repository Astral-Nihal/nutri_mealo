import 'package:flutter/material.dart';
import 'package:nutri_mealo/pages/login/login_page_enter_details.dart';

class PasswordChangeSuccessful extends StatefulWidget {
  const PasswordChangeSuccessful({super.key});

  @override
  State<PasswordChangeSuccessful> createState() =>
      _PasswordChangeSuccessfulState();
}

class _PasswordChangeSuccessfulState extends State<PasswordChangeSuccessful> {
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
            passwordChangeSuccessContentField(),
            const SizedBox(height: 50),
            passwordChangeSuccessImageField(),
            const SizedBox(height: 50),
            backToLoginButtonField(),
            const SizedBox(height: 50),
          ],
        ),
      ),
    );
  }

  Padding passwordChangeSuccessImageField() {
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

  Column passwordChangeSuccessContentField() {
    return Column(
      children: [
        Text(
          'Password Changed',
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
            'Your Password has been \nchanged successfully',
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

  Padding backToLoginButtonField() {
    return Padding(
      padding: const EdgeInsets.only(left: 50, right: 50),
      child: ElevatedButton(
        onPressed: () {
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (_) => LoginPageEnterDetails()),
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
          'Back to Login',
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
