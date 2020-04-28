import 'dart:io';

import 'package:appsagainsthumanity/data/features/game/game_repository.dart';
import 'package:appsagainsthumanity/data/features/game/model/player.dart';
import 'package:appsagainsthumanity/data/features/users/model/user.dart';
import 'package:appsagainsthumanity/data/features/game/model/game_state.dart';
import 'package:appsagainsthumanity/internal/push.dart';
import 'package:appsagainsthumanity/ui/creategame/create_game_screen.dart';
import 'package:appsagainsthumanity/ui/game/game_screen.dart';
import 'package:appsagainsthumanity/ui/home/bloc/bloc.dart';
import 'package:appsagainsthumanity/ui/home/widgets/join_room_dialog.dart';
import 'package:appsagainsthumanity/ui/home/widgets/past_game_card.dart';
import 'package:appsagainsthumanity/ui/profile/profile_screen.dart';
import 'package:appsagainsthumanity/ui/routes.dart';
import 'package:appsagainsthumanity/ui/settings/settings_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:appsagainsthumanity/internal.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:timeago/timeago.dart' as timeago;

class HomeScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final PageController _pageController = PageController(viewportFraction: 0.925);

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => HomeBloc(context.repository(), context.repository())..add(HomeStarted()),
      child: _buildBody(),
    );
  }

  Widget _buildBody() {
    return BlocConsumer<HomeBloc, HomeState>(
      listener: (BuildContext context, HomeState state) {
        if (state.error != null) {
          Scaffold.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(
              SnackBar(
                content: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [Text(state.error), Icon(Icons.error)],
                ),
                backgroundColor: Colors.redAccent,
              ),
            );
        }
      },
      builder: (context, state) {
        return Scaffold(
          body: Padding(
            padding: EdgeInsets.only(bottom: MediaQuery.of(context).padding.bottom),
            child: Column(
              children: [
                AspectRatio(
                  aspectRatio: 312 / 436,
                  child: PageView(
                    controller: _pageController,
                    children: [
                      _buildTitleCard(context, state, includeMargin: false),

                      if (state.games.isNotEmpty)
                        PastGamesCard(state),
                    ],
                  ),
                ),
                Expanded(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _buildMenuAction(
                        context: context,
                        margin: const EdgeInsets.only(left: 24, top: 16, right: 8, bottom: 16),
                        icon: MdiIcons.gamepad,
                        label: "START GAME",
                        onTap: () {
                          PushNotifications().checkPermissions();
                          Navigator.of(context).push(MaterialPageRoute(builder: (context) => CreateGameScreen()));
                        },
                      ),
                      Builder(builder: (context) {
                        return _buildMenuAction(
                          context: context,
                          margin: const EdgeInsets.only(left: 8, top: 16, right: 24, bottom: 16),
                          icon: MdiIcons.gamepadVariantOutline,
                          label: "JOIN GAME",
                          onTap: () {
                            PushNotifications().checkPermissions();
                            _joinGame(context);
                          },
                        );
                      }),
                    ],
                  ),
                )
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildTitleCard(BuildContext context, HomeState state, {bool includeMargin = true}) {
    var topMargin = MediaQuery.of(context).padding.top + (Platform.isAndroid ? 24 : 0);
    return Container(
      margin: includeMargin
          ? EdgeInsets.only(left: 24, right: 24, top: topMargin)
          : EdgeInsets.only(left: 8, right: 8, top: topMargin),
      child: AspectRatio(
        aspectRatio: 312 / 436,
        child: Material(
          elevation: 4.0,
          borderRadius: BorderRadius.circular(16),
          color: context.theme.cardColor,
          clipBehavior: Clip.hardEdge,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Stack(
                children: <Widget>[
                  Container(
                    margin: const EdgeInsets.all(24),
                    child: Text(
                      context.strings.appNameDisplay,
                      style: context.theme.textTheme.headline3
                          .copyWith(color: Colors.black87, fontWeight: FontWeight.bold, fontSize: 48),
                    ),
                  ),
                  Align(
                    alignment: Alignment.topRight,
                    child: IconButton(
                      padding: const EdgeInsets.all(24),
                      icon: Icon(
                        MdiIcons.cog,
                        color: Colors.black87,
                      ),
                      onPressed: () {
                        Navigator.of(context).push(MaterialPageRoute(builder: (_) => SettingsScreen()));
                      },
                    ),
                  )
                ],
              ),
              Expanded(
                child: Align(
                  alignment: Alignment.bottomCenter,
                  child: Container(
                      child: state.isLoading
                          ? _buildLoadingUserTile()
                          : state.error != null ? _buildErrorUserTile(state.error) : _buildUserTile(context, state.user)),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMenuAction({
    @required BuildContext context,
    @required IconData icon,
    @required String label,
    @required EdgeInsets margin,
    Color color = Colors.white,
    VoidCallback onTap,
  }) {
    return Expanded(
      child: Container(
        margin: margin,
        child: Material(
          borderRadius: BorderRadius.circular(16),
          elevation: 2,
          color: color,
          clipBehavior: Clip.hardEdge,
          child: InkWell(
            onTap: onTap,
            child: Container(
              height: double.maxFinite,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    icon,
                    color: Colors.black87,
                  ),
                  Container(
                    margin: const EdgeInsets.only(top: 16),
                    child: Text(label,
                        style: context.theme.textTheme.button.copyWith(
                          color: Colors.black87,
                        )),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLoadingUserTile() {
    return ListTile(
      title: Text(
        "Loading...",
        style: context.theme.textTheme.subtitle1.copyWith(color: Colors.black87),
      ),
      leading: CircleAvatar(
        radius: 20,
        backgroundColor: Colors.grey.withOpacity(0.4),
        child: CircularProgressIndicator(),
      ),
    );
  }

  Widget _buildErrorUserTile(String error) {
    return ListTile(
      title: Text(
        "Error loading user",
        style: context.theme.textTheme.subtitle1.copyWith(color: Colors.black87),
      ),
      subtitle: Text(error),
      leading: CircleAvatar(
        radius: 20,
        backgroundColor: Colors.redAccent,
        child: Icon(
          MdiIcons.accountRemoveOutline,
          color: Colors.white,
        ),
      ),
    );
  }

  Widget _buildUserTile(BuildContext context, User user) {
    return ListTile(
      onTap: () {
        Navigator.of(context).push(MaterialPageRoute(
          builder: (_) => ProfileScreen()
        ));
      },
      contentPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
      title: Text(
        user.name ?? Player.DEFAULT_NAME,
        style: context.theme.textTheme.subtitle1.copyWith(color: Colors.black87),
      ),
      subtitle: Text(
        user.id,
        style: context.theme.textTheme.bodyText1.copyWith(color: Colors.black38),
      ),
      leading: CircleAvatar(
        radius: 20,
        backgroundImage: user.avatarUrl != null ? NetworkImage(user.avatarUrl) : null,
        backgroundColor: AppColors.primary,
      ),
    );
  }

  void _joinGame(BuildContext context) async {
    var gameId = await showJoinRoomDialog(context);
    if (gameId != null) {
      try {
        var game = await context.repository<GameRepository>().joinGame(gameId);
        Navigator.of(context).push(GamePageRoute(game));
      } catch (e) {
        Scaffold.of(context)
          ..hideCurrentSnackBar()
          ..showSnackBar(SnackBar(
            content: Text("$e"),
          ));
      }
    }
  }
}
