import 'package:equatable/equatable.dart';
import 'package:news_app_zxp/models/news_model.dart';

class CategoryNewsState extends Equatable {
  @override
  // TODO: implement props
  List<Object?> get props => [];
}

class CategoryNewsLoading extends CategoryNewsState {}

class CategoryNewsLoaded extends CategoryNewsState {
  final List<Article> articles;

  CategoryNewsLoaded({required this.articles});
}

class CategoryNewsNotLoaded extends CategoryNewsState {}
