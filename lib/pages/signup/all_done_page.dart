import 'package:flutter/material.dart';
import 'package:nutri_mealo/widgets/main_navigation.dart';

class AllDonePage extends StatefulWidget {
  const AllDonePage({super.key});

  @override
  State<AllDonePage> createState() => _AllDonePageState();
}

class _AllDonePageState extends State<AllDonePage> {
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
            allDoneContentField(),
            const SizedBox(height: 50),
            allDoneImageField(),
            const SizedBox(height: 50),
            letsGoButtonField(),
            const SizedBox(height: 50),
          ],
        ),
      ),
    );
  }

  Padding allDoneImageField() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Image.asset(
        'assets/images/all_done.png',
        width: 250,
        height: 400,
        fit: BoxFit.contain,
      ),
    );
  }

  Column allDoneContentField() {
    return Column(
      children: [
        Text(
          'All Done',
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
            'Thanks for giving us your precious time.\nNow you\'re ready for making a more \nhealthier and productive life.',
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

  Padding letsGoButtonField() {
    return Padding(
      padding: const EdgeInsets.only(left: 50, right: 50),
      child: ElevatedButton(
        onPressed: () {
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (_) => MainNavigation()),
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
          'Let\'s Go!',
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
