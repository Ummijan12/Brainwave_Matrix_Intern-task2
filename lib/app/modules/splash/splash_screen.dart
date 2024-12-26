import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:simple_gradient_text/simple_gradient_text.dart';
import '../home/views/home_view.dart';
import '../preference_view/preference_view.dart';
import '../setting/controller/setting_controller.dart';

class SplashView extends StatefulWidget {
  const SplashView({super.key});

  @override
  State<SplashView> createState() => _SplashViewState();
}

class _SplashViewState extends State<SplashView> {
  final SettingsController controller = Get.put(SettingsController());

  @override
  void initState() {
    Future.delayed(const Duration(seconds: 2), () {
      controller.selectedCategories.isEmpty
          ? Get.offAll(() => PreferencesView())
          : Get.offAll(() => HomeView());
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      child: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Insight",
                  style: TextStyle(
                    fontSize: 42,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                GradientText(
                  "News",
                  style: TextStyle(
                    letterSpacing: -0.5,
                    fontSize: 42,
                    fontWeight: FontWeight.w800,
                  ),
                  colors: [
                    Color(0XFFFF2E00),
                    Color(0XFFC714D7),
                    Color(0XFF3F0E70),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 30),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 40),
              child: Text(
                'Your Personalized News Companion',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w500,
                  color: Colors.black87,
                ),
              ),
            ),
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 40),
              child: Text(
                'Stay ahead with real-time news, personalized insights, and curated stories that matter. '
                'Discover, learn, and engage with the world at your fingertips.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w300,
                  height: 1.5,
                  color: Colors.black54,
                ),
              ),
            ),
            const SizedBox(height: 50),
            LoadingAnimationWidget.waveDots(
              color: Color(0XFFFF2E00),
              size: 50,
            ),
            const SizedBox(height: 20),
            Text(
              'Powering Your Information Journey',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w300,
                color: Colors.black45,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
