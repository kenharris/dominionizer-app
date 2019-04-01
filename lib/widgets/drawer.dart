import 'package:dominionizer_app/pages/blacklist_page.dart';
import 'package:flutter/material.dart';
import 'package:dominionizer_app/pages.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

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
          SizedBox(
            height: 125,
            child: DrawerHeader(
              child: Text('Dominionizer'),
              decoration: BoxDecoration(
                color: Theme.of(context).primaryColor,
              ),
            ),
          ),
          ListTile(
            leading: Icon(FontAwesomeIcons.checkCircle),
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
            leading: Icon(FontAwesomeIcons.crown),
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
            leading: Icon(FontAwesomeIcons.solidTimesCircle),
            title: Text('Manage Blacklist'),
            onTap: () {
              Navigator.of(context).pop();
              Navigator.push(
                context,
                new MaterialPageRoute(builder: (ctx) => new BlacklistPage(title: "Manage Blacklist"))
              );
            },
          ),
          ListTile(
            leading: Icon(FontAwesomeIcons.cogs),
            title: Text('Settings'),
            onTap: () {
              Navigator.of(context).pop();
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