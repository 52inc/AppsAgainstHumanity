import 'dart:io';

import 'package:apple_sign_in/apple_sign_in.dart';
import 'package:appsagainsthumanity/ui/signin/bloc/bloc.dart';
import 'package:device_info/device_info.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AppleSignIn extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _AppleSignInState();
}

class _AppleSignInState extends State<AppleSignIn> {
  bool _supportsAppleSignIn = false;

  @override
  void initState() {
    super.initState();
    _checkCanSignInWithApple();
  }

  @override
  Widget build(BuildContext context) {
    if (_supportsAppleSignIn) {
      return AppleSignInButton(
        style: ButtonStyle.whiteOutline,
        type: ButtonType.signIn,
        onPressed: () {
          context.bloc<SignInBloc>().add(LoginWithApplePressed());
        },
      );
    } else {
      return Container();
    }
  }

  void _checkCanSignInWithApple() async {
      if (Platform.isIOS) {
          var iosInfo = await DeviceInfoPlugin().iosInfo;
          var version = iosInfo.systemVersion;
          if (version.contains('13') == true) {
              setState(() {
                _supportsAppleSignIn = true;
              });
          }
      }
  }
}
