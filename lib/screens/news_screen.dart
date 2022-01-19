import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:news_app_zxp/bloc/internet_cubit/internet_cubit.dart';
import 'package:news_app_zxp/bloc/internet_cubit/internet_state.dart';
import 'package:news_app_zxp/bloc/news/news_bloc.dart';
import 'package:news_app_zxp/bloc/news/news_event.dart';
import 'package:news_app_zxp/bloc/news/news_state.dart';
import 'package:news_app_zxp/data.dart';
import 'package:news_app_zxp/models/category_model.dart';
import 'package:news_app_zxp/widgets.dart';

class NewsScreen extends StatefulWidget {
  const NewsScreen({Key? key}) : super(key: key);

  @override
  State<NewsScreen> createState() => _NewsScreenState();
}

class _NewsScreenState extends State<NewsScreen> {
  List<CategoryModel> categories = getCategories();

  @override
  void initState() {
    context.read<NewsBloc>().add(FetchNews());
    super.initState();
  }

  AppBar appBar = AppBar(
    title: Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: const [
        Text(
          "News",
          style: TextStyle(color: Colors.blue),
        ),
        Text(" App", style: TextStyle(color: Colors.white)),
      ],
    ),
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar,
      body: BlocListener<InternetCubit, InternetState>(
        listener: (context, state) {
          if (state is InternetConnected) {
            context.read<NewsBloc>().add(FetchNews());
            debugPrint("Connected");
            ScaffoldMessenger.of(context).removeCurrentSnackBar();
          } else if (state is InternetDisconnected) {
            WidgetsBinding.instance!.addPostFrameCallback((timeStamp) {
              showSnackBar(context, message: "No connection");
            });
          }
        },
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            children: [
              Container(
                margin: const EdgeInsets.only(top: 16),
                height: 60,
                child: ListView.builder(
                    shrinkWrap: true,
                    scrollDirection: Axis.horizontal,
                    itemCount: categories.length,
                    itemBuilder: (context, index) {
                      return _categoryWidget(categories[index]);
                    }),
              ),
              Container(
                padding: const EdgeInsets.only(top: 16),
                child: BlocBuilder<NewsBloc, NewsState>(
                  builder: (context, state) {
                    if (state is NewsIsLoaded) {
                      return ListView.builder(
                        physics: const ClampingScrollPhysics(),
                        shrinkWrap: true,
                        itemCount: state.articles.length,
                        itemBuilder: (context, index) {
                          return getBlogWidget(context, state.articles[index]);
                        },
                      );
                    } else if (state is NewsIsNotLoaded) {
                      return _newsNotLoadedWidget();
                    } else {
                      double appBarHeight = appBar.preferredSize.height;

                      return Container(
                          alignment: Alignment.center,
                          height: MediaQuery.of(context).size.height -
                              appBarHeight -
                              92,
                          child: const CircularProgressIndicator());
                    }
                  },
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _categoryWidget(CategoryModel category) {
    debugPrint(category.categoryName);
    return GestureDetector(
      onTap: () {
        Navigator.of(context)
            .pushNamed("/category_screen", arguments: category.categoryName);
      },
      child: Container(
        padding: const EdgeInsets.only(right: 16),
        child: Stack(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(6),
              child: CachedNetworkImage(
                imageUrl: category.imageUrl!,
                width: 120,
                height: 60,
                fit: BoxFit.cover,
              ),
            ),
            Container(
              width: 120,
              height: 60,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(6),
                color: Colors.black26,
              ),
              alignment: Alignment.center,
              child: Text(
                category.categoryName.toString(),
                style: const TextStyle(
                    color: Colors.white, fontWeight: FontWeight.bold),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _newsNotLoadedWidget() {
    double appBarHeight = appBar.preferredSize.height;
    debugPrint("$appBarHeight");
    return Container(
      height: MediaQuery.of(context).size.height - appBarHeight - 92,
      alignment: Alignment.center,
      child: dataNotLoadedWidget(context),
    );
  }
}
