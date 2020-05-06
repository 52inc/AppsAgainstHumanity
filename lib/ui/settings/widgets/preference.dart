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
    @required this.title,
    this.titleColor,
    this.titleWeight,
    this.subtitle,
    this.icon,
    this.trailing,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(
        title,
        style: context.theme.textTheme.subtitle1.copyWith(
          color: titleColor ?? context.colorOnCard,
          fontWeight: titleWeight ?? FontWeight.normal
        ),
      ),
      subtitle: subtitle != null
          ? Text(
              subtitle,
              style: context.theme.textTheme.bodyText1.copyWith(
                color: context.secondaryColorOnCard,
              ),
            )
          : null,
      leading: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8),
        child: icon ?? Container(width: 24, height: 24),
      ),
      trailing: trailing,
      onTap: onTap,
    );
  }
}
