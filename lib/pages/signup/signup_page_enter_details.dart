import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:nutri_mealo/pages/login/login_page_enter_details.dart';
import 'package:nutri_mealo/pages/signup/verify_account_page.dart';

class SignupPageEnterDetails extends StatefulWidget {
  const SignupPageEnterDetails({super.key});

  @override
  State<SignupPageEnterDetails> createState() => _SignupPageEnterDetailsState();
}

class _SignupPageEnterDetailsState extends State<SignupPageEnterDetails> {
  bool _obscurePassword = true;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: commonAppBar(),
        bottomNavigationBar: logInBottomBar(),
        body: ListView(
          children: [
            const SizedBox(height: 50),
            googleSignInField(),
            const SizedBox(height: 50),
            horizontalDividerField(),
            const SizedBox(height: 50),
            emailField(),
            const SizedBox(height: 50),
            passwordField(),
            const SizedBox(height: 50),
            reEnterPasswordField(),
            const SizedBox(height: 70),
            signupButtonField(),
            const SizedBox(height: 50),
          ],
        ),
      ),
    );
  }

  Padding signupButtonField() {
    return Padding(
      padding: const EdgeInsets.only(left: 50, right: 50),
      child: ElevatedButton(
        onPressed: () {
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (_) => VerifyAccountPage()),
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
          'Sign Up',
          style: const TextStyle(color: Colors.white, fontSize: 20),
        ),
      ),
    );
  }

  Padding reEnterPasswordField() {
    return Padding(
      padding: const EdgeInsets.only(left: 50, right: 50),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "ReEnter Password",
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 5),
          TextField(
            obscureText: _obscurePassword,
            maxLength: 8,
            decoration: InputDecoration(
              hintText: "ReEnter your password",
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              prefixIcon: const Icon(Icons.lock),
              suffixIcon: IconButton(
                icon: Icon(
                  _obscurePassword ? Icons.visibility_off : Icons.visibility,
                ),
                onPressed: () {
                  setState(() {
                    _obscurePassword = !_obscurePassword;
                  });
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  Padding passwordField() {
    return Padding(
      padding: const EdgeInsets.only(left: 50, right: 50),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Password",
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 5),
          TextField(
            obscureText: _obscurePassword,
            maxLength: 8,
            decoration: InputDecoration(
              hintText: "Enter your password",
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              prefixIcon: const Icon(Icons.lock),
              suffixIcon: IconButton(
                icon: Icon(
                  _obscurePassword ? Icons.visibility_off : Icons.visibility,
                ),
                onPressed: () {
                  setState(() {
                    _obscurePassword = !_obscurePassword;
                  });
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  Padding emailField() {
    return Padding(
      padding: const EdgeInsets.only(left: 50, right: 50),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Email",
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 5),
          TextField(
            keyboardType: TextInputType.emailAddress,
            decoration: InputDecoration(
              hintText: "Enter your email",
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: Colors.black),
              ),
              prefixIcon: const Icon(Icons.email),
            ),
          ),
        ],
      ),
    );
  }

  Padding horizontalDividerField() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 5),
      child: Row(
        children: [
          Expanded(child: Divider(thickness: 1, color: Colors.grey)),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 10),
            child: Text(
              "OR",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(child: Divider(thickness: 1, color: Colors.grey)),
        ],
      ),
    );
  }

  Padding googleSignInField() {
    return Padding(
      padding: const EdgeInsets.only(left: 50, right: 50),
      child: ElevatedButton(
        onPressed: () {},
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.white70,
          fixedSize: const Size(100, 60),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            SvgPicture.asset('assets/images/google_icon.svg', height: 30),
            Text(
              'Continue With Google',
              style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.normal,
                fontSize: 25,
              ),
            ),
          ],
        ),
      ),
    );
  }

  BottomAppBar logInBottomBar() {
    return BottomAppBar(
      color: Colors.white,
      elevation: 20,
      child: Padding(
        padding: const EdgeInsets.only(bottom: 10.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Already have an account?',
              style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.w300,
                fontSize: 20,
              ),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(builder: (_) => LoginPageEnterDetails()),
                );
              },
              child: const Text(
                'Login',
                style: TextStyle(
                  color: Color(0xff16C47F),
                  fontWeight: FontWeight.w400,
                  fontSize: 20,
                ),
              ),
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
    );
  }
}
