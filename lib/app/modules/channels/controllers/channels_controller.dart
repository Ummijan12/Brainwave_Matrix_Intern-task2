import 'package:get/get.dart';
import 'package:news_reader/app/data/models/sources_model.dart';
import '../../../data/models/news_model.dart';
import '../../../repository/news_repository.dart';

class CategoryController extends GetxController {
  final NewsApiService _newsApiService = NewsApiService();

  var soucesListBusiness = <SourceModel>[].obs;
  var soucesListSport = <SourceModel>[].obs;
  var soucesListGeneral = <SourceModel>[].obs;
  var soucesListTechnology = <SourceModel>[].obs;
  var soucesListEntertainment = <SourceModel>[].obs;
  var soucesListScience = <SourceModel>[].obs;
  final RxBool isLoading = false.obs;
  var isRateLimited = false.obs;

  final RxList<Articles> articles = <Articles>[].obs;
  final RxBool isLoadingForDomain = false.obs;

  final int itemsPerPage = 20;

  Future<void> fetchSources(String category) async {
    if (category == "business") {
      soucesListBusiness.clear();
    } else if (category == "sports") {
      soucesListSport.clear();
    }

    isLoading.value = true;
    try {
      final articles = await _newsApiService.sourcesNews(category: category);

      if (category == "business") {
        soucesListBusiness.addAll(articles);
      } else if (category == "sports") {
        soucesListSport.addAll(articles);
      } else if (category == "general") {
        soucesListGeneral.addAll(articles);
      } else if (category == "technology") {
        soucesListTechnology.addAll(articles);
      } else if (category == "science") {
        soucesListScience.addAll(articles);
      } else if (category == "entertainment") {
        soucesListEntertainment.addAll(articles);
      }
    } catch (e) {
      isRateLimited.value = true;
      print('Error fetching sources for $category: $e');
    } finally {
      isLoading.value = false;
    }
  }

  void loadNews() {
    if (soucesListBusiness.isEmpty) {
      fetchSources("business");
    }
    if (soucesListSport.isEmpty) {
      fetchSources("sports");
    }
    if (soucesListGeneral.isEmpty) {
      fetchSources("general");
    }
    if (soucesListTechnology.isEmpty) {
      fetchSources("technology");
    }
    if (soucesListEntertainment.isEmpty) {
      fetchSources("entertainment");
    }
    if (soucesListScience.isEmpty) {
      fetchSources("science");
    }
  }

  Future<void> fetchNews(String domain) async {
    if (isLoadingForDomain.value) return;
    articles.clear();
    isLoadingForDomain.value = true;
    isRateLimited.value = false;

    print("dom ${domain}");
    try {
      if (domain.isEmpty) {
        throw Exception("No domain selected");
      }

      final fetchedArticles = await _newsApiService.fetchNewsByDomain(
        domains: domain,
        pageSize: itemsPerPage,
      );

      articles.addAll(fetchedArticles);
    } catch (e) {
      if (e.toString().contains('Rate limit exceeded')) {
        isRateLimited.value = true;
      } else {
        print("Error: $e");
        Get.snackbar("Error", "Something went wrong: $e");
      }
    } finally {
      isLoadingForDomain.value = false;
    }
  }

  void resetPagination() {
    articles.clear();
  }
}
