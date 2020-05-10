import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class AppColors {
    AppColors._();

    static const primary = Color(0xFFAB47BC);
    static const primaryDark = Color(0xFF790e8b);
    static const primaryVariant = Color(0xFFdf78ef);
    static const colorOnPrimary = Color(0xFFFFFFFF);
    static const colorOnPrimaryVariant = Color(0xDD000000);

    static const secondary = Color(0xFF00BCD4);
    static const secondaryLight = Color(0xFF80DEEA);
    static const secondaryDark = Color(0xFF006064);

    static const surface = Color(0xFF3C3C3C);
    static const surfaceLight = Color(0xFF4F4F4F);
    static const surfaceDark = Color(0xFF303030);
    static const responseCardBackground = Color(0xFFF2F2F2);

    static const error = Color(0xFFFF5252);

    static const addPhotoBackground = Color(0xFF666666);
    static const addPhotoForeground = Colors.white70;
}

class AppThemes {
    AppThemes._();

    static ThemeData get light {
        final textTheme = Typography.material2018(platform: defaultTargetPlatform).white;
        return ThemeData(
            brightness: Brightness.light,
            primaryColor: AppColors.primary,
            primaryColorDark: AppColors.primaryDark,
            primaryColorLight: AppColors.primaryVariant,
            accentColor: AppColors.primary,
            canvasColor: AppColors.surface,
            cardColor: Colors.white,
            textTheme: textTheme,
            iconTheme: const IconThemeData(color: Colors.white),
            disabledColor: Colors.white38,
            unselectedWidgetColor: Colors.white70,
            dialogBackgroundColor: Colors.grey[700],
            appBarTheme: AppBarTheme(
                color: AppColors.surfaceDark
            ),
            snackBarTheme: SnackBarThemeData(
                backgroundColor: AppColors.surfaceLight,
                contentTextStyle: textTheme.subtitle1,
                actionTextColor: AppColors.primary,
                disabledActionTextColor: Colors.white30,
            ),
            bottomAppBarColor: AppColors.surfaceDark,
        );
    }

    static ThemeData get dark =>
        ThemeData(
            brightness: Brightness.dark,
            primaryColor: AppColors.primaryVariant,
            primaryColorDark: AppColors.primaryDark,
            primaryColorLight: AppColors.primaryVariant,
            floatingActionButtonTheme: FloatingActionButtonThemeData(
                foregroundColor: Colors.white
            ),
            accentColor: AppColors.primaryVariant,
            cardColor: Colors.grey[700],
            appBarTheme: AppBarTheme(
                color: AppColors.surface
            ),
            snackBarTheme: SnackBarThemeData(
                backgroundColor: AppColors.surfaceDark,
                contentTextStyle: Typography.material2018(platform: defaultTargetPlatform).white.subtitle1,
                actionTextColor: AppColors.primary,
                disabledActionTextColor: Colors.white30,
            ),
            bottomAppBarColor: AppColors.surface,
        );
}

extension TextAppearanceExt on BuildContext {

    TextStyle cardTextStyle(Color textColor) {
        final base = theme.textTheme.headline5;
        final screenWidth = MediaQuery.of(this).size.width;

        double fontSize = base.fontSize;
        if (screenWidth > 360 && screenWidth <= 400) {
            fontSize = 20.0; // Headline 6 Size
        } else if (screenWidth > 300 && screenWidth <= 360) {
            fontSize = 18.0; // Subtitle 1
        } else if (screenWidth <= 300) {
            fontSize = 16.0;
        }

        return base.copyWith(
            color: textColor,
            fontSize: fontSize
        );
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

    Color get colorOnCard {
        var brightness = theme.brightness;
        if (brightness == Brightness.dark) {
            return Colors.white;
        } else {
            return Colors.black87;
        }
    }

    Color get secondaryColorOnCard {
        var brightness = theme.brightness;
        if (brightness == Brightness.dark) {
            return Colors.white54;
        } else {
            return Colors.black38;
        }
    }

    Color get tertiaryColorOnCard {
        var brightness = theme.brightness;
        if (brightness == Brightness.dark) {
            return Colors.white38;
        } else {
            return Colors.black26;
        }
    }

    Color get responseCardColor {
        var brightness = theme.brightness;
        if (brightness == Brightness.dark) {
            return Colors.grey[600];
        } else {
            return AppColors.responseCardBackground;
        }
    }

    Color get responseCardHandColor {
        var brightness = theme.brightness;
        if (brightness == Brightness.dark) {
            return Colors.grey[500];
        } else {
            return AppColors.responseCardBackground;
        }
    }

    Color get responseBorderColor {
        var brightness = theme.brightness;
        if (brightness == Brightness.dark) {
            return Colors.white12;
        } else {
            return Colors.black12;
        }
    }
}
