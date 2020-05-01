import 'package:appsagainsthumanity/internal.dart';
import 'package:flutter/material.dart';

class GameBottomSheet extends StatelessWidget {
  final String title;
  final String subtitle;
  final Widget child;
  final List<Widget> actions;

  GameBottomSheet({this.title, this.subtitle, @required this.child, this.actions});

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
              actions: actions,
              centerTitle: false,
              iconTheme: context.theme.iconTheme,
              textTheme: context.theme.textTheme,
              leading: Container(
                margin: const EdgeInsets.only(left: 8),
                child: IconButton(
                  icon: Icon(Icons.close),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ),
              title: _buildTitle(context),
            ),
            body: child,
          ),
        ),
      ),
    );
  }

  Widget _buildTitle(BuildContext context) {
    if (title != null) {
      if (subtitle != null) {
        return Container(
          margin: const EdgeInsets.only(left: 8),
          child: Column(
            children: [
              Text(title),
              Text(
                subtitle,
                style: context.theme.textTheme.bodyText1.copyWith(
                  color: Colors.black38,
                ),
              )
            ],
          ),
        );
      } else {
        return Container(
          margin: const EdgeInsets.only(left: 8),
          child: Text(title),
        );
      }
    }
    return null;
  }
}
