import 'package:flutter/material.dart';
import '../widgets/drawer.dart';
import '../blocs/kingdom_bloc.dart';

class KingdomPageState extends State<KingdomPage> {
  final KingdomBloc kingdomBloc = KingdomBloc();

  bool _loading = false;

  void _respondToState(KingdomBlocState state) {
    setState(() {
      _loading = state.isLoading;
    });
  }

  void _newShuffle() {
    setState(() {
      _loading = true;
    });

    kingdomBloc.kingdomEventSink.add(DrawKingdomEvent());
  }

  @override
  Widget build (BuildContext ctxt) {
    kingdomBloc.kingdomStream.listen(_respondToState);
    return Scaffold(
      appBar: AppBar(
        title: Text("Kingdom Page"),
      ),
      drawer: new MyDrawer(),
      body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              const Text("Kingdom", style: TextStyle(fontSize: 25),),
              FlatButton(
                color: Colors.red,
                child: _loading 
                  ? Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Icon(Icons.warning),
                      Text("Loading..."),
                    ],
                  )
                  : Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Icon(Icons.shuffle),
                      Text("Shuffle!"),
                    ],
                  ),
                onPressed: _newShuffle,
              ),
              Expanded(
                child: StreamBuilder<KingdomBlocState>(
                  stream: kingdomBloc.kingdomStream,
                  builder: (BuildContext context, AsyncSnapshot<KingdomBlocState> snapshot) {
                    switch (snapshot.connectionState) {
                      case ConnectionState.waiting:
                        return const CircularProgressIndicator();
                      default:
                        if (snapshot.hasError)
                          return Text('Error: ${snapshot.error}');
                        else
                          return ListView.builder
                          (
                            itemCount: snapshot.data.cards.length,
                            itemBuilder: (BuildContext ctxt, int index) {
                              return Container(
                                decoration: const BoxDecoration(
                                  border:Border(
                                    top:BorderSide(width: 1.0, color: Colors.green),
                                    bottom:BorderSide(width: 1.0, color: Colors.green),
                                    left:BorderSide(width: 1.0, color: Colors.green),
                                    right:BorderSide(width: 1.0, color: Colors.green)
                                  )
                                ),
                                child: ListTile(
                                  title: Text(
                                    snapshot.data.cards[index].name, 
                                    textAlign: TextAlign.start
                                  ),
                                  onTap: () => {}
                                ),
                              );
                            }
                          );
                    }
                  }
                )
              )
            ]
          )
        )
      );
  }
}
class KingdomPage extends StatefulWidget {    
  KingdomPage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  State<StatefulWidget> createState() => KingdomPageState();
}