import 'dart:async';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:news_app_zxp/bloc/internet_cubit/internet_cubit.dart';
import 'package:news_app_zxp/bloc/internet_cubit/internet_state.dart';
import 'package:news_app_zxp/widgets.dart';
import 'package:webview_flutter/webview_flutter.dart';

class NewsDetail extends StatefulWidget {
  const NewsDetail({Key? key, required this.blogUrl}) : super(key: key);
  final String blogUrl;

  @override
  _NewsDetailState createState() => _NewsDetailState();
}

class _NewsDetailState extends State<NewsDetail> {
  final Completer<WebViewController> _controller =
  Completer<WebViewController>();
  late bool isLoading;
  final _key = UniqueKey();

  @override
  void initState() {
    isLoading = true;
    super.initState();
    if (Platform.isAndroid) WebView.platform = SurfaceAndroidWebView();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            Text(
              "News",
              style: TextStyle(color: Colors.blue),
            ),
            Text(
              " App",
              style: TextStyle(color: Colors.white),
            ),
            Opacity(
                opacity: 0,
                child: Text(" App", style: TextStyle(color: Colors.white))),
          ],
        ),
      ),
      body: BlocListener<InternetCubit, InternetState>(
        listener: (context, state) {
          if (state is InternetConnected) {
            debugPrint("Connected");
            ScaffoldMessenger.of(context).removeCurrentSnackBar();
            setState(() {});
          } else {
            showSnackBar(context, message: "No internet Connection");
          }
        },
        child: BlocBuilder<InternetCubit, InternetState>(
          builder: (context, state) {
            if (state is InternetConnected) {
              return Stack(
                children: [
                  WebView(
                    key: _key,
                    initialUrl: widget.blogUrl,
                    onWebViewCreated: (WebViewController webViewController) {
                      _controller.complete(webViewController);
                    },
                    onProgress: (int progress) {
                      debugPrint("WebView is loading (progress : $progress%");
                    },
                    gestureNavigationEnabled: false,
                    onPageFinished: (value) {
                      setState(() {
                        isLoading = false;
                      });
                    },
                  ),
                  isLoading
                      ? const Center(child: CircularProgressIndicator())
                      : Stack()
                ],
              );
            } else {
              return noInternetWidget(context, () {
                setState(() {

                });
              });
            }
          },
        ),
      ),
    );
  }
}
