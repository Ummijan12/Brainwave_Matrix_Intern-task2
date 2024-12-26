import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../home/views/home_view.dart';

class SettingsController extends GetxController {

  RxList<String> selectedCategories = <String>[].obs;
  RxString selectedLanguage = "en".obs;
  final RxBool isLoading = false.obs;

  final List<Map<String, String>> categories = [
    {'id': '6', 'name': 'General', 'icon': '🌐'},
    {'id': '1', 'name': 'Technology', 'icon': '🎮'},
    {'id': '2', 'name': 'Sports', 'icon': '🏆'},
    {'id': '3', 'name': 'Health', 'icon': '❤️'},
    {'id': '4', 'name': 'Entertainment', 'icon': '🎬'},
    {'id': '5', 'name': 'Business', 'icon': '💼'},
  ];

  final List<Map<String, String>> languages = [
    {'id': 'en', 'name': 'English', 'flag': '🇺🇸'},
    {'id': 'es', 'name': 'Spanish', 'flag': '🇪🇸'},
    {'id': 'fr', 'name': 'French', 'flag': '🇫🇷'},
    {'id': 'de', 'name': 'German', 'flag': '🇩🇪'},
    {'id': 'zh', 'name': 'Chinese', 'flag': '🇨🇳'},
  ];

  @override
  void onInit() {
    super.onInit();
    loadPreferences();
  }

  void loadPreferences() async {
    final prefs = await SharedPreferences.getInstance();
    selectedCategories.addAll(prefs.getStringList('selectedCategories') ?? []);
    selectedLanguage.value = prefs.getString('selectedLanguage') ?? 'en';
  }

  Future<void> savePreferences() async {
    if (selectedCategories.isEmpty) {
      Get.snackbar(
        'No Categories Selected',
        'Please select at least one category to proceed.',
        backgroundColor: Colors.redAccent.withOpacity(0.7),
        colorText: Colors.white,
        duration: const Duration(seconds: 2),
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }
    HapticFeedback.mediumImpact();
    isLoading.value = true;

    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList('selectedCategories', selectedCategories);
    await prefs.setString('selectedLanguage', selectedLanguage.value);

    isLoading.value = false;

    Get.offAll(() => HomeView(), transition: Transition.fade);

    Get.snackbar(
      'Settings Saved',
      'Your preferences have been updated',
      backgroundColor: Get.theme.primaryColor.withOpacity(0.7),
      colorText: Get.theme.colorScheme.onPrimary,
      duration: const Duration(seconds: 2),
      snackPosition: SnackPosition.BOTTOM,
    );
  }

  void toggleCategory(String categoryName, bool value) {
    if (value) {
      selectedCategories.add(categoryName);
    } else {
      selectedCategories.remove(categoryName);
    }
  }

  void resetSettings() {
    selectedCategories.clear();
    selectedCategories.add('general');
    selectedLanguage.value = 'en';
    savePreferences();
  }
}
