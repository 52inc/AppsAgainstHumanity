import 'package:appsagainsthumanity/ui/signin/bloc/bloc.dart';
import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:appsagainsthumanity/internal.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class EmailAuthForm extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _EmailAuthFormState();
}

class _EmailAuthFormState extends State<EmailAuthForm> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _userNameController = TextEditingController();
  final _emailNode = FocusNode();
  final _passwordNode = FocusNode();
  final _confirmPasswordNode = FocusNode();
  final _userNameNode = FocusNode();
  final _actionNode = FocusNode();

  var _authState = EmailAuthState.signIn;
  var _isPasswordObscured = true;
  var _isConfirmPasswordObscured = true;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _userNameController.dispose();
    _emailNode.dispose();
    _passwordNode.dispose();
    _confirmPasswordNode.dispose();
    _userNameNode.dispose();
    _actionNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // The email input field
          Container(
            child: TextFormField(
              controller: _emailController,
              focusNode: _emailNode,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                hintText: context.strings.hintEmail,
                hintStyle: GoogleFonts.raleway(),
                prefixIcon: Icon(Icons.email_rounded),
              ),
              keyboardType: TextInputType.emailAddress,
              textInputAction: TextInputAction.next,
              validator: (value) {
                if (!EmailValidator.validate(value)) {
                  return context.strings.errorInvalidEmailAddress;
                }
                return null;
              },
              onFieldSubmitted: (value) {
                _emailNode.unfocus();
                _passwordNode.requestFocus();
              },
            ),
          ),

          // The password input field
          Container(
            margin: const EdgeInsets.only(top: 16),
            child: TextFormField(
              controller: _passwordController,
              focusNode: _passwordNode,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                hintText: context.strings.hintPassword,
                hintStyle: GoogleFonts.raleway(),
                prefixIcon: Icon(Icons.vpn_key),
                suffixIcon: IconButton(
                  icon: Icon(
                    _isPasswordObscured ? Icons.visibility_rounded : Icons.visibility_off_rounded,
                  ),
                  onPressed: () {
                    setState(() {
                      _isPasswordObscured = !_isPasswordObscured;
                    });
                  },
                ),
              ),
              keyboardType: TextInputType.text,
              textInputAction: TextInputAction.next,
              obscureText: _isPasswordObscured,
              validator: (value) {
                if (value.length < 8) {
                  return context.strings.errorInvalidPasswordLength;
                }
                return null;
              },
              onFieldSubmitted: (value) {
                _passwordNode.unfocus();
                if (_authState == EmailAuthState.signUp) {
                  _confirmPasswordNode.requestFocus();
                } else {
                  _actionNode.requestFocus();
                }
              },
            ),
          ),

          // The confirm password input field
          if (_authState == EmailAuthState.signUp)
            Container(
              margin: const EdgeInsets.only(top: 16),
              child: TextFormField(
                controller: _confirmPasswordController,
                focusNode: _confirmPasswordNode,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: context.strings.hintConfirmPassword,
                  prefixIcon: Icon(Icons.vpn_key),
                  suffixIcon: IconButton(
                    icon: Icon(
                      _isConfirmPasswordObscured ? Icons.visibility_rounded : Icons.visibility_off_rounded,
                    ),
                    onPressed: () {
                      setState(() {
                        _isConfirmPasswordObscured = !_isConfirmPasswordObscured;
                      });
                    },
                  ),
                ),
                keyboardType: TextInputType.text,
                textInputAction: TextInputAction.next,
                obscureText: _isConfirmPasswordObscured,
                validator: (value) {
                  if (value.length < 8) {
                    return context.strings.errorInvalidPasswordLength;
                  } else if (value != _passwordController.text) {
                    return context.strings.errorMismatchingPasswords;
                  }
                  return null;
                },
                onFieldSubmitted: (value) {
                  _confirmPasswordNode.unfocus();
                  _userNameNode.requestFocus();
                },
              ),
            ),

          // The username field
          if (_authState == EmailAuthState.signUp)
            Container(
              margin: const EdgeInsets.only(top: 16),
              child: TextFormField(
                controller: _userNameController,
                focusNode: _userNameNode,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: context.strings.hintUserName,
                  hintStyle: GoogleFonts.raleway(),
                  prefixIcon: Icon(Icons.face_rounded),
                ),
                keyboardType: TextInputType.name,
                textInputAction: TextInputAction.next,
                validator: (value) {
                  if (value.isEmpty) {
                    return context.strings.errorInvalidUserName;
                  }
                  return null;
                },
                onFieldSubmitted: (value) {
                  _userNameNode.unfocus();
                  _actionNode.requestFocus();
                },
              ),
            ),

          Container(
            width: double.maxFinite,
            margin: const EdgeInsets.only(top: 20),
            child: ElevatedButton(
              focusNode: _actionNode,
              child: Text(
                _authState == EmailAuthState.signIn
                    ? context.strings.actionEmailSignIn.toUpperCase()
                    : context.strings.actionEmailSignUp.toUpperCase(),
                style: GoogleFonts.raleway(
                  color: Colors.black87,
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                ),
              ),
              style: ElevatedButton.styleFrom(
                primary: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                padding: const EdgeInsets.symmetric(vertical: 20),
              ),
              onPressed: () {
                if (_formKey.currentState.validate()) {
                  _authenticateWithEmail(context);
                }
              },
            ),
          ),

          Container(
            width: double.maxFinite,
            margin: const EdgeInsets.only(top: 8),
            child: TextButton(
              child: Text(
                _authState == EmailAuthState.signIn
                  ? context.strings.actionEmailAltSignUp
                  : context.strings.actionEmailAltSignIn,
                style: GoogleFonts.raleway(
                  color: Colors.white60,
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
              style: TextButton.styleFrom(
                primary: context.primaryColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                padding: const EdgeInsets.symmetric(vertical: 20),
              ),
              onPressed: () {
                setState(() {
                  if (_authState == EmailAuthState.signIn) {
                    _authState = EmailAuthState.signUp;
                  } else {
                    _authState = EmailAuthState.signIn;
                  }
                });
              },
            ),
          ),
        ],
      ),
    );
  }
  
  void _authenticateWithEmail(BuildContext context) {
    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();
    if (_authState == EmailAuthState.signIn) {
      context.bloc<SignInBloc>().add(LoginWithEmailPressed(email, password));
    } else {
      final userName = _userNameController.text.trim();
      context.bloc<SignInBloc>().add(SignUpWithEmailPressed(email, password, userName));
    }
  }
}

enum EmailAuthState {
  signIn,
  signUp,
}
