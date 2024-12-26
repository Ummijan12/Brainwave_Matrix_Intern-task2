import 'package:get/get.dart';
import '../../../data/models/news_model.dart';
import '../../../repository/news_repository.dart';
import '../../home/controllers/news_controller.dart';

class NewsSearchController extends GetxController {
  final NewsApiService _newsApiService = NewsApiService();
  final NewsController newsController = Get.put(NewsController());

  RxList<Articles> searchResults = <Articles>[].obs;
  RxBool isLoading = false.obs;
  var isRateLimited = false.obs;

  Future<void> searchNews(String query) async {
    if (query.isEmpty) return;

    isLoading.value = true;
    try {
      final articles = await _newsApiService.searchNews(
          query: query, language: newsController.language);
      searchResults.assignAll(articles);
    } catch (e) {
      isRateLimited.value = true;
      print('Error searching news: $e');
      searchResults.clear();
    } finally {
      isLoading.value = false;
    }
  }

  void clearResults() {
    searchResults.clear();
  }
}
