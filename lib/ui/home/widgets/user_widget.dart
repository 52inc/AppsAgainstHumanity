import 'package:appsagainsthumanity/internal.dart';
import 'package:appsagainsthumanity/ui/home/bloc/bloc.dart';
import 'package:appsagainsthumanity/ui/home/widgets/home_outline_button.dart';
import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

class UserWidget extends StatelessWidget {
  final HomeState state;
  final VoidCallback onTap;

  UserWidget({
    required this.state,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return HomeOutlineButton(
      icon: state.isLoading
          ? _buildLoadingIcon()
          : state.error != ""
              ? _buildErrorIcon()
              : _buildUserIcon(),
      text: state.isLoading
          ? "Loading..."
          : state.error != ""
              ? "Uh oh!"
              : state.user.name,
      textColor: Colors.white,
//      borderColor: Colors.white,
      onTap: onTap,
    );
  }

  Widget _buildLoadingIcon() {
    return Container(
      width: 24,
      height: 24,
      child: CircularProgressIndicator(),
    );
  }

  Widget _buildErrorIcon() {
    return Container(
      width: 24,
      height: 24,
      child: CircleAvatar(
        radius: 12,
        backgroundColor: Colors.redAccent,
        child: Icon(
          MdiIcons.accountRemoveOutline,
          color: Colors.white,
          size: 20,
        ),
      ),
    );
  }

  Widget _buildUserIcon() {
    return Container(
      width: 24,
      height: 24,
      child: CircleAvatar(
        radius: 20,
        backgroundImage: state.user.avatarUrl != ""
            ? NetworkImage(state.user.avatarUrl)
            : null,
        backgroundColor: AppColors.primary,
      ),
    );
  }
}
