import 'package:appsagainsthumanity/internal.dart';
import 'package:appsagainsthumanity/ui/home/widgets/home_outline_button.dart';
import 'package:appsagainsthumanity/ui/settings/settings_screen.dart';
import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

class SettingsWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return HomeOutlineButton(
      icon: Icon(
        MdiIcons.cog,
        color: AppColors.primaryVariant,
      ),
      text: "Settings",
      onTap: () {
        Analytics().logSelectContent(contentType: 'action', itemId: 'settings');
        Navigator.of(context).push(MaterialPageRoute(builder: (_) => SettingsScreen()));
      },
    );
  }
}
