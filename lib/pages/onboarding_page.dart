import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:charity1/models/onboarding_model.dart';
import 'package:charity1/pages/home_page.dart';
import 'package:charity1/widgets/onboarding_presenter.dart';

class OnboardingPage extends StatelessWidget {
  const OnboardingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: OnboardingPagePresenter(
        pages: [
          OnboardingPageModel(
            title: 'Make a Real Impact',
            description: 'Your donations directly help the peterhead and local communities',
            imageUrl: 'https://i.ibb.co/cJqsPSB/scooter.png',
            bgColor: Colors.indigo,
          ),
          OnboardingPageModel(
            title: 'Join Our Community',
            description: 'Connect with thousands of changemakers and supporters like you.',
            imageUrl: 'https://i.ibb.co/LvmZypG/storefront-illustration-2.png',
            bgColor: const Color(0xff1eb090),
          ),
          OnboardingPageModel(
            title: 'Track Your Impact',
            description: 'See exactly how your contributions are transforming lives in Scotland.',
            imageUrl: 'https://i.ibb.co/420D7VP/building.png',
            bgColor: const Color(0xfffeae4f),
          ),
          OnboardingPageModel(
            title: 'Helping Together',
            description: 'Every donation matters. Join us in building a better tomorrow.',
            imageUrl: 'https://i.ibb.co/cJqsPSB/scooter.png',
            bgColor: Colors.purple,
          ),
        ],
        onFinish: () async {
          final prefs = await SharedPreferences.getInstance();
          await prefs.setBool('onboarding_complete', true);
          
          if (!context.mounted) return;
          Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(
              builder: (context) => const CharityHomePage(),
            ),
            (Route<dynamic> route) => false,
          );
        },
      ),
    );
  }
}
