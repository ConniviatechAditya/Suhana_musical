import 'package:dtpocketfm/utils/color.dart';
import 'package:dtpocketfm/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class CommonPage extends StatefulWidget {
  final String url, title;
  const CommonPage({super.key, required this.url, required this.title});

  @override
  State<CommonPage> createState() => CommonPageState();
}

class CommonPageState extends State<CommonPage> {
  late final WebViewController controller;
  @override
  void initState() {
    super.initState();
    controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(colorPrimaryDark)
      ..setNavigationDelegate(
        NavigationDelegate(
          onProgress: (int progress) {},
          onPageStarted: (String url) {},
          onPageFinished: (String url) {},
          onWebResourceError: (WebResourceError error) {
            debugPrint(
                '''Page resource error:code: ${error.errorCode}description: ${error.description}errorType: ${error.errorType}isForMainFrame: ${error.isForMainFrame}
          ''');
          },
        ),
      )
      ..loadRequest(Uri.parse(widget.url));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: colorPrimaryDark,
      appBar: Utils().myappbar("ic_back.png", widget.title, () {
        Navigator.pop(context, false);
      }),
      body: WebViewWidget(controller: controller),
    );
  }
}
