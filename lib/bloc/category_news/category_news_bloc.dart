import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:news_app_zxp/bloc/category_news/category_news_event.dart';
import 'package:news_app_zxp/bloc/category_news/category_news_state.dart';
import 'package:news_app_zxp/models/news_model.dart';
import 'package:news_app_zxp/repository/news_repository.dart';

class CategoryNewsBloc extends Bloc<CategoryNewsEvent, CategoryNewsState> {
  NewsRepository newsRepository;

  CategoryNewsBloc(CategoryNewsState initialState,
      {required this.newsRepository})
      : super(CategoryNewsLoading()) {
    on<FetchCategoryNews>((event, emit) async {
      List<Article> articles = [];
      articles.clear();
      emit(CategoryNewsLoading());
      try {
        articles = await newsRepository.getCategoryNews(event.categoryName);
        emit(CategoryNewsLoaded(articles: articles));
      } catch (e) {
        emit(CategoryNewsNotLoaded());
      }
    });
  }
}
