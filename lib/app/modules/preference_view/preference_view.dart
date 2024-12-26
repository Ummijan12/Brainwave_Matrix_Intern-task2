import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import '../home/views/home_view.dart';
import '../setting/controller/setting_controller.dart';

class PreferencesView extends StatelessWidget {
  PreferencesView({super.key});

  final SettingsController controller = Get.put(SettingsController());

  void savePreferences() async {
    HapticFeedback.mediumImpact();

    await controller.savePreferences();

    Get.offAll(() => HomeView(), transition: Transition.fade);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 1,
        title: const Text(
          'PERSONALIZE YOUR NEWS FEED',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            letterSpacing: 2,
            color: Colors.black87,
          ),
        ),
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Obx(() {
              return Container(
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(15),
                  border: Border.all(color: Colors.transparent),
                ),
                child: DropdownButtonFormField<String>(
                  value: controller.selectedLanguage.value,
                  decoration: InputDecoration(
                    labelText: 'SELECT LANGUAGE',
                    labelStyle: TextStyle(color: Colors.black87),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                      borderSide: BorderSide.none,
                    ),
                    filled: true,
                    fillColor: Colors.grey[200],
                  ),
                  dropdownColor: Colors.white,
                  items: controller.languages
                      .map((lang) => DropdownMenuItem(
                            value: lang['id'],
                            child: Row(
                              children: [
                                Text(lang['flag']!,
                                    style: const TextStyle(fontSize: 20)),
                                const SizedBox(width: 10),
                                Text(
                                  lang['name']!,
                                  style: const TextStyle(color: Colors.black87),
                                ),
                              ],
                            ),
                          ))
                      .toList(),
                  onChanged: (value) {
                    HapticFeedback.selectionClick();
                    controller.selectedLanguage.value = value!;
                  },
                ),
              );
            }),
          ),
          // Categories Selection
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: controller.categories.length,
              itemBuilder: (context, index) {
                final category = controller.categories[index];
                return Obx(() {
                  final isSelected =
                      controller.selectedCategories.contains(category['name']);
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: Container(
                      decoration: BoxDecoration(
                        color: isSelected
                            ? Colors.blue.withOpacity(0.1)
                            : Colors.grey[200],
                        borderRadius: BorderRadius.circular(15),
                        border: Border.all(
                          color: isSelected ? Colors.blue : Colors.grey[400]!,
                        ),
                      ),
                      child: CheckboxListTile(
                        title: Row(
                          children: [
                            Text(
                              category['icon']!,
                              style: const TextStyle(fontSize: 24),
                            ),
                            const SizedBox(width: 10),
                            Text(
                              category['name']!,
                              style: TextStyle(
                                color:
                                    isSelected ? Colors.blue : Colors.black87,
                                fontSize: 18,
                              ),
                            ),
                          ],
                        ),
                        value: isSelected,
                        activeColor: Colors.blue,
                        checkColor: Colors.white,
                        onChanged: (value) {
                          HapticFeedback.selectionClick();
                          controller.toggleCategory(category['name']!, value!);
                        },
                      ),
                    ),
                  );
                });
              },
            ),
          ),
          // Save Button
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: SizedBox(
              width: double.infinity,
              height: 60,
              child: Obx(() => controller.isLoading.value
                  ? const Center(
                      child: CircularProgressIndicator(),
                    )
                  : ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                      ),
                      onPressed: controller.selectedCategories.isEmpty
                          ? null
                          : savePreferences,
                      child: const Text(
                        'EXPLORE YOUR NEWS',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 2,
                          color: Colors.white,
                        ),
                      ),
                    )),
            ),
          ),
        ],
      ),
    );
  }
}
