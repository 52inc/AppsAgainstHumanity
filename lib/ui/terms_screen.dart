import 'dart:async';
import 'dart:convert';

import 'package:appsagainsthumanity/authentication_bloc/authentication_bloc.dart';
import 'package:appsagainsthumanity/internal.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:flutter/services.dart' show rootBundle;

class TermsOfServiceScreen extends StatefulWidget {
  @override
  _TermsOfServiceScreenState createState() => _TermsOfServiceScreenState();
}

class _TermsOfServiceScreenState extends State<TermsOfServiceScreen> {
  WebViewController webViewController;

  final StreamController<bool> _loadingStream = StreamController.broadcast();

  @override
  void initState() {
    super.initState();
    _loadingStream.onListen = () => _loadingStream.add(true);
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
        title: Text("Terms of service"),
      ),
      body: Stack(
        fit: StackFit.expand,
        children: [
          Container(
            child: WebView(
              onWebViewCreated: (controller) {
                webViewController = controller;
                _loadTermsOfServiceFromAssets();
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
              }
          ),

          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              width: double.maxFinite,
              margin: const EdgeInsets.all(16),
              child: RaisedButton(
                child: Text("I AGREE"),
                color: AppColors.secondary,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                onPressed: () {
                  context.bloc<AuthenticationBloc>()
                      .add(AgreeToTerms());
                },
              ),
            ),
          )
        ],
      ),
    );
  }

  void _loadTermsOfServiceFromAssets() async {
    var tosString = await rootBundle.loadString('assets/tos.html');
    var tosBase64 = base64Encode(const Utf8Encoder().convert(tosString));
    await webViewController.loadUrl('data:text/html;base64,$tosBase64');
    _loadingStream.add(false);
  }
}
