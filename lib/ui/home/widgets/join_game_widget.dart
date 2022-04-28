import 'package:appsagainsthumanity/internal.dart';
import 'package:appsagainsthumanity/internal/push.dart';
import 'package:appsagainsthumanity/ui/home/bloc/bloc.dart';
import 'package:appsagainsthumanity/ui/home/widgets/home_outline_button.dart';
import 'package:appsagainsthumanity/ui/home/widgets/join_room_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

class JoinGameWidget extends StatelessWidget {
  final HomeState state;

  JoinGameWidget(this.state);

  @override
  Widget build(BuildContext context) {
    return HomeOutlineButton(
      icon: state.joiningGame == "" ? _buildIcon() : _buildLoadingIcon(),
      text: state.joiningGame == "" ? "Join Game" : "Joining Game...",
      onTap: () {
        Analytics()
            .logSelectContent(contentType: 'action', itemId: 'join_game');
        PushNotifications().checkPermissions();
        _joinGame(context);
      },
    );
  }

  Widget _buildLoadingIcon() {
    return Container(
      width: 24,
      height: 24,
      child: CircularProgressIndicator(),
    );
  }

  Widget _buildIcon() {
    return Icon(
      MdiIcons.gamepadVariantOutline,
      color: AppColors.primaryVariant,
    );
  }

  void _joinGame(BuildContext context) async {
    var gameId = await showJoinRoomDialog(context);
    if (gameId != null) {
      context.bloc<HomeBloc>().add(JoinGame(gameId));
    }
  }
}
