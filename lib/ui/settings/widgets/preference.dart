import 'package:flutter/material.dart';

class Preference extends StatelessWidget {

  final String title;
  final String subtitle;
  final Widget icon;
  final Widget trailing;
  final VoidCallback onTap;

  Preference({
    @required this.title,
    this.subtitle,
    this.icon,
    this.trailing,
    this.onTap
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(title),
      subtitle: subtitle != null ? Text(subtitle) : null,
      leading: icon ?? Container(width: 24, height: 24),
      trailing: trailing,
      onTap: onTap,
    );
  }
}
