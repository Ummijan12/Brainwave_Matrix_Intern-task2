import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:news_reader/app/modules/home/controllers/news_controller.dart';
import 'package:news_reader/app/modules/splash/splash_screen.dart';
import 'app/modules/setting/controller/setting_controller.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Get.put(SettingsController());
  Get.put(NewsController());

  runApp(MyApp());
}

class MyApp extends StatefulWidget {

  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'News Reader',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home:  SplashView(),
    );
  }
}
