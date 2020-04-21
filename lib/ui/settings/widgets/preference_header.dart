import 'package:flutter/material.dart';
import 'package:appsagainsthumanity/internal.dart';

class PreferenceHeader extends StatelessWidget {

  final String title;

  PreferenceHeader({@required this.title});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(left: 72, right: 16),
      height: 48,
      width: double.maxFinite,
      alignment: Alignment.centerLeft,
      child: Text(
        title,
        style: context.theme.textTheme.subtitle2.copyWith(color: context.primaryColor),
      ),
    );
  }
}
