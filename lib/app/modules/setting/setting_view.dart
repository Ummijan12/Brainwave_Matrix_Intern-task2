import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'controller/setting_controller.dart';

class SettingsView extends GetView<SettingsController> {
  const SettingsView({super.key});

  Widget _buildSettingSection({required String title, required Widget child}) {
    return Container(
      margin: EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.05),
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: Colors.purple.withOpacity(0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.all(16),
            child: Text(
              title,
              style: TextStyle(
                color: Colors.black,
                fontSize: 18,
                fontWeight: FontWeight.bold,
                letterSpacing: 1.5,
              ),
            ),
          ),
          child,
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(
          'SETTINGS',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            letterSpacing: 2,
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(Icons.save_outlined),
            onPressed: () {
              HapticFeedback.mediumImpact();
              controller.savePreferences();
            },
          ),
        ],
      ),
      body: ListView(
        padding: EdgeInsets.all(16),
        children: [
          _buildSettingSection(
            title: 'LANGUAGE',
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Obx(() => DropdownButtonFormField<String>(
                    value: controller.selectedLanguage.value,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15),
                        borderSide:
                            BorderSide(color: Colors.purple.withOpacity(0.3)),
                      ),
                      filled: true,
                      fillColor: Colors.black.withOpacity(0.2),
                    ),
                    items: controller.languages
                        .map((lang) => DropdownMenuItem(
                              value: lang['id'],
                              child: Row(
                                children: [
                                  Text(lang['flag']!,
                                      style: TextStyle(fontSize: 20)),
                                  SizedBox(width: 10),
                                  Text(lang['name']!),
                                ],
                              ),
                            ))
                        .toList(),
                    onChanged: (value) {
                      HapticFeedback.selectionClick();
                      controller.selectedLanguage.value = value!;
                    },
                  )),
            ),
          ),

          _buildSettingSection(
            title: 'CONTENT PREFERENCES',
            child: ListView.builder(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemCount: controller.categories.length,
              itemBuilder: (context, index) {
                final category = controller.categories[index];
                return Obx(() => SwitchListTile(
                      title: Row(
                        children: [
                          Text(category['icon']!,
                              style: TextStyle(fontSize: 20)),
                          SizedBox(width: 10),
                          Text(
                            category['name']!,
                          ),
                        ],
                      ),
                      value: controller.selectedCategories
                          .contains(category['name']),
                      activeColor: Colors.purple,
                      onChanged: (bool value) {
                        HapticFeedback.selectionClick();
                        controller.toggleCategory(category['name']!, value);
                      },
                    ));
              },
            ),
          ),

          // Reset Button
          Padding(
            padding: EdgeInsets.only(top: 16),
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red.withOpacity(0.3),
                padding: EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
              ),
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: Text('Reset Settings?'),
                    content: Text(
                        'This will restore all settings to their default values.'),
                    actions: [
                      TextButton(
                        child: Text('Cancel'),
                        onPressed: () => Navigator.pop(context),
                      ),
                      TextButton(
                        child: Text('Reset'),
                        onPressed: () {
                          controller.resetSettings();
                          Navigator.pop(context);
                        },
                      ),
                    ],
                  ),
                );
              },
              child: Text(
                'RESET ALL SETTINGS',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 2,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
