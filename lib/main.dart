import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:news_app_zxp/repository/news_repository.dart';
import 'package:news_app_zxp/screens/category_screen.dart';
import 'package:news_app_zxp/screens/news_detail.dart';
import 'package:news_app_zxp/screens/news_screen.dart';

import 'bloc/category_news/category_news_bloc.dart';
import 'bloc/category_news/category_news_state.dart';
import 'bloc/internet_cubit/internet_cubit.dart';
import 'bloc/internet_cubit/internet_state.dart';
import 'bloc/news/news_bloc.dart';
import 'bloc/news/news_state.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual,
      overlays: [SystemUiOverlay.bottom, SystemUiOverlay.top]);
  runApp(MyApp(
    connectivity: Connectivity(),
    newsRepository: NewsRepository(),
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({
    Key? key,
    required this.connectivity,
    required this.newsRepository,
  }) : super(key: key);
  final NewsRepository newsRepository;
  final Connectivity connectivity;

  @override
  Widget build(BuildContext context) {
    return BlocProvider<InternetCubit>(
      create: (context) =>
          InternetCubit(InternetLoading(), connectivity: connectivity),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
            primaryColor: Colors.white,
            appBarTheme: const AppBarTheme(backgroundColor: Colors.black)),
        routes: {
          "/": (context) => BlocProvider<NewsBloc>(
              create: (context) =>
                  NewsBloc(NewsIsLoading(), newsRepository: newsRepository),
              child: const NewsScreen()),
          "/category_screen": (context) {
            String args = ModalRoute.of(context)!.settings.arguments as String;

            return BlocProvider<CategoryNewsBloc>(
                create: (context) => CategoryNewsBloc(CategoryNewsLoading(),
                    newsRepository: newsRepository),
                child: CategoryScreen(categoryName: args));
          },
          "/news_detail": (context) {
            var blogUrl = ModalRoute.of(context)!.settings.arguments as String;
            return NewsDetail(blogUrl: blogUrl);
          },
        },
      ),
    );
  }
}
