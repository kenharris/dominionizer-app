import 'package:dominionizer_app/blocs/app_bloc.dart';
import 'package:dominionizer_app/blocs/blacklist_bloc.dart';
import 'package:dominionizer_app/dialogs/kingdomSortDialog.dart';
import 'package:dominionizer_app/model/setinfo.dart';
import 'package:dominionizer_app/widgets/app_settings.dart';
import 'package:dominionizer_app/widgets/cardCost.dart';
import 'package:flutter/material.dart';
import '../widgets/drawer.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class BlacklistPageState extends State<BlacklistPage> {
  final BlacklistBloc blacklistBloc = BlacklistBloc();

  final double _kingdomCardSize = 10;
  BlacklistSortType _sortType = BlacklistSortType.CardNameAscending;

  int _cardsToShuffle;
  bool _autoBlacklist;

  List<SetInfo> _sets;

  void _respondToState(BlacklistState state) {
    setState(() {
      _sortType = state.sortType;
    });
  }  

  void _onAppStateChange(AppBlocState appState) {
    _autoBlacklist = appState.autoBlacklist;
    _cardsToShuffle = appState.cardsToShuffle;
  }

  // void _showDialog() {
  //   showDialog<BlacklistSortType>(
  //     context: context,
  //     builder: (BuildContext context) {
  //       return KingdomSortDialog(_sortType);
  //     }
  //   ).then((bst) {
  //     blacklistBloc.sortBlacklist(bst);
  //   });
  // }

  @override
  void initState() {
    blacklistBloc.blacklistStream.listen(_respondToState);
    super.initState();
  }

  @override
  Widget build (BuildContext ctxt) {
    AppBloc appBloc = AppSettingsProvider.of(context);
    appBloc.appStateStream.where((s) => s.autoBlacklist !=_autoBlacklist || s.cardsToShuffle !=_cardsToShuffle).listen(_onAppStateChange);
    appBloc.initialize();
    return Scaffold(
      appBar: AppBar(
        title: Text("Blacklist Page"),
        actions: <Widget>[
          StreamBuilder<AppBlocState>(
            stream: appBloc.appStateStream,
            builder: (BuildContext context, AsyncSnapshot<AppBlocState> snapshot) {
              switch (snapshot.connectionState) {
                case ConnectionState.waiting:
                  return const CircularProgressIndicator();
                default:
                  return IconButton(
                    icon: Icon(Icons.clear),
                    onPressed: () {},
                  );
              }
            }
          ),
          IconButton(
            icon: Icon(FontAwesomeIcons.sort),
            // onPressed: _showDialog,
            onPressed: () {},
          )
        ],
      ),
      drawer: new MyDrawer(),
      body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Expanded(
                child: StreamBuilder<BlacklistState>(
                  stream: blacklistBloc.blacklistStream,
                  builder: (BuildContext context, AsyncSnapshot<BlacklistState> snapshot) {
                    switch (snapshot.connectionState) {
                      case ConnectionState.waiting:
                        return const CircularProgressIndicator();
                      default:
                        if (snapshot.hasError)
                          return Text('Error: ${snapshot.error}');
                        else if (!snapshot.hasData || snapshot.data.cards.length == 0)
                          return Align(
                            alignment: Alignment.center,
                            child: const Text("Your blacklist is\ncurrently empty", style: TextStyle(fontSize: 48))
                          );
                        else
                          return ListView.builder
                          (
                            itemCount: snapshot.data.cards.length,
                            itemBuilder: (BuildContext ctxt, int index) {
                              return Dismissible(
                                background: Container(
                                  color: Colors.red,
                                  padding: const EdgeInsets.fromLTRB(16.0, 0, 16.0, 0),
                                  child: Align(
                                    alignment: Alignment.centerRight,
                                    child: new Icon(Icons.delete),
                                  )
                                ),
                                key: Key(snapshot.data.cards[index].id.toString()),
                                onDismissed: (d) {
                                  blacklistBloc.removeCardFromBlacklist(snapshot.data.cards[index].id);
                                  Scaffold.of(context).showSnackBar(SnackBar(
                                    content: Row(
                                      children: [
                                        Text("${snapshot.data.cards[index].name}", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.red)),
                                        Text(" removed from blacklist.")
                                      ]
                                    ),
                                    backgroundColor: Theme.of(context).dialogBackgroundColor,
                                    duration: const Duration(seconds: 2),
                                  ));
                                },
                                direction: DismissDirection.endToStart,
                                child: Container(
                                  decoration: const BoxDecoration(
                                    border:Border(
                                      top:BorderSide(width: 1.0, color: Colors.green),
                                      bottom:BorderSide(width: 1.0, color: Colors.green),
                                      left:BorderSide(width: 1.0, color: Colors.green),
                                      right:BorderSide(width: 1.0, color: Colors.green)
                                    )
                                  ),
                                  child: Padding(
                                    padding: EdgeInsets.fromLTRB(10, 5, 10, 5),
                                    child: Table(
                                      children: [
                                        TableRow(
                                          children: [
                                            TableCell(
                                              verticalAlignment: TableCellVerticalAlignment.top,
                                              child: Column(
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    snapshot.data.cards[index].name, 
                                                    textAlign: TextAlign.start,
                                                    style: TextStyle(fontSize: _kingdomCardSize),
                                                  ),
                                                  CardCost(
                                                    snapshot.data.cards[index].coins, 
                                                    snapshot.data.cards[index].potions, 
                                                    snapshot.data.cards[index].debt
                                                  ),
                                                ]
                                              ) 
                                            ),
                                            TableCell(
                                              verticalAlignment: TableCellVerticalAlignment.top,
                                              child: Text(
                                                "${snapshot.data.cards[index].setName}",
                                                style: TextStyle(fontSize: _kingdomCardSize),
                                              ),
                                            )
                                          ]
                                        )
                                      ]
                                    ),
                                  )
                                )
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
class BlacklistPage extends StatefulWidget {    
  BlacklistPage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  State<StatefulWidget> createState() => BlacklistPageState();
}