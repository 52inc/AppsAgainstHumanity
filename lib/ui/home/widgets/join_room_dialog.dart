import 'dart:io';

import 'package:appsagainsthumanity/internal.dart';
import 'package:flutter/material.dart';

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
              ),
              maxLength: 5,
              maxLengthEnforced: true,
              keyboardType: TextInputType.text,
              autofocus: true,
              textCapitalization: TextCapitalization.characters,
              textInputAction: TextInputAction.go,
              onFieldSubmitted: (value) {
                Navigator.of(context).pop(value);
              },
              validator: (value) {
                if (value.length != 5) {
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
              FlatButton(
                child: Text('CANCEL'),
                textColor: AppColors.primary,
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
              FlatButton(
                child: Text('JOIN'),
                textColor: AppColors.primary,
                onPressed: () {
                  if (_formKey.currentState.validate()) {
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

Future<String> showJoinRoomDialog(BuildContext context) {
  if (!Platform.isAndroid && !Platform.isIOS) {
    return showGeneralDialog<String>(
        context: context,
        pageBuilder: (context, _, __) {
          return AlertDialog(
            title: Text('Join a game'),
            content: JoinRoomDialog(),
            contentPadding: const EdgeInsets.all(0),
          );
        });
  } else {
    return showDialog<String>(
        context: context,
        builder: (builderContext) {
          return AlertDialog(
            title: Text('Join a game'),
            content: JoinRoomDialog(),
            contentPadding: const EdgeInsets.all(0),
          );
        });
  }
}
