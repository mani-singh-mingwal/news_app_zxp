import 'package:equatable/equatable.dart';
import 'package:news_app_zxp/models/news_model.dart';

class NewsState extends Equatable {
  @override
  // TODO: implement props
  List<Object?> get props => [];
}

class NewsIsLoading extends NewsState {}

class NewsIsLoaded extends NewsState {
  List<Article> articles;

  NewsIsLoaded({required this.articles});

  @override
  // TODO: implement props
  List<Object?> get props => [articles];
}

class NewsIsNotLoaded extends NewsState {}
