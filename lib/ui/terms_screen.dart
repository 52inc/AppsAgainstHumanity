import 'dart:async';

import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:appsagainsthumanity/authentication_bloc/authentication_bloc.dart';
import 'package:appsagainsthumanity/internal.dart';
import 'package:easy_web_view/easy_web_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:webview_flutter/webview_flutter.dart';

class TermsOfServiceScreen extends StatefulWidget {
  @override
  _TermsOfServiceScreenState createState() => _TermsOfServiceScreenState();
}

class _TermsOfServiceScreenState extends State<TermsOfServiceScreen> {
  late WebViewController webViewController;

  final StreamController<bool> _loadingStream = StreamController.broadcast();

  @override
  void initState() {
    super.initState();
    _loadingStream.onListen = () => _loadingStream.add(kIsWeb ? false : true);
  }

  @override
  void dispose() {
    _loadingStream.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // brightness: Brightness.dark,
        // textTheme: context.theme.textTheme,
        iconTheme: context.theme.iconTheme,
        title: Text("Terms of service"),
      ),
      body: Stack(
        fit: StackFit.expand,
        children: [
          Container(
            margin: EdgeInsets.only(bottom: kIsWeb ? 88 : 0),
            child: EasyWebView(
              src: Config.termsOfServiceUrl,
              isHtml: false,
              isMarkdown: false,
              convertToWidgets: false,
              widgetsTextSelectable: false,
              onLoaded: () {
                _loadingStream.add(false);
              },
            ),
          ),
          StreamBuilder<bool>(
              stream: _loadingStream.stream,
              builder: (context, snapshot) {
                if (snapshot.data ?? false) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Container(
                        child: CircularProgressIndicator(),
                      ),
                    ],
                  );
                } else {
                  return Container();
                }
              }),
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              width: double.maxFinite,
              margin: const EdgeInsets.all(16),
              child: ElevatedButton(
                child: Text("I AGREE"),
                style: ElevatedButton.styleFrom(
                  primary: context.primaryColor,
                  elevation: 4,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                onPressed: () {
                  Analytics().logSelectContent(
                      contentType: 'action', itemId: "terms_of_service");
                  context.bloc<AuthenticationBloc>().add(AgreeToTerms());
                },
              ),
            ),
          )
        ],
      ),
    );
  }

  void _loadTermsOfServiceFromUrl() async {
    await webViewController.loadUrl(Config.termsOfServiceUrl);
    _loadingStream.add(false);
  }
}
