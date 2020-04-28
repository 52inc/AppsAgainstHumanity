import 'package:appsagainsthumanity/data/features/users/model/user.dart';
import 'package:appsagainsthumanity/internal.dart';
import 'package:appsagainsthumanity/ui/profile/bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';

class ProfilePhoto extends StatelessWidget {
  final User user;
  final double size;

  ProfilePhoto(this.user, {this.size = 156});

  @override
  Widget build(BuildContext context) {
    var profilePhotoUrl = user?.avatarUrl;
    return profilePhotoUrl != null
        ? _buildExistingPhotoAction(context, profilePhotoUrl)
        : _buildAddPhotoAction(context);
  }

  Widget _buildAddPhotoAction(BuildContext context) {
    return Material(
      shape: CircleBorder(),
      clipBehavior: Clip.hardEdge,
      color: AppColors.addPhotoBackground,
      child: InkWell(
        splashColor: AppColors.primary.withOpacity(0.30),
        highlightColor: AppColors.primary.withOpacity(0.30),
        onTap: () => _onProfilePhotoClicked(context),
        child: SizedBox(
          width: size,
          height: size,
          child: Center(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Icon(
                  Icons.add_a_photo,
                  size: 46.0,
                  color: AppColors.addPhotoForeground,
                ),

                Container(
                  margin: const EdgeInsets.only(top: 4),
                  child: Text(
                    "Add photo",
                    style: Theme.of(context).textTheme.button.copyWith(color: AppColors.addPhotoForeground),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildExistingPhotoAction(BuildContext context, String avatarUrl) {
    return Material(
      elevation: 4.0,
      shape: CircleBorder(),
      clipBehavior: Clip.hardEdge,
      color: Colors.transparent,
      child: Ink.image(
        image: NetworkImage(avatarUrl),
        fit: BoxFit.cover,
        width: size,
        height: size,
        child: InkWell(
          onTap: () => _onProfilePhotoClicked(context),
        ),
      ),
    );
  }

  void _onProfilePhotoClicked(BuildContext context) async {
    var action = await _showPhotoBottomSheet(context);
    print("Result: $action");
    if (action is DeletePhoto) {
      context.bloc<ProfileBloc>()
          .add(DeleteProfilePhoto());
    } else if (action is UpdatePhoto) {
      var image = await ImagePicker.pickImage(source: action.source);
      if (image != null) {
        context.bloc<ProfileBloc>()
            .add(PhotoChanged(image));
      }
    }
  }

  Future<ProfilePhotoAction> _showPhotoBottomSheet(BuildContext context) async {
    return await showModalBottomSheet<ProfilePhotoAction>(
        context: context,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(16),
            topRight: Radius.circular(16),
          )
        ),
        backgroundColor: context.theme.canvasColor,
        builder: (context) {
          return Container(
            child: Wrap(
              children: <Widget>[
                Container(
                  padding: EdgeInsets.all(16),
                  child: Text(
                    "Update your profile photo",
                    style: context.theme.textTheme.bodyText1.copyWith(color: Colors.white70),
                  ),
                ),
                ListTile(
                  title: Text("Choose from gallery"),
                  leading: Icon(Icons.image),
                  onTap: () {
                    Navigator.of(context).pop(UpdatePhoto(ImageSource.gallery));
                  },
                ),
                ListTile(
                  title: Text("Use camera"),
                  leading: Icon(Icons.camera_alt),
                  onTap: () {
                    Navigator.of(context).pop(UpdatePhoto(ImageSource.camera));
                  },
                ),
                ListTile(
                  title: Text("Delete photo"),
                  leading: Icon(Icons.delete),
                  onTap: () {
                    Navigator.of(context).pop(DeletePhoto());
                  },
                )
              ],
            ),
          );
        });
  }
}

abstract class ProfilePhotoAction {}

class DeletePhoto extends ProfilePhotoAction {}

class UpdatePhoto extends ProfilePhotoAction {
  final ImageSource source;

  UpdatePhoto(this.source);
}
