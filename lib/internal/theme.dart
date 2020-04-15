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
}

class AppThemes {
    AppThemes._();

    static ThemeData get light =>
        ThemeData(
            brightness: Brightness.dark,
            primaryColor: AppColors.primary,
            primaryColorDark: AppColors.primaryDark,
            primaryColorLight: AppColors.primaryVariant,
            accentColor: AppColors.secondary,
            canvasColor: AppColors.surface
        );

    static ThemeData get dark =>
        ThemeData(
            brightness: Brightness.dark
        );

    static AppBarTheme get darkAppBarTheme {
        return AppBarTheme(
            textTheme: TextTheme(
                headline6: TextStyle(
                    color: AppColors.primaryVariant,
                    fontSize: 20,
                    fontWeight: FontWeight.w500
                )
            )
        );
    }

    static Color inverseBackgroundColor(BuildContext context) {
        var brightness = context.theme.brightness;
        return brightness == Brightness.dark
            ? light.backgroundColor
            : dark.backgroundColor;
    }
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
