import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class WebScreen extends StatelessWidget {
  final String title;
  final String url;

  WebScreen({
    @required this.title,
    @required this.url,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
      ),
      body: Container(
        width: double.maxFinite,
        height: double.maxFinite,
        child: WebView(
          initialUrl: url,
        ),
      ),
    );
  }
}

void showWebView(BuildContext context, String title, String url) {
  Navigator.of(context).push(MaterialPageRoute(
      builder: (_) => WebScreen(
            title: title,
            url: url,
          )));
}
