import 'package:appsagainsthumanity/internal.dart';
import 'package:appsagainsthumanity/ui/profile/bloc/bloc.dart';
import 'package:appsagainsthumanity/ui/profile/widgets/profile_photo.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

class ProfileScreen extends StatefulWidget {
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final TextEditingController _displayNameController = TextEditingController();

  @override
  void dispose() {
    _displayNameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<ProfileBloc>(
      create: (context) => ProfileBloc(context.repository())..add(ScreenLoaded()),
      child: _buildBody(),
    );
  }

  Widget _buildBody() {
    return BlocConsumer<ProfileBloc, ProfileState>(
      listenWhen: (previous, current) => current.user?.name != previous.user?.name,
      listener: (context, state) {
        _displayNameController.text = state.user?.name;
      },
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(
            brightness: Brightness.dark,
            textTheme: context.theme.textTheme,
            iconTheme: context.theme.iconTheme,
            title: Text("Profile"),
            backgroundColor: AppColors.surfaceDark,
          ),
          body: ListView(
            children: [
              Container(
                padding: const EdgeInsets.only(top: 32),
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    ProfilePhoto(
                      state.user,
                      size: 128,
                    ),
                    if (state.isLoading) CircularProgressIndicator(),
                    if (!state.isLoading && state.user?.avatarUrl != null) _buildEditPhotoStack(context)
                  ],
                ),
              ),
              Container(
                margin: const EdgeInsets.only(left: 16, right: 16, bottom: 16, top: 16),
                child: ListTile(
                  title: Text(
                    "User ID",
                    style: context.theme.textTheme.subtitle1.copyWith(
                      color: AppColors.primaryVariant,
                    ),
                  ),
                  subtitle: Text(state.user?.id ?? "Loading..."),
                ),
              ),
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 32),
                child: TextFormField(
                  controller: _displayNameController,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: "Display name",
                  ),
                  keyboardType: TextInputType.text,
                  textInputAction: TextInputAction.go,
                  onFieldSubmitted: (value) {
                    context.bloc<ProfileBloc>().add(DisplayNameChanged(value));
                  },
                ),
              )
            ],
          ),
        );
      },
    );
  }

  Widget _buildEditPhotoStack(BuildContext context) {
    return IgnorePointer(
      ignoring: true,
      child: Container(
        margin: const EdgeInsets.only(top: 8),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              MdiIcons.imageEditOutline,
              color: AppColors.primaryVariant,
            ),
            Container(
              margin: const EdgeInsets.only(left: 8),
              child: Text(
                "EDIT",
                style: context.theme.textTheme.subtitle1.copyWith(
                  fontWeight: FontWeight.w700,
                  color: AppColors.primaryVariant,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  String getUserInitials(String name) {
    if (name != null) {
      var splitName = name.split(' ');
      if (splitName != null && splitName.isNotEmpty) {
        var nonEmptyCharacters = splitName.where((e) => e.isNotEmpty);
        if (nonEmptyCharacters.isNotEmpty) {
          return nonEmptyCharacters.map((e) => e[0]).join().toUpperCase();
        } else {
          return "";
        }
      } else {
        return "";
      }
    }
    return "";
  }
}
