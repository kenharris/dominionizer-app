import 'package:flutter/material.dart';
import 'package:dominionizer_app/widgets.dart';

class SetSelectionPage extends StatelessWidget {
  final String pageTitle;

  SetSelectionPage({this.pageTitle});
  
  @override
  Widget build (BuildContext ctxt) {
    return Scaffold(
      appBar: AppBar(
        title: Text(pageTitle),
      ),
      drawer: new MyDrawer(),
      body: ServiceProviderWidget(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Expanded(
                child: SetsList()
              )
            ],
          ),
        ) 
      )
    );
  }
}