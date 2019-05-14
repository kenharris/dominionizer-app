import 'package:dominionizer_app/widgets/drawer.dart';
import 'package:flutter/material.dart';

import 'package:dominionizer_app/blocs/rules_bloc.dart';
import 'package:dominionizer_app/dialogs.dart';

class RulesPageState extends State<RulesPage> {
  RulesBloc rulesBloc = RulesBloc();

  // void _showDialog() {
  //   showDialog<int>(
  //       context: context,
  //       builder: (BuildContext context) {
  //         return IntListDialog(
  //             [6, 7, 8, 9, 10, 11, 12, 13, 14, 15], _shuffleSize, 10);
  //       }).then((i) => _updateSuffleSize(i));
  // }

  // void _showEventsLandmarksProjectsDialog() {
  //   showDialog<int>(
  //       context: context,
  //       builder: (BuildContext context) {
  //         return IntListDialog(
  //             [0, 1, 2, 3], _eventsProjectsLandmarksIncluded, 2);
  //       }).then((i) => _setEventsProjectsLandmarksIncluded(i));
  // }

  // void onData(RulesState event) {
  //   setState(() {
  //     _shuffleSize = event.cardsToShuffle;
  //     _isAutoBlacklist = event.autoBlacklist;
  //     _eventsProjectsLandmarksIncluded = event.eventsLandmarksProjectsIncluded;
  //   });
  // }

  @override
  void initState() {
    // rulesBloc.stream.listen(onData);
    rulesBloc.initialize();
    super.initState();
  }
    
  @override
  Widget build(BuildContext ctxt) {
    return Scaffold(
        appBar: AppBar(
          title: Text(widget.title),
        ),
        drawer: new MyDrawer(),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.fromLTRB(15, 10, 15, 0),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "Include Card Categories",
                  style: new TextStyle(
                    fontSize: 18, 
                    fontWeight: FontWeight.bold, 
                    decoration: TextDecoration.underline
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(15, 0, 15, 0),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "Choose categories from which at least one card must be present in shuffled kingdom",
                  style: new TextStyle(fontSize: 9),
                ),
              ),
            ),
            Expanded(
              child: StreamBuilder(
                stream: rulesBloc.stream,
                // initialData: initialData ,
                builder: (BuildContext context, AsyncSnapshot<RulesState> snapshot){
                  switch (snapshot.connectionState) {
                        case ConnectionState.waiting:
                          return const CircularProgressIndicator();
                        default:
                          if (snapshot.hasError)
                            return Text('Error: ${snapshot.error}');
                          else if (!snapshot.hasData ||
                              snapshot.data.categories.length == 0)
                            return Align(
                                alignment: Alignment.center,
                                child: const Text(
                                    "Card categories not retrieved.",
                                    style: TextStyle(fontSize: 48)));
                          else
                            return ListView.builder(
                              itemCount: snapshot.data.categories.length,
                              itemBuilder: (BuildContext context, int index) {
                                return ListTile(
                                  title: Text("${snapshot.data.categories[index].name} (${snapshot.data.categories[index].count})"),
                                  subtitle: Text(snapshot.data.categories[index].description),
                                  trailing: Switch(
                                    value: snapshot.data.getCategoryValue(snapshot.data.categories[index].id),
                                    onChanged: (newValue) async {
                                      await rulesBloc.updateRule(snapshot.data.categories[index].id, newValue);
                                    },
                                  ),
                                  // onTap: () => _showDialog(),
                                );
                              },
                            );
                  }
                },
              ),
            ),
            // RaisedButton(
            //   child: _isDirty
            //       ? Text(
            //           "Save Settings",
            //         )
            //       : Text("No Changes"),
            //   onPressed: _isDirty ? _updateAllSettings : null,
            // ),
            // Expanded(
            //   child: Align(
            //       alignment: Alignment.bottomCenter,
            //       child: Padding(
            //         padding: EdgeInsetsDirectional.only(bottom: 25),
            //         child: const Text("copyright me"),
            //       )),
            // ),
          ],
        ));
  }
}

class RulesPage extends StatefulWidget {
  RulesPage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  RulesPageState createState() => RulesPageState();
}
