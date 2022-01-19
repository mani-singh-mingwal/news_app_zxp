import 'package:equatable/equatable.dart';

class CategoryNewsEvent extends Equatable {
  @override
  // TODO: implement props
  List<Object?> get props => [];
}

class FetchCategoryNews extends CategoryNewsEvent {
  final String categoryName;

  FetchCategoryNews({required this.categoryName});

  @override
  // TODO: implement props
  List<Object?> get props => [categoryName];
}
