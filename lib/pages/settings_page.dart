import 'dart:async';
import 'package:dominionizer_app/dialogs.dart';
import 'package:dominionizer_app/widgets/app_settings.dart';
import 'package:flutter/material.dart';
import 'package:dominionizer_app/blocs/app_bloc.dart';

class SettingsPageState extends State<SettingsPage> {
  bool _isAutoBlacklist = false;
  bool _isDarkTheme = false;
  int _shuffleSize = 10;

  bool _isDirty;

  AppBlocState get _appState => AppSettingsProvider.of(context).state;

  void _updateAllSettings() {
    if (_isDirty) {
      AppSettingsProvider.of(context).updateAllSettings(_shuffleSize, _isAutoBlacklist, _isDarkTheme);
    }
    Navigator.of(context).pop();
  }

  void _updateSuffleSize(int s) {
    setState(() {
      _isDirty = true;
      _shuffleSize = s;
    });
  }

  void _setAutoBlacklist(bool val) {
    setState(() {
      _isDirty = true;
      _isAutoBlacklist = val;
    });
  }

  void _setDarkTheme(bool val) {
    setState(() {
      _isDirty = true;
      _isDarkTheme = val;
    });
  }

  void _showDialog() {
    showDialog<int>(
      context: context,
      builder: (BuildContext context) {
        return IntListDialog([6,7,8,9,10,11,12,13,14,15], _shuffleSize, 10);
      }
    ).then((i) => _updateSuffleSize(i));
  }

  @override
  void initState() {
    _isDirty = false;

    super.initState();
  }

  @override
  void didChangeDependencies() {
    _isAutoBlacklist = _appState.autoBlacklist;
    _isDarkTheme = _appState.isDarkTheme;
    _shuffleSize = _appState.cardsToShuffle;

    super.didChangeDependencies();
  }

  @override
  Widget build (BuildContext ctxt) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: 
        Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            ListView(
              shrinkWrap: true,
              children: <Widget>[
                ListTile(
                  title: const Text("Number of cards to be shuffled"),
                  subtitle: const Text("Choose large or small shuffles."),
                  trailing: Text("$_shuffleSize"),
                  onTap: () => _showDialog(),
                ),
                ListTile(
                  title: const Text("Auto-blacklist kingdom on new shuffle"),
                  subtitle: const Text("Play with lesser-known cards by building up a big blacklist."),
                  trailing: Checkbox(
                    activeColor: Theme.of(context).accentColor,
                    value: _isAutoBlacklist,
                    onChanged: (b) => _setAutoBlacklist(!_isAutoBlacklist),
                  ),
                  onTap: () => _setAutoBlacklist(!_isAutoBlacklist)
                ),
                ListTile(
                  title: const Text("Use dark theme"),
                  subtitle: const Text("Join the dark side."),
                  trailing: Checkbox(
                    activeColor: Theme.of(context).accentColor,
                    value: _isDarkTheme,
                    onChanged: (b) => _setDarkTheme(!_isDarkTheme),
                  ),
                  onTap: () => _setDarkTheme(!_isDarkTheme)
                ),
              ],
            ),
            RaisedButton(
              child: _isDirty
                ? Text("Save Settings", ) 
                : Text("No Changes"),
              onPressed: _isDirty ? _updateAllSettings : null,
            ),
            Expanded(
              child: Align(
                alignment: Alignment.bottomCenter,
                child: Padding(
                  padding: EdgeInsetsDirectional.only(bottom: 25),
                  child: const Text("copyright me"),
                )
              ),
            ),
          ],
        )
    );
  }
}

class SettingsPage extends StatefulWidget {    
  SettingsPage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  SettingsPageState createState() => SettingsPageState();
}