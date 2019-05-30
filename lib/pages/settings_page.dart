import 'package:dominionizer_app/model/appsettings_model.dart';
import 'package:flutter/material.dart';

import 'package:dominionizer_app/dialogs.dart';
import 'package:provider/provider.dart';

class SettingsPageState extends State<SettingsPage> {
  AppSettingsModel appSettingsModel;

  void _updateSuffleSize(int shuffleSize) {
    Provider.of<AppSettingsModel>(context).shuffleSize = shuffleSize;
  }

  void _setEventsProjectsLandmarksIncluded(int eventsLandmarksProjectsIncluded) {
    Provider.of<AppSettingsModel>(context).eventsLandmarksProjectsIncluded = eventsLandmarksProjectsIncluded;
  }

  void _showDialog(int shuffleSize) {
    showDialog<int>(
        context: context,
        builder: (BuildContext context) {
          return IntListDialog(
              [6, 7, 8, 9, 10, 11, 12, 13, 14, 15], shuffleSize, 10);
        }).then((i) { if (i != null) _updateSuffleSize(i); });
  }

  void _showEventsLandmarksProjectsDialog(int eventsProjectsLandmarksIncluded) {
    showDialog<int>(
        context: context,
        builder: (BuildContext context) {
          return IntListDialog(
              [0, 1, 2, 3], eventsProjectsLandmarksIncluded, 2);
        }).then((i) { if (i != null) _setEventsProjectsLandmarksIncluded(i); });
  }

  @override
  Widget build(BuildContext ctxt) {
    appSettingsModel = Provider.of<AppSettingsModel>(context);

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
                Consumer<AppSettingsModel>(
                  builder: (context, appSettings, child) {
                    return ListTile(
                      title: const Text("Number of cards to be shuffled"),
                      subtitle: const Text("Choose large or small shuffles."),
                      trailing: Text("${appSettings.shuffleSize}"),
                      onTap: () => _showDialog(appSettings.shuffleSize),
                    );
                  },
                ),
                Consumer<AppSettingsModel>(
                  builder: (context, appSettings, child) {
                    return ListTile(
                      title: const Text("How many events/landmarks/projects?"),
                      subtitle: const Text("Randomly include up to this number."),
                      trailing: Text("${appSettings.eventsLandmarksProjectsIncluded}"),
                      onTap: () => _showEventsLandmarksProjectsDialog(appSettings.eventsLandmarksProjectsIncluded),
                    );
                  },
                ),
                Consumer<AppSettingsModel>(
                  builder: (context, appSettings, child) {
                    return ListTile(
                      title: const Text("Auto-blacklist kingdom on new shuffle"),
                      subtitle: const Text(
                          "Play with lesser-known cards by building up a big blacklist."),
                      trailing: Checkbox(
                        activeColor: Theme.of(context).accentColor,
                        value: appSettings.autoBlacklist,
                        onChanged: (b) => 
                          appSettings.autoBlacklist = !appSettings.autoBlacklist,
                      ),
                      onTap: () => 
                        appSettings.autoBlacklist = !appSettings.autoBlacklist
                    );
                  }
                )
              ],
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
