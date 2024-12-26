import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../widgets/news_card.dart';
import '../../home/views/news_detail_view.dart';
import '../controllers/channels_controller.dart';

class NewsListDomain extends StatefulWidget {
  final String domain;

  const NewsListDomain({super.key, required this.domain});

  @override
  State<NewsListDomain> createState() => _NewsListDomainState();
}

class _NewsListDomainState extends State<NewsListDomain> {
  final CategoryController controller = Get.put(CategoryController());

  @override
  void initState() {
    super.initState();
    controller.fetchNews(widget.domain);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.domain),
      ),
      body: Obx(() {
        if (controller.isLoadingForDomain.value &&
            controller.articles.isEmpty) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        return RefreshIndicator(
          onRefresh: () async {
            controller.resetPagination();
            await controller.fetchNews(widget.domain);
          },
          child: ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            itemCount: controller.articles.length + 1,
            itemBuilder: (context, index) {
              // Handle empty state
              if (controller.articles.isEmpty) {
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

              // Handle loading indicator at the end of the list
              if (index == controller.articles.length) {
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 20),
                  child: Center(
                    child: controller.isLoadingForDomain.value
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

              // Render news card
              final news = controller.articles[index];
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
                    onTap: () => Get.to(() => NewsDetailView(newsItem: news)),
                    child: StylishNewsCard(isCarousel: false, newsItem: news),
                  ),
                ),
              );
            },
          ),
        );
      }),
    );
  }
}
