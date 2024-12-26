import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../data/models/news_model.dart';
import '../../../widgets/news_card.dart';
import '../../channels/views/channels_view.dart';
import '../../search/views/search_view.dart';
import '../../setting/setting_view.dart';
import '../controllers/news_controller.dart';
import 'feature_news/feature_view.dart';
import 'latest_news_view_list.dart';
import 'news_detail_view.dart';

class HomeView extends StatelessWidget {
  final NewsController newsController = Get.put(NewsController());

  HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        leading: Padding(
          padding: const EdgeInsets.only(left: 16),
          child: Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 10,
                  offset: Offset(0, 2),
                ),
              ],
            ),
            child: IconButton(
              icon: Icon(Icons.menu, color: Colors.black87),
              onPressed: () {
                Get.to(() => CategoryScreen());
              },
            ),
          ),
        ),
        title: Text(
          'Insight News',
          style: GoogleFonts.plusJakartaSans(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
        centerTitle: true,
        actions: [
          Container(
            margin: EdgeInsets.only(right: 8),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 10,
                  offset: Offset(0, 2),
                ),
              ],
            ),
            child: IconButton(
              onPressed: () => Get.to(() => SearchView()),
              icon: Icon(Icons.search, color: Colors.black87),
            ),
          ),
          Container(
            margin: EdgeInsets.only(right: 16),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 10,
                  offset: Offset(0, 2),
                ),
              ],
            ),
            child: IconButton(
              onPressed: () => Get.to(() => SettingsView()),
              icon: Icon(Icons.settings, color: Colors.black87),
            ),
          ),
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          FeatureView(),
          Padding(
            padding: EdgeInsets.fromLTRB(20, 5, 10, 0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Latest News',
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                TextButton(
                  onPressed: () {
                    Get.to(() => LatestNewsViewList());
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
          Expanded(
            child: Obx(() {
              if (newsController.isLoading.value &&
                  newsController.newsList.isEmpty) {
                return Center(
                  child: CircularProgressIndicator(
                    valueColor:
                        AlwaysStoppedAnimation<Color>(Color(0xFF6B8EFF)),
                  ),
                );
              }

              List<Articles> filteredNewsList = newsController.newsList
                  .where((news) => news.content != "[Removed]")
                  .toList();

              return RefreshIndicator(
                onRefresh: () async {
                  await newsController.fetchEverythingForCategories();
                },
                child: ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  itemCount: filteredNewsList.isEmpty
                      ? 1
                      : filteredNewsList.length + 1,
                  itemBuilder: (context, index) {
                    if (filteredNewsList.isEmpty) {
                      return Center(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 20),
                          child: Text(
                            'No news to display right now. Check back later!',
                            style: GoogleFonts.plusJakartaSans(
                              color: Colors.grey[600],
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      );
                    }
                    if (index == filteredNewsList.length) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 20),
                        child: Center(
                          child: newsController.isLoading.value
                              ? const CircularProgressIndicator(
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                      Color(0xFF6B8EFF)),
                                )
                              : Text(
                                  '✨ Awesome! You\'re all caught up! ✨',
                                  style: GoogleFonts.plusJakartaSans(
                                    color: Colors.grey[600],
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                        ),
                      );
                    }
                    final news = filteredNewsList[index];
                    return Container(
                      margin: const EdgeInsets.only(bottom: 16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(24),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.03),
                            blurRadius: 10,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Material(
                        color: Colors.transparent,
                        child: InkWell(
                          borderRadius: BorderRadius.circular(24),
                          onTap: () =>
                              Get.to(() => NewsDetailView(newsItem: news)),
                          child: StylishNewsCard(
                              isCarousel: false, newsItem: news),
                        ),
                      ),
                    );
                  },
                ),
              );
            }),
          ),
        ],
      ),
    );
  }
}
