import 'package:flutter/material.dart';
import 'package:dominionizer_app/widgets.dart';
import 'package:dominionizer_app/pages.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData.dark(),        
      home: new Scaffold(
        body: KingdomPage(title: 'Flutter Demo Home Page'),
      ),
    );
  }
}