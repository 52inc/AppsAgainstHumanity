import 'package:flutter/material.dart';
import 'package:appsagainsthumanity/internal.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

class CountPreference extends StatelessWidget {
  final String title;
  final String subtitle;
  final int value;
  final int min, max;
  final void Function(int) onValueChanged;

  CountPreference(
    this.value, {
    @required this.title,
    this.subtitle,
    @required this.onValueChanged,
    this.min,
    this.max,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(title),
      subtitle: subtitle != null ? Text(subtitle) : null,
      contentPadding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          IconButton(
            padding: const EdgeInsets.all(8),
            icon: Icon(
              MdiIcons.minus,
              color: Colors.white,
            ),
            onPressed: () {
              var newValue = (value - 1).clamp(min, max);
              onValueChanged(newValue);
            },
          ),
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(color: AppColors.primary, shape: BoxShape.circle),
            alignment: Alignment.center,
            child: Text(
              value.toString(),
              style: context.theme.textTheme.subtitle1.copyWith(color: Colors.white),
            ),
          ),
          IconButton(
            padding: const EdgeInsets.all(8),
            icon: Icon(
              MdiIcons.plus,
              color: Colors.white,
            ),
            onPressed: () {
              var newValue = (value + 1).clamp(min, max);
              onValueChanged(newValue);
            },
          ),
        ],
      ),
    );
  }
}
