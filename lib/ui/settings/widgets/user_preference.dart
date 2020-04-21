import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:kt_dart/kt.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:appsagainsthumanity/internal.dart';

class UserPreference extends StatelessWidget {

  final void Function(UserInfo) onTap;

  UserPreference({this.onTap});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<FirebaseUser>(
      stream: FirebaseAuth.instance.currentUser().asStream(),
      builder: (context, snapshot) {
        var twitterProviderData = snapshot?.data?.providerData
            ?.firstWhere((element) => element.providerId.contains("twitter"));
        return _buildPreference(twitterProviderData);
      },
    );
  }

  Widget _buildPreference(@nullable UserInfo user) {
    if (user != null) {
      print("${user.displayName}, ${user.uid}, ${user.providerId}, ${user.photoUrl}");
    }
    return ListTile(
      leading: _avatar(user),
      title: Text(user?.displayName != null ? "@${user.displayName}" : "Loading..."),
      subtitle: Text(user?.providerId ?? ""),
      onTap: onTap != null ? () => onTap(user) : null,
    );
  }

  Widget _avatar(@nullable UserInfo user) {
    return CircleAvatar(
      child: user?.photoUrl != null ? null : Icon(MdiIcons.account),
      backgroundColor: user?.photoUrl != null ? Colors.black12 : AppColors.secondary,
      backgroundImage: user?.photoUrl != null ? NetworkImage(user.photoUrl) : null,
      radius: 20,
    );
  }
}
