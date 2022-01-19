import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:news_app_zxp/models/news_model.dart';

class NewsRepository {
  Future<List<Article>> getNews() async {
    String url =
        "https://newsapi.org/v2/top-headlines?country=in&category=business&apiKey=33d7a236116f47bd85a4909eab9c7229";

    http.Response response;
    response = await http.get(Uri.parse(url));
    if (response.statusCode != 200) {
      throw Exception();
    }
    final jsonString = response.body;
    NewsModel newsModel = NewsModel.fromJson(json.decode(jsonString));
    debugPrint("$newsModel");
    List<Article> articles = newsModel.articles!;

    return _filterList(articles);
  }

  Future<List<Article>> getCategoryNews(String category) async {
    String url =
        "https://newsapi.org/v2/top-headlines?country=in&category=$category&apiKey=33d7a236116f47bd85a4909eab9c7229";

    http.Response response;
    response = await http.get(Uri.parse(url));
    if (response.statusCode != 200) {
      throw Exception();
    }
    final jsonString = response.body;
    NewsModel newsModel = NewsModel.fromJson(json.decode(jsonString));
    debugPrint("$newsModel");
    List<Article> articles = newsModel.articles!;
    return _filterList(articles);
  }

  List<Article> _filterList(List<Article> articles) {
    /// only add list element where image and title are not null and empty
    List<Article> articleList = [];
    articleList.clear();
    articleList.addAll(articles.where((article) =>
        article.urlToImage != null &&
        articles.isNotEmpty &&
        article.urlToImage.toString().toLowerCase() != "null" &&
        article.title != null &&
        article.title!.isNotEmpty &&
        article.title!.toLowerCase() != "null" &&
        article.description != null &&
        article.description!.isNotEmpty &&
        article.description!.toLowerCase() != "null"));

    return articleList;
  }
}
