import 'package:flutter/material.dart';
import 'package:flutter_carousel_widget/flutter_carousel_widget.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../widgets/carsoul_news_card.dart';
import 'controller/feature_controller.dart';
import 'feature_news_list.dart';

class FeatureView extends StatelessWidget {
  FeatureView({super.key});
  final FeatureController _featureController = Get.put(FeatureController());
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.fromLTRB(20, 5, 10, 0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Featured Stories',
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              TextButton(
                onPressed: () {
                  Get.to(() => FeaturedNewsView());
                },
                style: TextButton.styleFrom(
                  foregroundColor: Color(0xFF6B8EFF),
                  textStyle: GoogleFonts.plusJakartaSans(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                child: Text('View All'),
              ),
            ],
          ),
        ),
        SizedBox(
          height: 180,
          width: double.infinity,
          child: Obx(() {
            if (_featureController.isLoading.value) {
              // Show a loading indicator while fetching data
              return const Center(
                child: CircularProgressIndicator(),
              );
            } else if (_featureController.newsList.isEmpty) {
              // Show a custom message if the API request limit is reached or no data is available
              return Center(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text(
                    '🚫 API limit reached! Please try again later.',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey[600],
                      fontWeight: FontWeight.w500,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              );
            } else {
              // Show the carousel with news articles
              return FlutterCarousel(
                items: _featureController.newsList
                    .map((article) => Container(
                          margin: const EdgeInsets.symmetric(horizontal: 5),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(24),
                            child: CarsoulNewsCard(article: article),
                          ),
                        ))
                    .toList(),
                options: FlutterCarouselOptions(
                  showIndicator: false,
                  autoPlay: true,
                  viewportFraction: 0.9,
                  aspectRatio: 16 / 9,
                  initialPage: 0,
                ),
              );
            }
          }),
        ),
      ],
    );
  }
}
