import 'package:appsagainsthumanity/authentication_bloc/authentication_bloc.dart';
import 'package:appsagainsthumanity/data/features/users/user_repository.dart';
import 'package:appsagainsthumanity/internal.dart';
import 'package:appsagainsthumanity/ui/profile/profile_screen.dart';
import 'package:appsagainsthumanity/ui/settings/widgets/preference.dart';
import 'package:appsagainsthumanity/ui/settings/widgets/preference_header.dart';
import 'package:appsagainsthumanity/ui/settings/widgets/user_preference.dart';
import 'package:appsagainsthumanity/ui/widgets/web_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:package_info/package_info.dart';
import 'package:wiredash/wiredash.dart';

class SettingsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Settings",
          style: context.theme.textTheme.headline6.copyWith(color: Colors.white),
        ),
        iconTheme: context.theme.iconTheme,
        backgroundColor: Colors.transparent,
        brightness: Brightness.dark,
        elevation: 0,
      ),
      body: ListView(
        children: [
          PreferenceCategory(
            title: "Account",
            children: [
              UserPreference(
                onTap: (user) {
                  Analytics().logSelectContent(contentType: 'setting', itemId: 'profile');
                  Navigator.of(context).push(MaterialPageRoute(builder: (_) => ProfileScreen()));
                },
              ),
              Preference(
                title: "Sign out",
                icon: Icon(
                  MdiIcons.logout,
                  color: context.secondaryColorOnCard,
                ),
                onTap: () {
                  _signOut(context);
                },
              ),
              Preference(
                title: "Delete account",
                titleColor: AppColors.error,
                titleWeight: FontWeight.bold,
                icon: Icon(
                  MdiIcons.deleteForeverOutline,
                  color: AppColors.error,
                ),
                onTap: () {
                  _deleteAccount(context);
                },
              ),
            ],
          ),
          PreferenceCategory(
            title: "Legal",
            children: [
              Preference(
                title: "Privacy Policy",
                icon: Icon(
                  MdiIcons.shieldSearch,
                  color: context.secondaryColorOnCard,
                ),
                onTap: () {
                  Analytics().logSelectContent(contentType: 'setting', itemId: 'privacy_policy');
                  showWebView(
                    context,
                    "Privacy Policy",
                    Config.privacyPolicyUrl,
                  );
                },
              ),
              Preference(
                title: "Terms of service",
                icon: Icon(
                  MdiIcons.formatFloatLeft,
                  color: context.secondaryColorOnCard,
                ),
                onTap: () {
                  Analytics().logSelectContent(contentType: 'setting', itemId: 'terms_of_service');
                  showWebView(
                    context,
                    "Terms of service",
                    Config.termsOfServiceUrl,
                  );
                },
              ),
              Preference(
                title: "Open Source Licenses",
                icon: Icon(
                  MdiIcons.sourceBranch,
                  color: context.secondaryColorOnCard,
                ),
                onTap: () {
                  Analytics().logSelectContent(contentType: 'setting', itemId: 'oss_licenses');
                  showLicensePage(context: context);
                },
              ),
            ],
          ),
          PreferenceCategory(
            title: "About",
            children: [
              Preference(
                title: "Feedback",
                subtitle: "Provide feedback on issues or improvements",
                icon: Icon(
                  MdiIcons.faceAgent,
                  color: context.secondaryColorOnCard
                ),
                onTap: () {
                  Analytics().logSelectContent(contentType: 'setting', itemId: 'feedback');
                  Wiredash.of(context).show();
                },
              ),

              Preference(
                title: "Contribute",
                subtitle: "Checkout the source code on GitHub!",
                icon: Icon(
                  MdiIcons.github,
                  color: context.secondaryColorOnCard,
                ),
                onTap: () {
                  Analytics().logSelectContent(contentType: 'setting', itemId: 'contribute');
                  showWebView(
                    context,
                    "Contribute",
                    Config.sourceUrl,
                  );
                },
              ),
              Preference(
                title: "Built by 52inc",
                icon: Image.asset(
                  'assets/ic_logo.png',
                  color: context.secondaryColorOnCard,
                ),
                onTap: () {
                  Analytics().logSelectContent(contentType: 'setting', itemId: 'author');
                  showWebView(
                    context,
                    "52inc",
                    "https://52inc.com",
                  );
                },
              ),
              StreamBuilder<PackageInfo>(
                  stream: PackageInfo.fromPlatform().asStream(),
                  builder: (context, snapshot) {
                    var packageInfo = snapshot.data;
                    return Preference(
                      title: "Version",
                      icon: Icon(
                        MdiIcons.application,
                        color: context.secondaryColorOnCard,
                      ),
                      subtitle: packageInfo != null
                          ? "${packageInfo.version}+${packageInfo.buildNumber}"
                          : "Loading...",
                    );
                  }),
            ],
          ),
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
            alignment: Alignment.center,
            child: Column(
              children: [
                GestureDetector(
                  onTap: () {
                    showWebView(context, "Cards Against Humanity", "https://cardsagainsthumanity.com");
                  },
                  child: Container(
                    child: Text(
                      "All CAH or \"Cards Against Humanity\" question and answer text are licensed under Creative Commons BY-NC-SA 4.0 by the owner Cards Against Humanity, LLC. This application is NOT official, produced, endorsed or supported by Cards Against Humanity, LLC.",
                      textAlign: TextAlign.center,
                      style: context.theme.textTheme.bodyText2.copyWith(
                        color: Colors.white60,
                      ),
                    ),
                  ),
                ),

                Container(
                  margin: const EdgeInsets.only(top: 16),
                  child: GestureDetector(
                    onTap: () {
                      showWebView(context, "CC BY-NC-SA 4.0", "https://creativecommons.org/licenses/by-nc-sa/4.0/legalcode");
                    },
                    child: Image.asset('assets/cc_by_nc_sa.png', width: 96,),
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  void _deleteAccount(BuildContext context) async {
    bool result = await showDialog<bool>(
        context: context,
        builder: (context) {
          return AlertDialog(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            title: Text(
              "Delete account?",
              style: context.theme.textTheme.headline6.copyWith(color: Colors.redAccent),
            ),
            content: Text(
              "Are you sure you want to delete your account? This is permenant and cannot be undone.",
              style: context.theme.textTheme.subtitle1.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            actions: [
              FlatButton(
                child: Text("CANCEL"),
                textColor: Colors.white70,
                onPressed: () {
                  Navigator.of(context).pop(false);
                },
              ),
              FlatButton(
                child: Text("DELETE ACCOUNT"),
                textColor: Colors.redAccent,
                onPressed: () {
                  Navigator.of(context).pop(true);
                },
              ),
            ],
          );
        });

    if (result ?? false) {
      Analytics().logSelectContent(contentType: 'setting', itemId: 'delete_account');
      var userRepository = context.repository<UserRepository>();
      try {
        await userRepository.deleteAccount();
        context.bloc<AuthenticationBloc>().add(LoggedOut());
        Navigator.of(context).pop();
      } catch (e) {
        if (e is PlatformException) {
          if (e.code == 'ERROR_REQUIRES_RECENT_LOGIN') {
            await userRepository.signInWithGoogle();
            await userRepository.deleteAccount();
            context.bloc<AuthenticationBloc>().add(LoggedOut());
            Navigator.of(context).pop();
          }
        }
      }
    }
  }

  void _signOut(BuildContext context) async {
    var userRepository = context.repository<UserRepository>();
    await userRepository.signOut();
    context.bloc<AuthenticationBloc>().add(LoggedOut());
    Navigator.of(context).pop();
  }
}

class PreferenceCategory extends StatelessWidget {
  final String title;
  final List<Widget> children;
  final EdgeInsets margin;

  PreferenceCategory({
    this.title,
    this.margin,
    @required this.children,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: margin ?? const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      child: Material(
        elevation: 4,
        borderRadius: BorderRadius.circular(8),
        color: context.theme.cardColor,
        child: Padding(
          padding: const EdgeInsets.only(bottom: 8),
          child: Column(
            children: [
              if (title != null) PreferenceHeader(title: title, includeIconSpacing: false),
              ...children,
            ],
          ),
        ),
      ),
    );
  }
}
