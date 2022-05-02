// import 'dart:io';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:appsagainsthumanity/data/firestore.dart';
import 'package:appsagainsthumanity/internal.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class JoinRoomDialog extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _JoinRoomDialogState();
}

class _JoinRoomDialogState extends State<JoinRoomDialog> {
  final TextEditingController _gameInputController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey();

  @override
  void dispose() {
    _gameInputController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          margin: const EdgeInsets.only(left: 24, right: 24, top: 24),
          child: Form(
            key: _formKey,
            child: TextFormField(
              controller: _gameInputController,
              decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Game ID',
                  labelStyle: context.theme.textTheme.caption),
              maxLength: FirebaseConstants.MAX_GID_SIZE,
              maxLengthEnforcement: MaxLengthEnforcement.enforced,
              keyboardType: TextInputType.text,
              autofocus: true,
              textCapitalization: TextCapitalization.characters,
              textInputAction: TextInputAction.go,
              onFieldSubmitted: (value) {
                Navigator.of(context).pop(value);
              },
              validator: (value) {
                if (value?.length != FirebaseConstants.MAX_GID_SIZE) {
                  return 'Please enter a valid game id';
                }
                return null;
              },
            ),
          ),
        ),
        Container(
          margin: const EdgeInsets.only(bottom: 8, top: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              TextButton(
                child: Text(
                  'CANCEL',
                  style: TextStyle(
                    color: AppColors.primary,
                  ),
                ),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
              TextButton(
                child: Text(
                  'JOIN',
                  style: TextStyle(
                    color: AppColors.primary,
                  ),
                ),
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    var gameId = _gameInputController.text;
                    Navigator.of(context).pop(gameId);
                  }
                },
              )
            ],
          ),
        )
      ],
    );
  }
}

Future<String?> showJoinRoomDialog(BuildContext context) {
  if (kIsWeb) {
    return showGeneralDialog<String>(
      context: context,
      pageBuilder: (context, _, __) {
        return Theme(
          data: AppThemes.dark,
          child: AlertDialog(
            title: Text('Join a game'),
            content: JoinRoomDialog(),
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            contentPadding: const EdgeInsets.all(0),
          ),
        );
      },
    );
  } else {
    return showDialog<String>(
      context: context,
      builder: (builderContext) {
        return Theme(
          data: AppThemes.dark,
          child: AlertDialog(
            title: Text('Join a game'),
            content: JoinRoomDialog(),
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            contentPadding: const EdgeInsets.all(0),
          ),
        );
      },
    );
  }
}
