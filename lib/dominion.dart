import 'package:dominionizer_app/blocs/app_bloc.dart';
import 'package:dominionizer_app/pages.dart';
import 'package:dominionizer_app/widgets/app_settings.dart';
import 'package:flutter/material.dart';

class DominionizerTheme {
  final ThemeData theme;
  final ColorScheme scheme;

  static Map<int, Color> _materialColorMap =
  {
    50:Color.fromRGBO(136,14,79, .1),
    100:Color.fromRGBO(136,14,79, .2),
    200:Color.fromRGBO(136,14,79, .3),
    300:Color.fromRGBO(136,14,79, .4),
    400:Color.fromRGBO(136,14,79, .5),
    500:Color.fromRGBO(136,14,79, .6),
    600:Color.fromRGBO(136,14,79, .7),
    700:Color.fromRGBO(136,14,79, .8),
    800:Color.fromRGBO(136,14,79, .9),
    900:Color.fromRGBO(136,14,79, 1),
  };

  DominionizerTheme(this.scheme) :
    theme = ThemeData.light().copyWith(
      colorScheme: scheme,
      primaryColor: scheme.primary,
      accentColor: scheme.primaryVariant,
      backgroundColor: scheme.background,
      selectedRowColor: scheme.primaryVariant,
      unselectedWidgetColor: scheme.secondaryVariant,
      dialogBackgroundColor: scheme.background,
      buttonColor: scheme.primary,
      toggleableActiveColor: scheme.secondary,
      disabledColor: scheme.background,
      buttonTheme: ButtonThemeData(
        colorScheme: scheme,
        disabledColor: Colors.green,
        buttonColor: Colors.red,
        highlightColor: Colors.orange,
        splashColor: Colors.pink
      )
    );
}

// class PurpleTheme extends DominionizerTheme {
//   // https://coolors.co/e4b7e5-b288c0-7e5a9b-63458a-9a48d0
//   PurpleTheme() : super([
//     Color(0xFF7E5A9B), // Dark lavender
//     Color(0xFFE4B7E5), // Light orchid
//     Color(0xFFB288C0), // African violet
//     Color(0xFF63458A), // Cyber grape
//     Color(0xFF9A48D0), // Dark orchid
//   ]);  
// }

// class OliveTheme extends DominionizerTheme {
//   // https://coolors.co/e4b7e5-b288c0-7e5a9b-63458a-9a48d0
//   OliveTheme() : super([
//     Color(0xFF433E0E), // Pullman green
//     Color(0xFFEDEEC0), // Pale spring bud
//     Color(0xFF7C9082), // Mummy's tomb
//     Color(0xFFA7A284), // Grullo
//     Color(0xFFD0C88E), // Tan
//   ]);  
// }

class BluesTheme extends DominionizerTheme {
  // https://coolors.co/05668d-d0ccd0-f9fffd-605856-274156
  BluesTheme() : super(ColorScheme.fromSwatch(
    primarySwatch: MaterialColor(Color(0xFF05668D).value, DominionizerTheme._materialColorMap),
    accentColor: Color(0xFF605856),
    backgroundColor: Color(0xFFD0CCD0),
    brightness: Brightness.light,
    cardColor: Color(0xF9FFFD),
    errorColor: Colors.red,
    primaryColorDark: Color(0xFF274156)));
}

class RandomizerWidgetState extends State<RandomizerWidget> {
  bool _isDarkTheme = false;

  void _reactToState(AppBlocState state) {
    if (state != null && _isDarkTheme != state.isDarkTheme) {
      setState(() {
        _isDarkTheme = state.isDarkTheme ?? false;
      });
    }
  }

  @override
  Widget build (BuildContext ctxt) {
    AppSettingsProvider.of(context).appStateStream.listen(_reactToState);
    return MaterialApp(
      title: 'Flutter Demo',
      // theme: BluesTheme().theme,
      theme: (_isDarkTheme) ? ThemeData.dark() : ThemeData.light(),
      // theme: ThemeData(
      //   // Define the default Brightness and Colors
      //   brightness: Brightness.dark,
      //   primaryColor: Colors.lightBlue[800],
      //   accentColor: Colors.cyan[600],
        
      //   // backgroundColor: Colors.red,
      //   // dialogBackgroundColor: Colors.purple,

      //   // Define the default Font Family
      //   fontFamily: 'Montserrat',
        
      //   // Define the default TextTheme. Use this to specify the default
      //   // text styling for headlines, titles, bodies of text, and more.
      //   textTheme: TextTheme(
      //     headline: TextStyle(fontSize: 72.0, fontWeight: FontWeight.bold),
      //     title: TextStyle(fontSize: 36.0, fontStyle: FontStyle.italic),
      //     body1: TextStyle(fontSize: 14.0, fontFamily: 'Hind'),
      //   ),
      // ),
      home: new Scaffold(
        body: KingdomPage(title: 'Flutter Demo Home Page'),
      ),
    );
  }
}

class RandomizerWidget extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => RandomizerWidgetState();
}