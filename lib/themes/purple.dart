/**
 * Creating custom color palettes is part of creating a custom app. The idea is to create
 * your class of custom colors, in this case `CompanyColors` and then create a `ThemeData`
 * object with those colors you just defined.
 *
 * Resource:
 * A good resource would be this website: http://mcg.mbitson.com/
 * You simply need to put in the colour you wish to use, and it will generate all shades
 * for you. Your primary colour will be the `500` value.
 *
 * Colour Creation:
 * In order to create the custom colours you need to create a `Map<int, Color>` object
 * which will have all the shade values. `const Color(0xFF...)` will be how you create
 * the colours. The six character hex code is what follows. If you wanted the colour
 * #114488 or #D39090 as primary colours in your theme, then you would have
 * `const Color(0x114488)` and `const Color(0xD39090)`, respectively.
 *
 * Usage:
 * In order to use this newly created theme or even the colours in it, you would just
 * `import` this file in your project, anywhere you needed it.
 * `import 'path/to/theme.dart';`
 */

import 'package:flutter/material.dart';

final ThemeData PurpleThemeData = new ThemeData(
  brightness: Brightness.dark,
  primarySwatch: MaterialColor(PurpleThemeColors.purple[500].value, PurpleThemeColors.purple),
  primaryColor: PurpleThemeColors.purple[500],
  primaryColorBrightness: Brightness.dark,
  accentColor: PurpleThemeColors.amber[500],
  accentColorBrightness: Brightness.light
);
  
class PurpleThemeColors {
  PurpleThemeColors._();
  static const Map<int, Color> purple = const <int, Color> {
    50: const Color(0xffece9f1),
    100: const Color(0xffd0c7dc),
    200: const Color(0xffb1a2c5),
    300: const Color(0xff927dad),
    400: const Color(0xff7a619c),
    500: const Color(0xff63458a),
    600: const Color(0xff5b3e82),
    700: const Color(0xff513677),
    800: const Color(0xff472e6d),
    900: const Color(0xff351f5a)
  };
  
  static const Map<int, Color> gray = const <int, Color> {
    50: const Color(0xffEBEBEC),
    100: const Color(0xFFCECED1),
    200: const Color(0xFFADADB2),
    300: const Color(0xFF8C8C93),
    400: const Color(0xFF74747B),
    500: const Color(0xFF5B5B64),
    600: const Color(0xFF53535C),
    700: const Color(0xFF494952),
    800: const Color(0xFF404048),
    900: const Color(0xFF2F2F36)
  };

  static const Map<int, Color> amber = const <int, Color> {
    50: const Color(0xFFFDF8E6),
    100: const Color(0xFFFBEDC2),
    200: const Color(0xFFF8E199),
    300: const Color(0xFFF5D470),
    400: const Color(0xFFF3CB51),
    500: const Color(0xFFF1C232),
    600: const Color(0xFFEFBC2D),
    700: const Color(0xFFEDB426),
    800: const Color(0xFFEBAC1F),
    900: const Color(0xFFE79F13)
  };
}