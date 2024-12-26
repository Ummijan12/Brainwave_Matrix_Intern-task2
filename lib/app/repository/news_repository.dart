import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:news_reader/app/data/models/sources_model.dart';

import '../data/models/news_model.dart';

class NewsApiService {
  static const String _baseUrl = 'https://newsapi.org/v2';
  static const String _apiKey = 'bba246da10c449f8a806ff175631fbb6';
  static const String _apiKey2 = '082638e54ee84eeca63ce58029c43dfc';

  String _currentApiKey = _apiKey;

  Future<List<Articles>> fetchEverything({
    String query = 'general',
    String language = 'en',
    int page = 1,
    int pageSize = 10,
  }) async {
    final url = Uri.parse(
      '$_baseUrl/everything?q=$query&language=$language&sortBy=popularity&page=$page&pageSize=$pageSize&apiKey=$_currentApiKey',
    );

    final response = await http.get(url);

    if (response.statusCode == 200) {
      final body = jsonDecode(response.body);
      final articles = (body['articles'] as List)
          .map((article) => Articles.fromJson(article))
          .toList();
      return articles;
    } else if (response.statusCode == 429) {
      _currentApiKey = _currentApiKey == _apiKey ? _apiKey2 : _apiKey;
      throw Exception('Rate limit exceeded: ${response.body}');
    } else {
      throw Exception('Failed to fetch news: ${response.body}');
    }
  }

  Future<List<Articles>> fetchNewsByDomain({
    required String domains,
    String language = 'en',
    int pageSize = 20,
  }) async {
    final url = Uri.parse(
      'https://newsapi.org/v2/everything?sources=${domains}&apiKey=$_currentApiKey',
    );

    print("run fe");
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final body = jsonDecode(response.body);
      final articles = (body['articles'] as List)
          .map((article) => Articles.fromJson(article))
          .toList();
      print("ar ${articles.toString()}");
      return articles;
    } else if (response.statusCode == 429) {
      _currentApiKey = _currentApiKey == _apiKey ? _apiKey2 : _apiKey;
      throw Exception('Rate limit exceeded: ${response.body}');
    } else {
      throw Exception('Failed to fetch news: ${response.body}');
    }
  }

  Future<List<Articles>> fetchTopHeadlines({
    String? category,
    String country = 'us',
    int page = 1,
    int pageSize = 20,
  }) async {
    final url = Uri.parse(
      '$_baseUrl/top-headlines?apiKey=$_currentApiKey&country=$country&category=${category ?? ''}&page=$page&pageSize=$pageSize',
    );

    final response = await http.get(url);

    if (response.statusCode == 200) {
      final body = jsonDecode(response.body);
      print("pr ${body}");
      final articles = (body['articles'] as List)
          .map((article) => Articles.fromJson(article))
          .toList();
      return articles;
    } else if (response.statusCode == 429) {
      _currentApiKey = _currentApiKey == _apiKey ? _apiKey2 : _apiKey;
      throw Exception('Rate limit exceeded: ${response.body}');
    } else {
      throw Exception('Failed to load top headlines: ${response.body}');
    }
  }

  Future<List<Articles>> featureNews({
    required String query,
    String language = 'en',
    String sortBy = 'popularity',
    int page = 1,
    int pageSize = 30,
  }) async {
    print("run");
    final url = Uri.parse(
      '$_baseUrl/top-headlines?language=$language&sortBy=$sortBy&page=$page&pageSize=$pageSize&apiKey=$_currentApiKey',
    );

    final response = await http.get(url);

    if (response.statusCode == 200) {
      print("connected");
      final body = jsonDecode(response.body);
      final articles = (body['articles'] as List)
          .map((article) => Articles.fromJson(article))
          .toList();
      print(articles.length);
      return articles;
    } else if (response.statusCode == 429) {
      _currentApiKey = _currentApiKey == _apiKey ? _apiKey2 : _apiKey;

      throw Exception('Rate limit exceeded: ${response.body}');
    } else {
      print("error");
      throw Exception('Failed to fetch news: ${response.body}');
    }
  }

  Future<List<SourceModel>> sourcesNews({
    required String category,
  }) async {
    final url = Uri.parse(
      '$_baseUrl/top-headlines/sources?category=$category&apiKey=$_currentApiKey',
    );

    final response = await http.get(url);

    if (response.statusCode == 200) {
      print("connected");
      final body = jsonDecode(response.body);
      final articles = (body['sources'] as List)
          .map((article) => SourceModel.fromJson(article))
          .toList();
      print("souces ${articles.length}");
      return articles;
    } else if (response.statusCode == 429) {
      _currentApiKey = _currentApiKey == _apiKey ? _apiKey2 : _apiKey;
      throw Exception('Rate limit exceeded: ${response.body}');
    } else {
      print("error");
      throw Exception('Failed to fetch news: ${response.body}');
    }
  }

  Future<List<Articles>> searchNews({
    required String query,
    String language = 'en',
    String sortBy = 'popularity',
  }) async {
    final url = Uri.parse(
      '$_baseUrl/everything?apiKey=$_currentApiKey&q=${Uri.encodeQueryComponent(query)}&language=$language&sortBy=$sortBy',
    );

    final response = await http.get(url);

    if (response.statusCode == 200) {
      final body = jsonDecode(response.body);
      final articles = (body['articles'] as List)
          .map((article) => Articles.fromJson(article))
          .toList();
      return articles;
    } else if (response.statusCode == 429) {
      _currentApiKey = _currentApiKey == _apiKey ? _apiKey2 : _apiKey;
      throw Exception('Rate limit exceeded: ${response.body}');
    } else {
      throw Exception('Failed to search news: ${response.body}');
    }
  }

  bool hasMorePages(int currentPage, int itemsPerPage, int totalResults) {
    return currentPage * itemsPerPage < totalResults;
  }
}
