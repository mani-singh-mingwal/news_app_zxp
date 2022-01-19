import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:news_app_zxp/bloc/news/news_state.dart';
import 'package:news_app_zxp/models/news_model.dart';
import 'package:news_app_zxp/repository/news_repository.dart';

import 'news_event.dart';

class NewsBloc extends Bloc<NewsEvent, NewsState> {
  NewsRepository newsRepository;

  NewsBloc(initialState, {required this.newsRepository})
      : super(NewsIsLoading()) {
    on<FetchNews>((event, emit) async {
      List<Article> articles = [];
      emit(NewsIsLoading());
      try {
        articles = await newsRepository.getNews();
        emit(NewsIsLoaded(articles: articles));
      } catch (e) {
        debugPrint("Exception $e");
        emit(NewsIsNotLoaded());
      }
    });
  }
}
