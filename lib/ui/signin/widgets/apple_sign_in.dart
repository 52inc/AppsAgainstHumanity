import 'dart:io';
import 'package:appsagainsthumanity/ui/signin/bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';

class AppleSignIn extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    if (Platform.isIOS) {
      return SignInWithAppleButton(
        style: SignInWithAppleButtonStyle.white,
        iconAlignment: IconAlignment.left,
        height: 48,
        onPressed: () {
          context.bloc<SignInBloc>().add(LoginWithApplePressed());
        },
      );
    } else {
      return Container();
    }
  }
}
