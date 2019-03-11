import 'package:dominionizer_app/blocs/app_bloc.dart';
import 'package:dominionizer_app/blocs/sets_bloc.dart';
import 'package:dominionizer_app/dialogs/kingdomSortDialog.dart';
import 'package:dominionizer_app/model/setinfo.dart';
import 'package:dominionizer_app/widgets/app_settings.dart';
import 'package:flutter/material.dart';
import '../widgets/drawer.dart';
import '../blocs/kingdom_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class KingdomPageState extends State<KingdomPage> {
  final KingdomBloc kingdomBloc = KingdomBloc();
  final SetsBloc setsBloc = SetsBloc();

  final double _kingdomCardSize = 10;
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
    kingdomBloc.kingdomEventSink.add(DrawKingdomEvent(shuffleSize: _cardsToShuffle, autoBlacklist: _autoBlacklist, setIds: setIds));
  }

  List<Widget> _buildCostChildren(int coins, int potions, int debt) {
    List<Widget> builder = List<Widget>();

    double size = 12;
    double iconSize = 8;
    double space = 4;
    TextStyle style = TextStyle(fontSize: size);

    if (coins > 0) {
      builder.add(Text("$coins", style: style));
      builder.add(Icon(FontAwesomeIcons.coins, size: iconSize, color: Colors.yellow,));
    }

    if (potions > 0) {
      if (coins > 0)
        builder.add(SizedBox(width: space));

      if (potions > 1) {
        builder.add(Text("$potions", style: style));
      }
      builder.add(Icon(FontAwesomeIcons.flask, size: iconSize, color: Colors.blue));
    }

    if (debt > 0) {
      if (coins > 0 || potions > 0)
        builder.add(SizedBox(width: space));

      builder.add(Text("$debt", style: style));
      builder.add(Icon(FontAwesomeIcons.drawPolygon, size: iconSize));
    }

    return builder;
  }  

  void _onSetInitialize(SetsBlocState setsState) {
    _sets = setsState.sets.where((s) => s.included).toList();
  }

  void _onAppStateChange(AppBlocState appState) {
    _autoBlacklist = appState.autoBlacklist;
    _cardsToShuffle =appState.cardsToShuffle;
  }

  void _showDialog() {
    showDialog<KingdomSortType>(
      context: context,
      builder: (BuildContext context) {
        return KingdomSortDialog(_sortType);
      }
    ).then((kst) {
      kingdomBloc.kingdomEventSink.add(SortKingdomEvent(kst));
    });
  }

  @override
  void initState() {
    kingdomBloc.kingdomStream.listen(_respondToState);
    setsBloc.sets.listen(_onSetInitialize);

    super.initState();
  }

  @override
  Widget build (BuildContext ctxt) {
    AppBloc appBloc = AppSettingsProvider.of(context);
    appBloc.appStateStream.where((s) => s.autoBlacklist !=_autoBlacklist || s.cardsToShuffle !=_cardsToShuffle).listen(_onAppStateChange);
    appBloc.appEventSink.add(InitializeAppEvent());
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
          IconButton(
            icon: Icon(FontAwesomeIcons.sort),
            onPressed: _showDialog,
          )
        ],
      ),
      drawer: new MyDrawer(),
      body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              const Text("Kingdom", style: TextStyle(fontSize: 25)),
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
                                                Row(
                                                  children: _buildCostChildren(snapshot.data.cards[index].coins, snapshot.data.cards[index].potions, snapshot.data.cards[index].debt)
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