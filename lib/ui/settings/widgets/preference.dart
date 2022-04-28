import 'package:flutter/material.dart';
import 'package:appsagainsthumanity/internal.dart';

class Preference extends StatelessWidget {
  final String title;
  final Color titleColor;
  final FontWeight titleWeight;
  final String subtitle;
  final Widget icon;
  final Widget trailing;
  final VoidCallback onTap;

  Preference({
    required this.title,
    required this.titleColor,
    required this.titleWeight,
    required this.subtitle,
    required this.icon,
    required this.trailing,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(
        title,
        style: context.theme.textTheme.subtitle1
            ?.copyWith(color: titleColor, fontWeight: titleWeight),
      ),
      subtitle: subtitle != null
          ? Text(
              subtitle,
              style: context.theme.textTheme.bodyText1?.copyWith(
                color: context.secondaryColorOnCard,
              ),
            )
          : null,
      leading: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8),
        child: icon,
      ),
      trailing: trailing,
      onTap: onTap,
    );
  }
}
