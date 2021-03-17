import 'dart:io';

import 'package:appsagainsthumanity/authentication_bloc/authentication_bloc.dart';
import 'package:appsagainsthumanity/internal.dart';
import 'package:appsagainsthumanity/ui/signin/bloc/bloc.dart';
import 'package:appsagainsthumanity/ui/signin/widgets/apple_sign_in.dart';
import 'package:appsagainsthumanity/ui/signin/widgets/auth_button.dart';
import 'package:appsagainsthumanity/ui/widgets/reponsive_widget_mediator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

import 'layouts/mobile_layout.dart';
import 'layouts/tablet_layout.dart';

class SignInScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _SignInScreen();
}

class _SignInScreen extends State<SignInScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).padding.bottom,
          top: context.paddingTop,
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
          context.scaffold.showSnackBar(
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
        return ResponsiveWidgetMediator(
          mobile: (_) => MobileLayout(),
          tablet: (_) => TabletLayout(),
        );
      },
    );
  }
}
