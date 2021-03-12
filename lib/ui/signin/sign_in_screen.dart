import 'dart:io';

import 'package:appsagainsthumanity/authentication_bloc/authentication_bloc.dart';
import 'package:appsagainsthumanity/internal.dart';
import 'package:appsagainsthumanity/ui/signin/bloc/bloc.dart';
import 'package:appsagainsthumanity/ui/signin/widgets/apple_sign_in.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

class SignInScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _SignInScreen();
}

class _SignInScreen extends State<SignInScreen> {
  @override
  Widget build(BuildContext context) {
    var topMargin =
        MediaQuery.of(context).padding.top/* FIXME: + (Platform.isAndroid ? 24 : 8)*/;
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).padding.bottom,
          top: topMargin,
        ),
        child: BlocProvider(
          create: (context) => SignInBloc(userRepository: context.repository()),
          child: _buildBody(),
        ),
      ),
    );
  }

  Widget _buildBody() {
    return BlocConsumer<SignInBloc, SignInState>(
      listener: (context, state) {
        if (state.isFailure) {
          Scaffold.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(
              SnackBar(
                content: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [Text('Login Failure'), Icon(Icons.error)],
                ),
                backgroundColor: Colors.redAccent,
              ),
            );
        }

        if (state.isSuccess) {
          context.bloc<AuthenticationBloc>().add(LoggedIn());
        }
      },
      builder: (context, state) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              margin: const EdgeInsets.only(left: 24, right: 24, top: 32),
              child: Text(
                context.strings.appNameDisplay,
                style: GoogleFonts.raleway(
                  textStyle: context.theme.textTheme.headline3.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 48,
                  ),
                ),
              ),
            ),
            Expanded(
              child: Container(),
            ),
            Container(
              width: double.infinity,
              alignment: Alignment.topCenter,
              margin: const EdgeInsets.only(left: 24, right: 24, top: 24),
              child: AppleSignIn(),
            ),
            Container(
              width: double.infinity,
              alignment: Alignment.topCenter,
              margin: const EdgeInsets.symmetric(horizontal: 24),
              child: Material(
                type: MaterialType.button,
                color: Colors.white,
                clipBehavior: Clip.hardEdge,
                borderRadius: BorderRadius.circular(6),
                child: InkWell(
                  onTap: () {
                    context.bloc<SignInBloc>().add(LoginWithGooglePressed());
                  },
                  child: Container(
                    width: double.maxFinite,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 12,
                    ),
                    alignment: Alignment.center,
                    child: Row(
                      children: <Widget>[
                        Image.asset(
                          'assets/google_logo.png',
                          width: 24,
                          height: 24,
                        ),
                        Expanded(
                          child: Text(
                            context.strings.actionSignIn,
                            textAlign: TextAlign.center,
                            style: context.theme.textTheme.subtitle1.copyWith(
                              color: Colors.black87,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            Container(
              width: double.infinity,
              alignment: Alignment.topCenter,
              margin: const EdgeInsets.all(24),
              child: Material(
                type: MaterialType.button,
                color: Colors.white,
                clipBehavior: Clip.hardEdge,
                borderRadius: BorderRadius.circular(6),
                child: InkWell(
                  onTap: () {
                    context.bloc<SignInBloc>()
                        .add(LoginWithGooglePressed());
                  },
                  child: Container(
                    width: double.maxFinite,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 12,
                    ),
                    alignment: Alignment.center,
                    child: Row(
                      children: <Widget>[
                        Icon(
                          MdiIcons.email,
                          color: Colors.black87,
                        ),
                        Expanded(
                          child: Text(
                            context.strings.actionSignInEmail,
                            textAlign: TextAlign.center,
                            style: context.theme.textTheme.subtitle1.copyWith(
                              color: Colors.black87,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
