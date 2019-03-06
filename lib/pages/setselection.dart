import 'package:flutter/material.dart';
import '../model/setinfo.dart';
import 'package:dominionizer_app/data/repository.dart';
import '../structure/drawer.dart';

class SetSelectionState extends State<SetSelectionPage> {  
  Future<List<SetInfo>> _sets;
  Repository _repo =Repository.get();

  void _toggleSelectedState (int index) async
  {
    List<SetInfo> s = await _sets;
    s[index].selected = !s[index].selected;
    bool updated = await _repo.updateSetInfos(s);
    if (updated) {
      setState(() {});
    }
  }

  @override
  void initState() {
    super.initState();
    _sets = _repo.getSetInfos();
  }

  @override
  Widget build (BuildContext ctxt) {
    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
      ),
      drawer: new MyDrawer(),
      body: Center(
        // Center is a layout widget. It takes a single child and positions it
        // in the middle of the parent.
        child: Column(
          // Column is also layout widget. It takes a list of children and
          // arranges them vertically. By default, it sizes itself to fit its
          // children horizontally, and tries to be as tall as its parent.
          //
          // Invoke "debug painting" (press "p" in the console, choose the
          // "Toggle Debug Paint" action from the Flutter Inspector in Android
          // Studio, or the "Toggle Debug Paint" command in Visual Studio Code)
          // to see the wireframe for each widget.
          //
          // Column has various properties to control how it sizes itself and
          // how it positions its children. Here we use mainAxisAlignment to
          // center the children vertically; the main axis here is the vertical
          // axis because Columns are vertical (the cross axis would be
          // horizontal).
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            new Expanded(              
              child: FutureBuilder<List<SetInfo>>(
                future: _sets,
                builder: (BuildContext context, AsyncSnapshot<List<SetInfo>> snapshot) {
                  switch (snapshot.connectionState) {
                    case ConnectionState.waiting:
                      return const CircularProgressIndicator();
                    default:
                      if (snapshot.hasError)
                        return Text('Error: ${snapshot.error}');
                      else
                        return ListView.builder
                        (
                          itemCount: snapshot.data.length,
                          itemBuilder: (BuildContext ctxt, int index) {
                            return new GestureDetector(
                              child: Text(snapshot.data[index].name, style: TextStyle(color: (snapshot.data[index].selected) ? Colors.red : Colors.black)),
                              onTap: () => _toggleSelectedState(index)
                            ); 
                          }
                        );
                  }
                }
              )
            )
          ],
        ),
      ) 
    );
  }
}

class SetSelectionPage extends StatefulWidget {    
  SetSelectionPage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  SetSelectionState createState() => SetSelectionState();
}