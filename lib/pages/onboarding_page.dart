import 'package:flutter/material.dart';
import 'package:nutri_mealo/pages/login/login_page_enter_details.dart';
import 'package:nutri_mealo/widgets/onboarding_card.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class OnboardingPage extends StatefulWidget {
  const OnboardingPage({super.key});

  @override
  State<OnboardingPage> createState() => _OnboardingPageState();
}

class _OnboardingPageState extends State<OnboardingPage> {
  static final PageController _pageController = PageController(initialPage: 0);
  final List<Widget> _onboardingPages = [
    OnboardingCard(
      image: "assets/images/page1.png",
      title: 'Eat Healthy',
      description:
          'Maintaining good health should be the\nprimary focus of everyone',
      buttonText: 'Next',
      onPressed: (context) {
        _pageController.animateToPage(
          1,
          duration: Durations.medium2,
          curve: Curves.linear,
        );
      },
    ),
    OnboardingCard(
      image: "assets/images/page2.png",
      title: 'Healthy Recipes',
      description:
          'Browse hundreds of healthy recipes\nfrom all over Tamil Nadu',
      buttonText: 'Next',
      onPressed: (context) {
        _pageController.animateToPage(
          2,
          duration: Durations.medium2,
          curve: Curves.linear,
        );
      },
    ),
    OnboardingCard(
      image: "assets/images/page3.png",
      title: 'Track Your Progress',
      description: 'With amazing inbuilt tools you can\ntrack your progress',
      buttonText: 'Done',
      onPressed: (context) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => LoginPageEnterDetails()),
        );
      },
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.only(top: 10.0, bottom: 50.0),
        child: Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              child: PageView(
                controller: _pageController,
                children: _onboardingPages,
              ),
            ),
            SmoothPageIndicator(
              controller: _pageController,
              count: _onboardingPages.length,
              effect: ExpandingDotsEffect(
                activeDotColor: Color(0xffF93827),
                dotColor: Color(0xffFF9D23),
              ),
              onDotClicked: (index) {
                _pageController.animateToPage(
                  index,
                  duration: Durations.medium2,
                  curve: Curves.linear,
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
