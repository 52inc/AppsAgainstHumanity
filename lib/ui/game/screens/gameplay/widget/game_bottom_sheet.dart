import 'package:appsagainsthumanity/internal.dart';
import 'package:flutter/material.dart';

class GameBottomSheet extends StatelessWidget {
  final Widget child;

  GameBottomSheet({@required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Material(
        clipBehavior: Clip.hardEdge,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(32),
          topRight: Radius.circular(32),
        ),
        color: AppColors.surface,
        elevation: 4,
        child: Container(
          margin: const EdgeInsets.only(top: 8),
          child: Scaffold(
            backgroundColor: Colors.transparent,
            appBar: AppBar(
              backgroundColor: Colors.transparent,
              elevation: 0,
              leading: Container(
                margin: const EdgeInsets.only(left: 8),
                child: IconButton(
                  icon: Icon(Icons.close),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ),
              title: Container(
                margin: const EdgeInsets.only(left: 8),
                child: Text("Players"),
              ),
            ),
            body: child,
          ),
        ),
      ),
    );
  }
}
