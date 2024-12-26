class CategoriesNewsModel {
  String? status;
  int? totalResults;
  List<Articles>? articles;

  CategoriesNewsModel({this.status, this.totalResults, this.articles});

  CategoriesNewsModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    totalResults = json['totalResults'];
    if (json['articles'] != null) {
      articles = <Articles>[];
      json['articles'].forEach((v) {
        articles!.add( Articles.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data =  <String, dynamic>{};
    data['status'] = status;
    data['totalResults'] = totalResults;
    if (articles != null) {
      data['articles'] = articles!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Articles {
  Source? source;
  String? author;
  String? title;
  String? description;
  String? url;
  String? urlToImage;
  String? publishedAt;
  String? content;

  Articles({
    this.source,
    this.author,
    this.title,
    this.description,
    this.url,
    this.urlToImage,
    this.publishedAt,
    this.content,
  });

  Articles.fromJson(Map<String, dynamic> json) {
    source = json['source'] != null && json['source'] is Map<String, dynamic>
        ? Source.fromJson(json['source'])
        : null;
    author = json['author'] as String? ?? "Unknown Author";
    title = json['title'] as String? ?? "Untitled";
    description = json['description'] as String? ?? "No description available.";
    url = json['url'] as String? ?? "";
    urlToImage = json['urlToImage'] as String? ?? "";
    publishedAt = json['publishedAt'] as String? ?? "Unknown Date";
    content = json['content'] as String? ?? "Content not available.";
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (source != null) {
      data['source'] = source!.toJson();
    }
    data['author'] = author ?? "Unknown Author";
    data['title'] = title ?? "Untitled";
    data['description'] = description ?? "No description available.";
    data['url'] = url ?? "";
    data['urlToImage'] = urlToImage ?? "";
    data['publishedAt'] = publishedAt ?? "Unknown Date";
    data['content'] = content ?? "Content not available.";
    return data;
  }
}

class Source {
  String? id;
  String? name;

  Source({this.id, this.name});

  Source.fromJson(Map<String, dynamic> json) {
    id = json['id'] as String? ?? "Unknown ID";
    name = json['name'] as String? ?? "Unknown Source";
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id ?? "Unknown ID";
    data['name'] = name ?? "Unknown Source";
    return data;
  }
}