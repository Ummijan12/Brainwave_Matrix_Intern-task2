import 'package:get/get.dart';
import 'package:news_reader/app/modules/setting/controller/setting_controller.dart';
import '../../../../../data/models/news_model.dart';
import '../../../../../repository/news_repository.dart';
import '../../../controllers/news_controller.dart';

class FeatureController extends GetxController {
  final NewsApiService _newsApiService = NewsApiService();
  final SettingsController settingsController = Get.find<SettingsController>();


  var newsList = <Articles>[].obs;
  final RxBool isLoading = false.obs;
  final RxBool hasMore = true.obs;

  int currentPage = 1;
  final int itemsPerPage = 20;

  String language = "en";
  String country = "us";

  @override
  void onInit() {
    super.onInit();
    fetchTopHeadlines();
  }

  Future<void> fetchTopHeadlines({String? category}) async {
    if (!hasMore.value) return;

    isLoading.value = true;
    try {
      //new
      for (final category in settingsController.selectedCategories) {
        final query = Uri.encodeComponent(category);

        print("Fetching articles for category: $query");

        final articles = await _newsApiService.featureNews(
          query: query,
          language: language,
          sortBy: 'popularity',
          page: currentPage,
        );
        print("lists ${articles.toString()}");
        newsList.addAll(articles);
        if (articles.isNotEmpty) {
          //newsList.addAll(articles);
        }
      }
      // final query = newsController.selectedCategories.isNotEmpty
      //     ? newsController.selectedCategories.join(" OR ")
      //     : (category ?? "general");
      //
      // final articles = await _newsApiService.featureNews(
      //   query: query,
      //   language: language,
      //   sortBy: 'popularity',
      //   page: currentPage,
      // );
      //
      // if (articles.isNotEmpty) {
      //   newsList.addAll(articles);
      //   if (articles.length < itemsPerPage) {
      //     hasMore.value = false;
      //   }
      //   currentPage++;
      // } else {
      //   hasMore.value = false;
      // }
    } catch (e) {
      print('Error fetching top headlines: $e');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> refreshArticles() async {
    newsList.clear();
    currentPage = 1;
    hasMore.value = true;
    await fetchTopHeadlines();
  }
}
