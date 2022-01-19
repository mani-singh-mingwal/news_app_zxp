import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:news_app_zxp/bloc/category_news/category_news_bloc.dart';
import 'package:news_app_zxp/bloc/category_news/category_news_event.dart';
import 'package:news_app_zxp/bloc/category_news/category_news_state.dart';
import 'package:news_app_zxp/bloc/internet_cubit/internet_cubit.dart';
import 'package:news_app_zxp/bloc/internet_cubit/internet_state.dart';
import 'package:news_app_zxp/models/news_model.dart';

import '../widgets.dart';

class CategoryScreen extends StatefulWidget {
  const CategoryScreen({Key? key, required this.categoryName})
      : super(key: key);
  final String categoryName;

  @override
  State<CategoryScreen> createState() => _CategoryScreenState();
}

class _CategoryScreenState extends State<CategoryScreen> {
  List<Article> articles = [];

  @override
  void initState() {
    context
        .read<CategoryNewsBloc>()
        .add(FetchCategoryNews(categoryName: widget.categoryName));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            Text(
              "News",
              style: TextStyle(color: Colors.blue),
            ),
            Text(" App", style: TextStyle(color: Colors.white)),
            Opacity(
                opacity: 0,
                child: Text(" App", style: TextStyle(color: Colors.white)))
          ],
        ),
      ),
      body: BlocListener<InternetCubit, InternetState>(
        listener: (context, state) {
          if (state is InternetConnected) {
            context
                .read<CategoryNewsBloc>()
                .add(FetchCategoryNews(categoryName: widget.categoryName));
            debugPrint("Connected");
            ScaffoldMessenger.of(context).removeCurrentSnackBar();
          } else if (state is InternetDisconnected) {
            WidgetsBinding.instance!.addPostFrameCallback((timeStamp) {
              showSnackBar(context, message: "No connection");
            });
          }
        },
        child: Column(
          children: [
            BlocBuilder<CategoryNewsBloc, CategoryNewsState>(
              builder: (context, state) {
                if (state is CategoryNewsLoaded) {
                  return Expanded(
                    child: ListView.builder(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 16),
                      physics: const ClampingScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: state.articles.length,
                      itemBuilder: (context, index) {
                        return getBlogWidget(context, state.articles[index]);
                      },
                    ),
                  );
                } else if (state is CategoryNewsNotLoaded) {
                  return Expanded(child: _newsNotLoadedWidget());
                } else {
                  return const Expanded(
                    child: Center(
                      child: CircularProgressIndicator(),
                    ),
                  );
                }
              },
            )
          ],
        ),
      ),
    );
  }

  Widget _newsNotLoadedWidget() {
    return Container(
        alignment: Alignment.center,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: dataNotLoadedWidget(context));
  }
}
