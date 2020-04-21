import 'package:flutter/material.dart';

class AppColors {
    AppColors._();

    static const primary = Color(0xFFF44336);
    static const primaryDark = Color(0xFFB71C1C);
    static const primaryVariant = Color(0xFFEF5350);

    static const secondary = Color(0xFF00BCD4);
    static const secondaryLight = Color(0xFF80DEEA);
    static const secondaryDark = Color(0xFF006064);

    static const surface = Color(0xFF3C3C3C);
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
            accentColor: AppColors.secondary,
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
