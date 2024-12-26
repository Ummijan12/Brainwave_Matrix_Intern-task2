import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:news_reader/app/modules/home/controllers/news_controller.dart';
import '../../../data/models/news_model.dart';
import '../../../widgets/news_card.dart';
import 'news_detail_view.dart';

class LatestNewsViewList extends StatelessWidget {
   LatestNewsViewList({super.key});
  final NewsController newsController = Get.find<NewsController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        leading: Container(
          margin: const EdgeInsets.only(left: 16),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 10,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.black87),
            onPressed: () => Get.back(),
          ),
        ),
        title: Text(
          'Latest Stories',
          style: GoogleFonts.plusJakartaSans(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
        centerTitle: true,
      ),
      body: Obx(() {
        if (newsController.isLoading.value && newsController.newsList.isEmpty) {
          return const Center(
            child: CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF6B8EFF)),
            ),
          );
        }

        List<Articles> featuredNews = newsController.newsList
            .where((news) => news.content != "[Removed]")
            .toList();

        if (featuredNews.isEmpty) {
          return Center(
            child: Text(
              'No Latest stories available.',
              style: GoogleFonts.plusJakartaSans(
                fontSize: 18,
                color: Colors.black54,
              ),
            ),
          );
        }

        return RefreshIndicator(
          onRefresh: newsController.refreshArticles,
          child: ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: featuredNews.length,
            itemBuilder: (context, index) {
              final news = featuredNews[index];
              return GestureDetector(
                onTap: () => Get.to(() => NewsDetailView(newsItem: news)),
                child: StylishNewsCard(newsItem: news, isCarousel: false),
              );
            },
          ),
        );
      }),
    );
  }
}
