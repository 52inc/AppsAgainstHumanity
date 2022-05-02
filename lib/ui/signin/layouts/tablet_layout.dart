import 'package:appsagainsthumanity/ui/signin/widgets/email_auth_form.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:appsagainsthumanity/ui/signin/widgets/apple_sign_in.dart';
import 'package:appsagainsthumanity/ui/signin/widgets/auth_button.dart';
import 'package:appsagainsthumanity/internal.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

import '../bloc/bloc.dart';

class TabletLayout extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          margin: const EdgeInsets.only(left: 32, right: 24),
          child: Text(
            context.strings.appNameDisplay,
            style: GoogleFonts.raleway(
              textStyle: context.theme.textTheme.headline3?.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 48,
              ),
            ),
          ),
        ),
        Expanded(
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              children: [
                Container(
                  width: 400,
                  child: EmailAuthForm(),
                ),
                Container(
                  width: 400,
                  height: 56,
                  margin: const EdgeInsets.symmetric(vertical: 32),
                  child: Row(
                    children: [
                      Expanded(
                          child: Container(height: 1, color: Colors.white60)),
                      Container(
                        margin: const EdgeInsets.symmetric(horizontal: 16),
                        child: Text('OR'),
                      ),
                      Expanded(
                          child: Container(height: 1, color: Colors.white60)),
                    ],
                  ),
                ),
                Container(
                  width: 400,
                  alignment: Alignment.topCenter,
                  margin: const EdgeInsets.only(left: 24, right: 24),
                  child: AppleSignIn(),
                ),
                Container(
                  width: 400,
                  margin: const EdgeInsets.symmetric(horizontal: 24),
                  child: AuthButton(
                    text: context.strings.actionSignIn,
                    icon: Image.asset(
                      'assets/google_logo.png',
                      width: 24,
                      height: 24,
                    ),
                    onPressed: () {
                      context.read<SignInBloc>().add(LoginWithGooglePressed());
                    },
                  ),
                ),
                Container(
                  width: 400,
                  margin:
                      const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
                  child: AuthButton.withIcon(
                    text: context.strings.actionSignInAnonymously,
                    iconData: MdiIcons.incognito,
                    onPressed: () {
                      context.read<SignInBloc>().add(LoginAnonymouslyPressed());
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
