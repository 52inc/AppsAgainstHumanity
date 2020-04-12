import 'package:flutter/material.dart';

class AppColors {
    AppColors._();

    static const primary = Color(0xFFef5350);
    static const primaryDark = Color(0xFFb61827);
    static const primaryVariant = Color(0xFFff867c);

    static const secondary = Color(0xFF50ecef);
    static const secondaryLight = Color(0xFF8effff);
    static const secondaryDark = Color(0xFF00b9bd);
}

class AppThemes {
    AppThemes._();

    static ThemeData get light => ThemeData(
        brightness: Brightness.light,
        primaryColor: AppColors.primary,
        primaryColorDark: AppColors.primaryDark,
        primaryColorLight: AppColors.primaryVariant,
        accentColor: AppColors.secondary,
    );

    static ThemeData get dark => ThemeData(
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
