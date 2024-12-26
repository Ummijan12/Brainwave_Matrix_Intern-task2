import 'package:get/get.dart';
import 'package:news_reader/app/modules/setting/controller/setting_controller.dart';
import '../../../data/models/news_model.dart';
import '../../../repository/news_repository.dart';

class NewsController extends GetxController {

  final NewsApiService _newsApiService = NewsApiService();
  final SettingsController controller = Get.find<SettingsController>();


  var newsList = <Articles>[].obs;
  final RxBool isLoading = false.obs;
  final int itemsPerPage = 30;
  var isRateLimited = false.obs;

  String language = "en";

  @override
  void onInit() async {
    super.onInit();
    fetchEverythingForCategories();
  }

  Future<void> fetchEverythingForCategories() async {
    if (isLoading.value) return;

    isLoading.value = true;
    isRateLimited.value = false;

    try {
      newsList.clear();

      for (final category in controller.selectedCategories) {
        final query = Uri.encodeComponent(category);

        print("Fetching articles for category: $query");

        final articles = await _newsApiService.fetchEverything(
          query: query,
          language: language,
          pageSize: itemsPerPage,
        );
        newsList.addAll(articles);
      }
    } catch (e) {
      if (e.toString().contains('Rate limit exceeded')) {
        isRateLimited.value = true;
      } else {
        print("error: $e");
        Get.snackbar("Error", "Something went wrong: $e");
      }
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> refreshArticles() async {
    newsList.clear();
    await fetchEverythingForCategories();
  }
}
