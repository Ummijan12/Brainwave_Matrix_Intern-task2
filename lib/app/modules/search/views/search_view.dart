import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../widgets/news_card.dart';
import '../controllers/search_controller.dart';

class SearchView extends StatelessWidget {
  final NewsSearchController searchController = Get.put(NewsSearchController());
  final TextEditingController queryController = TextEditingController();

  SearchView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Text(
          'Search News',
          style: GoogleFonts.plusJakartaSans(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black87),
          onPressed: () => Get.back(),
        ),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: TextField(
                controller: queryController,
                decoration: InputDecoration(
                  prefixIcon:
                      const Icon(Icons.search, color: Color(0xFF6B8EFF)),
                  hintText: 'Search for news, topics...',
                  hintStyle: GoogleFonts.plusJakartaSans(
                    color: Colors.grey.shade500,
                    fontSize: 16,
                  ),
                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.symmetric(vertical: 16),
                  suffixIcon: IconButton(
                    icon: const Icon(Icons.clear, color: Colors.grey),
                    onPressed: () {
                      queryController.clear();
                      searchController.clearResults();
                    },
                  ),
                ),
                onSubmitted: (query) {
                  if (query.isNotEmpty) {
                    searchController.searchNews(query);
                  }
                },
              ),
            ),
          ),
          Expanded(
            child: Obx(() {
              if (searchController.isLoading.value) {
                return const Center(
                  child: CircularProgressIndicator(
                    valueColor:
                        AlwaysStoppedAnimation<Color>(Color(0xFF6B8EFF)),
                  ),
                );
              }

              if (searchController.isRateLimited.value) {
                return Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.warning_amber_rounded,
                          size: 50, color: Colors.redAccent),
                      const SizedBox(height: 20),
                      Text(
                        'API Limit Reached',
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          color: Colors.black87,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        'You have exceeded the API request limit. Please try again later or consider upgrading your API plan.',
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 14,
                          color: Colors.grey.shade600,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                );
              }

              if (searchController.searchResults.isEmpty) {
                return Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.search, size: 50, color: Colors.grey),
                      const SizedBox(height: 20),
                      Text(
                        'No results found',
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          color: Colors.black87,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        'Try searching with different keywords.',
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 14,
                          color: Colors.grey.shade600,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                );
              }

              return ListView.builder(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                itemCount: searchController.searchResults.length,
                itemBuilder: (context, index) {
                  final article = searchController.searchResults[index];
                  return StylishNewsCard(
                    isCarousel: false,
                    newsItem: article,
                  );
                },
              );
            }),
          ),
        ],
      ),
    );
  }
}
