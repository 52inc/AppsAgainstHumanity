import 'dart:io';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:appsagainsthumanity/ui/signin/bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';

class AppleSignIn extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var isIOs = false;
    if (!kIsWeb) {
      isIOs = Platform.isIOS;
    }
    if (isIOs) {
      return SignInWithAppleButton(
        style: SignInWithAppleButtonStyle.white,
        iconAlignment: IconAlignment.left,
        height: 48,
        onPressed: () {
          context.read<SignInBloc>().add(LoginWithApplePressed());
        },
      );
    } else {
      return Container();
    }
  }
}
