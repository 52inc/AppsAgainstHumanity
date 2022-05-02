import 'package:flutter/material.dart';
import 'package:appsagainsthumanity/internal.dart';

class PreferenceHeader extends StatelessWidget {
  final String title;
  final bool includeIconSpacing;

  PreferenceHeader({
    required this.title,
    this.includeIconSpacing = true,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(left: includeIconSpacing ? 72 : 16, right: 16),
      height: 48,
      width: double.maxFinite,
      alignment: Alignment.centerLeft,
      child: Text(
        title,
        style: context.theme.textTheme.subtitle2?.copyWith(
          color: context.primaryColor,
        ),
      ),
    );
  }
}
