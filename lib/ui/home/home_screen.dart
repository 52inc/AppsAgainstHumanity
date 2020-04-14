import 'package:appsagainsthumanity/data/features/users/model/user.dart';
import 'package:appsagainsthumanity/ui/home/bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:appsagainsthumanity/internal.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

class HomeScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          HomeBloc(userRepository: context.repository())..add(HomeStarted()),
      child: _buildBody(),
    );
  }

  Widget _buildBody() {
    return BlocConsumer<HomeBloc, HomeState>(
      listener: (BuildContext context, HomeState state) {},
      builder: (context, state) {
        return Scaffold(
          body: Column(
            children: [
              Container(
                margin: const EdgeInsets.only(left: 24, right: 24, top: 48),
                child: AspectRatio(
                  aspectRatio: 312 / 436,
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
                            style: context.theme.textTheme.headline3.copyWith(
                                color: Colors.black87,
                                fontWeight: FontWeight.bold,
                                fontSize: 48),
                          ),
                        ),
                        Expanded(
                          child: Align(
                            alignment: Alignment.bottomCenter,
                            child: Container(
                                child: state.isLoading
                                    ? _buildLoadingUserTile()
                                    : state.error != null
                                        ? _buildErrorUserTile(state.error)
                                        : _buildUserTile(state.user)),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ),

              Expanded(
                child: Column(
                  children: [
                    
                    Container(
                      margin: const EdgeInsets.only(top: 48),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: <Widget>[
                          FloatingActionButton.extended(
                            label: Text("JOIN GAME"),
                            icon: Icon(MdiIcons.accountGroup),
                            onPressed: () {
                              
                            },
                          ),
                          FloatingActionButton.extended(
                            label: Text("NEW GAME"),
                            icon: Icon(MdiIcons.gamepad),
                            backgroundColor: AppColors.primary,
                            onPressed: () {

                            },
                          ),
                        ],
                      ),
                    )

                  ],
                ),
              )
            ],
          ),
        );
      },
    );
  }

  Widget _buildLoadingUserTile() {
    return ListTile(
      title: Text("Loading..."),
      leading: CircleAvatar(
        radius: 20,
        backgroundColor: Colors.grey.withOpacity(0.4),
        child: CircularProgressIndicator(),
      ),
    );
  }

  Widget _buildErrorUserTile(String error) {
    return ListTile(
      title: Text("Error loading user"),
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

  Widget _buildUserTile(User user) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
      title: Text(user.name),
      subtitle: Text(user.id),
      leading: CircleAvatar(
        radius: 20,
        backgroundImage: NetworkImage(
          user.avatarUrl
        ),
        backgroundColor: AppColors.primary,
      ),
    );
  }
}
