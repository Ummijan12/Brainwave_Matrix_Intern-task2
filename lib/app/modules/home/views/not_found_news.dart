import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'home_view.dart';

class NewsNotFoundView extends StatelessWidget {
  const NewsNotFoundView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Illustration
              Image.network(
                'https://cdn-icons-png.flaticon.com/512/4076/4076549.png',
                height: 200,
                width: 200,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Icon(Icons.error_outline, size: 100, color: Colors.redAccent);
                },
              ),
              const SizedBox(height: 24),
              // Title
              Text(
                'News Not Found',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              // Description
              Text(
                'We couldn’t find the news article you’re looking for. Please check the link or try again.',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey[600],
                  height: 1.5,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 32),
              // Back to Home Button
              ElevatedButton.icon(
                onPressed: () {
                  Get.offAll(()=> HomeView());
                },
                icon: const Icon(Icons.home, color: Colors.white),
                label: const Text(
                  'Back to Home',
                  style: TextStyle(fontSize: 16, color: Colors.white),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blueAccent,
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(24),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
