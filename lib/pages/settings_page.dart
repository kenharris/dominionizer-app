import 'dart:async';
import 'package:dominionizer_app/dialogs.dart';
import 'package:flutter/material.dart';
import 'package:dominionizer_app/model/appsetting.dart';

class SettingsPageState extends State<SettingsPage> {
  bool _autoBlacklist = false;
  int _shuffleSize = 10;

  final sc = StreamController<int>();

  void _updateSuffleSize(int s) {
    setState(() {
      _shuffleSize = s;
    });
  }

  @override
  void initState() {
    sc.stream.listen(_updateSuffleSize);
    super.initState();
  }

  @override
  void dispose() {
    sc.close();
    super.dispose();
  }

  void _setAutoBlacklist(bool val) {
    setState(() {
      _autoBlacklist = val;   
    });
  }

  void _showDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return IntListDialog([6,7,8,9,10,11,12,13,14,15], 10, 10, sc.sink);
      }
    );
  }

  @override
  Widget build (BuildContext ctxt) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
          child:ListView(
            children: <Widget>[
              ListTile(
                title: const Text("Number of cards to be shuffled"),
                subtitle: const Text("Choose large or small shuffles."),
                trailing: Text("${_shuffleSize}"),
                onTap: () => _showDialog(),
              ),
              ListTile(
                title: const Text("Auto-blacklist kingdom on new shuffle"),
                subtitle: const Text("Play with lesser-known cards by building up a big blacklist."),
                trailing: Checkbox(
                  value: _autoBlacklist,
                  onChanged: (b) => _setAutoBlacklist(!_autoBlacklist),
                ),
                onTap: () => _setAutoBlacklist(!_autoBlacklist)
              ),
            ],
          )
          // child: ListView.builder(
          //   itemCount: _settings.length,
          //   itemBuilder: (BuildContext ctxt, int index) {
          //     return GestureDetector(
          //       child: ListTile(
          //         title: Text(_settings[index].name),
          //         subtitle: Text(_settings[index].description),
          //         trailing: (_settings[index].value is AppSettingBooleanValue) ? 
          //                   Checkbox(
          //                     value: (_settings[index].value as AppSettingBooleanValue).value,
          //                     onChanged: (b) => _updateBooleanAppSettingValue(index, b),
          //                   )
          //                   : Text("${_settings[index].stringValue}"),
          //         onTap: () => { },
          //       ) 
          //     );
          //   }
          // )
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