import 'package:appsagainsthumanity/data/features/users/model/user.dart';
import 'package:appsagainsthumanity/data/features/users/user_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kt_dart/kt.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:appsagainsthumanity/internal.dart';

class UserPreference extends StatelessWidget {
  final void Function(User) onTap;

  UserPreference({required this.onTap});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User>(
      stream: context.repository<UserRepository>().observeUser(),
      builder: (context, snapshot) {
        return _buildPreference(context, snapshot.data);
      },
    );
  }

  Widget _buildPreference(BuildContext context, User? user) {
    return ListTile(
      leading: _avatar(user!),
      title: Text(
        user.name != "" ? "${user.name}" : "Loading...",
        style: context.theme.textTheme.subtitle1?.copyWith(
          color: context.colorOnCard,
        ),
      ),
      onTap: onTap != () {} ? () => onTap(user) : null,
    );
  }

  Widget _avatar(User user) {
    return CircleAvatar(
      child: user.avatarUrl != ""
          ? const SizedBox()
          : Icon(
              MdiIcons.account,
              color: Colors.black87,
            ),
      backgroundColor:
          user.avatarUrl != "" ? Colors.black12 : AppColors.primary,
      backgroundImage:
          user.avatarUrl != "" ? NetworkImage(user.avatarUrl) : null,
      radius: 20,
    );
  }
}
