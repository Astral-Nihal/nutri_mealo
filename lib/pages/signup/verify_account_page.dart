import 'package:flutter/material.dart';
import 'package:nutri_mealo/pages/signup/account_verification_successful.dart';
import 'dart:async';

class VerifyAccountPage extends StatefulWidget {
  const VerifyAccountPage({super.key});

  @override
  State<VerifyAccountPage> createState() => _VerifyAccountPageState();
}

class _VerifyAccountPageState extends State<VerifyAccountPage> {
  bool _isResendEnabled = true;
  int _resendCountdown = 30;
  Timer? _timer;

  void _startResendCooldown() {
    setState(() {
      _isResendEnabled = false;
      _resendCountdown = 30;
    });

    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        if (_resendCountdown > 1) {
          _resendCountdown--;
        } else {
          _isResendEnabled = true;
          _timer?.cancel();
        }
      });
    });
  }

  @override
  void dispose() {
    _timer?.cancel(); // Clean up the timer
    super.dispose();
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
            const SizedBox(height: 60),
            enterOtpContentField(),
            const SizedBox(height: 50),
            enterOtpImageField(),
            const SizedBox(height: 30),
            enterOtpField(),
            resentOtpField(context),
            const SizedBox(height: 50),
            verifyButtonField(),
            const SizedBox(height: 50),
          ],
        ),
      ),
    );
  }

  Padding resentOtpField(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 50, right: 50),
      child: Align(
        alignment: Alignment.topCenter,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Didn\'t receive OTP?',
              style: TextStyle(
                color: Colors.black,
                fontSize: 14,
                fontWeight: FontWeight.w300,
              ),
            ),
            TextButton(
              onPressed:
                  _isResendEnabled
                      ? () {
                        // 🔄 Your resend logic goes here
                        _startResendCooldown();
                      }
                      : null,
              child: Text(
                _isResendEnabled ? "Resend" : "Resend ($_resendCountdown)",
                style: TextStyle(
                  color:
                      _isResendEnabled ? const Color(0xff16C47F) : Colors.grey,
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Padding enterOtpField() {
    return Padding(
      padding: const EdgeInsets.only(left: 50, right: 50),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const Text(
            "OTP",
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 5),
          TextField(
            keyboardType: TextInputType.number,
            maxLength: 6,
            textAlign: TextAlign.center,
            decoration: InputDecoration(
              hintText: "Enter the OTP",
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: Colors.black),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Padding enterOtpImageField() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Image.asset(
        'assets/images/otp_mail_sent.png',
        height: 200,
        width: 200,
        fit: BoxFit.contain,
      ),
    );
  }

  Column enterOtpContentField() {
    return Column(
      children: [
        Text(
          'Verify Your Account',
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
            'Your One Time Password (OTP) has been \nsent to your registered email for account verification',
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

  Padding verifyButtonField() {
    return Padding(
      padding: const EdgeInsets.only(left: 50, right: 50),
      child: ElevatedButton(
        onPressed: () {
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (_) => AccountVerificationSuccessful()),
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
          'Verify',
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
