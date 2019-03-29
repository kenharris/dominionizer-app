import 'package:flutter/material.dart';

import 'package:dominionizer_app/blocs/settings_bloc.dart';
import 'package:dominionizer_app/dialogs.dart';
import 'package:dominionizer_app/widgets/app_settings.dart';

class SettingsPageState extends State<SettingsPage> {
  bool _isAutoBlacklist = false;
  bool _isDarkTheme = false;
  int _shuffleSize = 10;
  int _eventsProjectsLandmarksIncluded = 2;

  bool _isDirty;

  SettingsState get settingsState => AppSettingsProvider.of(context).state;

  void _updateAllSettings() {
    if (_isDirty) {
      AppSettingsProvider.of(context)
          .updateAllSettings(_shuffleSize, _isAutoBlacklist, _isDarkTheme, _eventsProjectsLandmarksIncluded);
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

  void _setEventsProjectsLandmarksIncluded(int val) {
    setState(() {
      _isDirty = true;
      _eventsProjectsLandmarksIncluded = val;
    });
  }

  void _showDialog() {
    showDialog<int>(
        context: context,
        builder: (BuildContext context) {
          return IntListDialog(
              [6, 7, 8, 9, 10, 11, 12, 13, 14, 15], _shuffleSize, 10);
        }).then((i) => _updateSuffleSize(i));
  }

  void _showEventsLandmarksProjectsDialog() {
    showDialog<int>(
        context: context,
        builder: (BuildContext context) {
          return IntListDialog(
              [0, 1, 2, 3], _eventsProjectsLandmarksIncluded, 2);
        }).then((i) => _setEventsProjectsLandmarksIncluded(i));
  }

  @override
  void initState() {
    _isDirty = false;

    super.initState();
  }

  @override
  void didChangeDependencies() {
    _isAutoBlacklist = settingsState.autoBlacklist;
    _isDarkTheme = settingsState.isDarkTheme;
    _shuffleSize = settingsState.cardsToShuffle;
    _eventsProjectsLandmarksIncluded =settingsState.eventsLandmarksProjectsIncluded;

    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext ctxt) {
    return Scaffold(
        appBar: AppBar(
          title: Text(widget.title),
        ),
        body: Column(
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
                  title: const Text("How many events/landmarks/projects?"),
                  subtitle: const Text("Randomly include up to this number."),
                  trailing: Text("$_eventsProjectsLandmarksIncluded"),
                  onTap: () => _showEventsLandmarksProjectsDialog(),
                ),
                ListTile(
                    title: const Text("Auto-blacklist kingdom on new shuffle"),
                    subtitle: const Text(
                        "Play with lesser-known cards by building up a big blacklist."),
                    trailing: Checkbox(
                      activeColor: Theme.of(context).accentColor,
                      value: _isAutoBlacklist,
                      onChanged: (b) => _setAutoBlacklist(!_isAutoBlacklist),
                    ),
                    onTap: () => _setAutoBlacklist(!_isAutoBlacklist)),
                ListTile(
                    title: const Text("Use dark theme"),
                    subtitle: const Text("Join the dark side."),
                    trailing: Checkbox(
                      activeColor: Theme.of(context).accentColor,
                      value: _isDarkTheme,
                      onChanged: (b) => _setDarkTheme(!_isDarkTheme),
                    ),
                    onTap: () => _setDarkTheme(!_isDarkTheme)),
              ],
            ),
            RaisedButton(
              child: _isDirty
                  ? Text(
                      "Save Settings",
                    )
                  : Text("No Changes"),
              onPressed: _isDirty ? _updateAllSettings : null,
            ),
            Expanded(
              child: Align(
                  alignment: Alignment.bottomCenter,
                  child: Padding(
                    padding: EdgeInsetsDirectional.only(bottom: 25),
                    child: const Text("copyright me"),
                  )),
            ),
          ],
        ));
  }
}

class SettingsPage extends StatefulWidget {
  SettingsPage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  SettingsPageState createState() => SettingsPageState();
}
