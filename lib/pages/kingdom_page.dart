import 'package:dominionizer_app/blocs/app_bloc.dart';
import 'package:dominionizer_app/blocs/sets_bloc.dart';
import 'package:dominionizer_app/dialogs/sortDialog.dart';
import 'package:dominionizer_app/model/setinfo.dart';
import 'package:dominionizer_app/widgets/app_settings.dart';
import 'package:dominionizer_app/widgets/cardCost.dart';
import 'package:flutter/material.dart';
import '../widgets/drawer.dart';
import '../blocs/kingdom_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class KingdomPageState extends State<KingdomPage> {
  final KingdomBloc kingdomBloc = KingdomBloc();
  final SetsBloc setsBloc = SetsBloc();

  final double _kingdomCardSize = 14;
  KingdomSortType _sortType = KingdomSortType.CardNameAscending;

  int _cardsToShuffle;
  bool _autoBlacklist;

  List<SetInfo> _sets;

  void _respondToState(KingdomBlocState state) {
    setState(() {
      _sortType = state.sortType;
    });
  }

  void _newShuffle() {
    List<int> setIds = _sets.map((si) => si.id.index).toList();
    kingdomBloc.drawNewKingdom(shuffleSize: _cardsToShuffle, autoBlacklist: _autoBlacklist, setIds: setIds);
  }

  void _onSetInitialize(SetsBlocState setsState) {
    _sets = setsState.sets.where((s) => s.included).toList();
  }

  void _onAppStateChange(AppBlocState appState) {
    _autoBlacklist = appState.autoBlacklist;
    _cardsToShuffle = appState.cardsToShuffle;
  }

  void _showDialog() {
    showDialog<int>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return SortDialog(_sortType.index, KingdomSortTypeNames, 400);
      }
    ).then((sortType) {
      if (sortType != null) {
        kingdomBloc.sortKingdom(KingdomSortType.values[sortType]);
      }
    });
  }

  @override
  void initState() {
    kingdomBloc.kingdomStream.listen(_respondToState);
    setsBloc.sets.listen(_onSetInitialize);
    setsBloc.initialize();

    super.initState();
  }

  @override
  Widget build (BuildContext ctxt) {
    AppBloc appBloc = AppSettingsProvider.of(context);
    appBloc.appStateStream.where((s) => s.autoBlacklist !=_autoBlacklist || s.cardsToShuffle !=_cardsToShuffle).listen(_onAppStateChange);
    appBloc.initialize();
    return Scaffold(
      appBar: AppBar(
        title: Text("Kingdom Page"),
        actions: <Widget>[
          StreamBuilder<AppBlocState>(
            stream: appBloc.appStateStream,
            builder: (BuildContext context, AsyncSnapshot<AppBlocState> snapshot) {
              switch (snapshot.connectionState) {
                case ConnectionState.waiting:
                  return const CircularProgressIndicator();
                default:
                  return IconButton(
                    icon: Icon(FontAwesomeIcons.dice),
                    onPressed: _newShuffle,
                  );
              }
            }
          ),
          StreamBuilder<KingdomBlocState>(
            stream: kingdomBloc.kingdomStream,
            builder: (BuildContext context, AsyncSnapshot<KingdomBlocState> snapshot) {
              switch (snapshot.connectionState) {
                default:
                  if (snapshot.hasError)
                    return Text('Error: ${snapshot.error}');
                  else if (!snapshot.hasData || snapshot.data.cards.length == 0)
                    return IconButton(
                      icon: Icon(FontAwesomeIcons.sort),
                      onPressed: null,
                    );
                  else
                    return IconButton(
                      icon: Icon(FontAwesomeIcons.sort),
                      onPressed: _showDialog,
                    );
              }
            }
          ),
        ],
      ),
      drawer: new MyDrawer(),
      body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
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
                        else if (!snapshot.hasData || snapshot.data.cards.length == 0)
                          return Align(
                            alignment: Alignment.center,
                            child: const Text(
                              "Tap the dice to\ngenerate a kingdom.", 
                              style: TextStyle(fontSize: 36),
                              textAlign: TextAlign.center,
                            )
                          );
                        else
                          return ListView.builder
                          (
                            itemCount: snapshot.data.cards.length,
                            itemBuilder: (BuildContext ctxt, int index) {
                              return Container(
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