import 'package:flutter/material.dart';
import '../pages/settings.dart';
import '../pages/kingdom.dart';
import '../pages/setselection.dart';

class MyDrawer extends StatefulWidget {  
  @override
  _MyDrawerState createState() => _MyDrawerState();
}

class _MyDrawerState extends State<MyDrawer> {
  @override
  Widget build(BuildContext context) {
    return new Drawer(
      // Add a ListView to the drawer. This ensures the user can scroll
      // through the options in the Drawer if there isn't enough vertical
      // space to fit everything.
      child: ListView(
        // Important: Remove any padding from the ListView.
        padding: EdgeInsets.zero,
        children: <Widget>[
          DrawerHeader(
            child: Text('Drawer Header'),
            decoration: BoxDecoration(
              color: Colors.blue,
            ),
          ),
          ListTile(
            title: Text('Set Selection'),
            onTap: () {
              Navigator.of(context).pop();
              Navigator.push(
                context,
                new MaterialPageRoute(builder: (ctxt) => new SetSelectionPage(pageTitle: "Select Sets")),
              );
            },
          ),
          ListTile(
            title: Text('Kingdom'),
            onTap: () {
              Navigator.of(context).pop();
              Navigator.push(
                context,
                new MaterialPageRoute(builder: (ctxt) => new KingdomPage(title: "Kingdom")),
              );
            },
          ),
          ListTile(
            title: Text('Settings'),
            onTap: () {
              Navigator.push(
                context,
                new MaterialPageRoute(builder: (ctx) => new SettingsPage(title: "Settings"))
              );
            },
          ),
        ],
      )
    );
  }
}