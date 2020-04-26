import 'package:flutter/material.dart';

class AppColors {
    AppColors._();

    static const primary = Color(0xFFAB47BC);
    static const primaryDark = Color(0xFF790e8b);
    static const primaryVariant = Color(0xFFdf78ef);

    static const secondary = Color(0xFF00BCD4);
    static const secondaryLight = Color(0xFF80DEEA);
    static const secondaryDark = Color(0xFF006064);

    static const surface = Color(0xFF3C3C3C);
    static const surfaceLight = Color(0xFF4F4F4F);
    static const surfaceDark = Color(0xFF303030);
    static const responseCardBackground = Color(0xFFF2F2F2);
}

class AppThemes {
    AppThemes._();

    static ThemeData get app =>
        ThemeData(
            brightness: Brightness.dark,
            primaryColor: AppColors.primary,
            primaryColorDark: AppColors.primaryDark,
            primaryColorLight: AppColors.primaryVariant,
            accentColor: AppColors.primary,
            canvasColor: AppColors.surface
        );
}

extension ThemeExt on BuildContext {

    ThemeData get theme => Theme.of(this);

    Color get primaryColor {
        var brightness = theme.brightness;
        if (brightness == Brightness.dark) {
            return AppColors.primaryVariant;
        } else {
            return AppColors.primary;
        }
    }
}
