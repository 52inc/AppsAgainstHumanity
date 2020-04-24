import 'package:appsagainsthumanity/authentication_bloc/authentication_bloc.dart';
import 'package:appsagainsthumanity/internal.dart';
import 'package:appsagainsthumanity/ui/signin/bloc/bloc.dart';
import 'package:appsagainsthumanity/ui/signin/widgets/apple_sign_in.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SignInScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _SignInScreen();
}

class _SignInScreen extends State<SignInScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocProvider(
        create: (context) => SignInBloc(userRepository: context.repository()),
        child: _buildBody(),
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
          children: [
            Expanded(
              child: Container(
                width: double.maxFinite,
                margin: const EdgeInsets.only(left: 24, right: 24, top: 48),
                child: Material(
                  elevation: 4.0,
                  borderRadius: BorderRadius.circular(16),
                  color: Colors.white,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        margin: const EdgeInsets.all(24),
                        child: Text(
                          context.strings.appNameDisplay,
                          style: context.theme.textTheme.headline3
                              .copyWith(color: Colors.black87, fontWeight: FontWeight.bold, fontSize: 48),
                        ),
                      )
                    ],
                  ),
                ),
              ),
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
              margin: const EdgeInsets.all(24),
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
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    alignment: Alignment.center,
                    child: Row(
                      children: <Widget>[
                        Image.asset('assets/google_logo.png', width: 24, height: 24),
                        Expanded(
                          child: Text(
                            context.strings.actionSignIn,
                            textAlign: TextAlign.center,
                            style: context.theme.textTheme.subtitle1.copyWith(
                              color: Colors.black87,
                              fontWeight: FontWeight.w600
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
