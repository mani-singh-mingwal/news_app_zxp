import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'models/news_model.dart';

Widget getBlogWidget(BuildContext context, Article article) => GestureDetector(
      onTap: () {
        Navigator.of(context)
            .pushNamed("/news_detail", arguments: article.url!);
      },
      child: Container(
        margin: const EdgeInsets.only(
          bottom: 16,
        ),
        child: Column(
          children: [
            ClipRRect(
                borderRadius: BorderRadius.circular(6),
                child: CachedNetworkImage(
                    imageUrl: article.urlToImage.toString(),
                    width: MediaQuery.of(context).size.width,
                    height: 230,
                    fit: BoxFit.cover)),
            verticalSpace(height: 12),
            Text(
              article.title.toString(),
              textAlign: TextAlign.left,
              style: const TextStyle(
                  fontSize: 20,
                  overflow: TextOverflow.ellipsis,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87),
              maxLines: 2,
            ),
            verticalSpace(height: 4),
            Text(
              "${article.description}",
              maxLines: 3,
              textAlign: TextAlign.left,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(color: Colors.black54),
            ),
          ],
        ),
      ),
    );

Widget dataNotLoadedWidget(BuildContext context) => RichText(
    textAlign: TextAlign.center,
    text: TextSpan(style: const TextStyle(color: Colors.blue), children: [
      TextSpan(
        text: "something went wrong.\n",
        style:
            Theme.of(context).textTheme.headline6!.copyWith(color: Colors.blue),
      ),
      const TextSpan(
        text:
            "we are currently doing site maintenance on this app. Please come back later.",
      ),
    ]));

Widget noInternetWidget(BuildContext context, onPressed) => Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(
            "images/ic_no_connection.png",
            width: 50,
            height: 50,
          ),
          const Text(
            "No internet Connection",
            style: TextStyle(color: Colors.blue),
          ),
          MaterialButton(
              child: const Text(
                "Refresh",
                style: TextStyle(color: Colors.green),
              ),
              onPressed: onPressed)
        ],
      ),
    );

Widget verticalSpace({double? height = 8.0}) => SizedBox(
      height: height,
    );

Widget appBarWidget(BuildContext context) => AppBar(
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
    );

ScaffoldFeatureController showSnackBar(BuildContext context,
        {required String message}) =>
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(
      message,
      textAlign: TextAlign.center,
    )));

loader(BuildContext context) => Center(child: CircularProgressIndicator());
