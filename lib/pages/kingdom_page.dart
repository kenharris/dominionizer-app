import 'package:dominionizer_app/blocs/sets_bloc.dart';
import 'package:dominionizer_app/blocs/settings_bloc.dart';
import 'package:dominionizer_app/dialogs/sortDialog.dart';
import 'package:dominionizer_app/model/dominion_card.dart';
import 'package:dominionizer_app/model/dominion_set.dart';
import 'package:dominionizer_app/widgets/app_settings.dart';
import 'package:dominionizer_app/widgets/kingom_card_item.dart';
import 'package:flutter/material.dart';
import 'package:dominionizer_app/widgets/drawer.dart';
import 'package:dominionizer_app/blocs/kingdom_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class KingdomPageState extends State<KingdomPage> {
  final KingdomBloc kingdomBloc = KingdomBloc();
  final SetsBloc setsBloc = SetsBloc();

  KingdomSortType _sortType = KingdomSortType.CardNameAscending;

  int _cardsToShuffle;
  bool _autoBlacklist;

  List<DominionSet> _sets;
  ScaffoldState _scaffold;

  void _respondToState(KingdomState state) {
    setState(() {
      _sortType = state.sortType;
    });
  }

  void _swapCard(DominionCard card) {
    kingdomBloc.exchangeCard(card, _sets.map((ds) => ds.id).toList());
  }

  void _undoSwap() {
    kingdomBloc.undoExchange();
  }

  void _respondToSwap(SwapState state) {
    if (state.initialCard != null &&
        state.swappedCard != null &&
        _scaffold != null) {
      if (state.wasUndo) {
        _scaffold.hideCurrentSnackBar();
        _scaffold.showSnackBar(SnackBar(
          backgroundColor: Theme.of(context).buttonColor,
          content: Row(children: [
            Text("Card exchange undone.",
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).accentColor)),
          ]),
          duration: const Duration(seconds: 2),
        ));
      } else {
        _scaffold.hideCurrentSnackBar();
        _scaffold.showSnackBar(SnackBar(
          backgroundColor: Theme.of(context).buttonColor,
          content: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Flexible(
                    flex: 0,
                    child: Text("${state.initialCard.name}",
                        softWrap: true,
                        overflow: TextOverflow.ellipsis,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Theme.of(context).accentColor,
                            decoration: TextDecoration.underline))),
                Expanded(
                  child: Icon(
                    FontAwesomeIcons.longArrowAltRight,
                    size: 18,
                    color: Theme.of(context).accentColor,
                  ),
                ),
                Flexible(
                  flex: 1,
                  child: Text("${state.swappedCard.name}",
                      softWrap: true,
                      overflow: TextOverflow.ellipsis,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).accentColor,
                          decoration: TextDecoration.underline)),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 8.0),
                  child: GestureDetector(
                    child: Icon(FontAwesomeIcons.undo,
                        size: 12, color: Theme.of(context).accentColor),
                    onTap: () {
                      _undoSwap();
                    },
                  ),
                )
              ]),
          duration: const Duration(seconds: 2),
        ));
      }
    }
  }

  void _newShuffle() {
    List<int> setIds = _sets.map((si) => si.id).toList();
    kingdomBloc.drawNewKingdom(
        shuffleSize: _cardsToShuffle,
        autoBlacklist: _autoBlacklist,
        setIds: setIds);
  }

  void _onSetInitialize(SetsBlocState setsState) {
    _sets = setsState.sets.where((s) => s.included).toList();
  }

  void _onAppStateChange(SettingsState appState) {
    _autoBlacklist = appState.autoBlacklist;
    _cardsToShuffle = appState.cardsToShuffle;
  }

  void _showDialog() {
    showDialog<int>(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return SortDialog(
              _sortType?.index ?? KingdomSortType.CardNameAscending,
              KingdomSortTypeNames,
              400);
        }).then((sortType) {
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
    kingdomBloc.swapStream.listen(_respondToSwap);

    super.initState();
  }

  @override
  Widget build(BuildContext ctxt) {
    SettingsBloc appBloc = AppSettingsProvider.of(context);
    appBloc.appStateStream
        .where((s) =>
            s.autoBlacklist != _autoBlacklist ||
            s.cardsToShuffle != _cardsToShuffle)
        .listen(_onAppStateChange);
    appBloc.initialize();
    return Scaffold(
        appBar: AppBar(
          title: Text("Kingdom Page"),
          actions: <Widget>[
            StreamBuilder<SettingsState>(
                stream: appBloc.appStateStream,
                builder: (BuildContext context,
                    AsyncSnapshot<SettingsState> snapshot) {
                  switch (snapshot.connectionState) {
                    case ConnectionState.waiting:
                      return const CircularProgressIndicator();
                    default:
                      return IconButton(
                        icon: Icon(FontAwesomeIcons.dice),
                        onPressed: _newShuffle,
                      );
                  }
                }),
            StreamBuilder<KingdomState>(
                stream: kingdomBloc.kingdomStream,
                builder: (BuildContext context,
                    AsyncSnapshot<KingdomState> snapshot) {
                  switch (snapshot.connectionState) {
                    default:
                      if (snapshot.hasError)
                        return Text('Error: ${snapshot.error}');
                      else if (!snapshot.hasData ||
                          snapshot.data.cards.length == 0)
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
                }),
          ],
        ),
        drawer: new MyDrawer(),
        body: Center(
            child:
                Column(mainAxisAlignment: MainAxisAlignment.center, children: <
                    Widget>[
          Expanded(
              child: StreamBuilder<KingdomState>(
                  stream: kingdomBloc.kingdomStream,
                  builder: (BuildContext context,
                      AsyncSnapshot<KingdomState> snapshot) {
                    switch (snapshot.connectionState) {
                      case ConnectionState.waiting:
                        return const CircularProgressIndicator();
                      default:
                        if (snapshot.hasError)
                          return Text('Error: ${snapshot.error}');
                        else if (!snapshot.hasData ||
                            snapshot.data.totalCards == 0)
                          return Align(
                              alignment: Alignment.center,
                              child: const Text(
                                "Tap the dice to\ngenerate a kingdom.",
                                style: TextStyle(fontSize: 36),
                                textAlign: TextAlign.center,
                              ));
                        else
                          return ListView.builder(
                              itemCount: snapshot.data.totalCards,
                              itemBuilder: (BuildContext ctxt, int index) {
                                if (index <
                                    snapshot.data.numberOfKingdomCards) {
                                  return Dismissible(
                                      background: Container(
                                          color: Theme.of(context).accentColor,
                                          padding: const EdgeInsets.fromLTRB(
                                              16.0, 0, 16.0, 0),
                                          child: Align(
                                            alignment: Alignment.centerRight,
                                            child: new Icon(
                                                FontAwesomeIcons.random,
                                                color: Theme.of(context)
                                                    .colorScheme
                                                    .onSecondary),
                                          )),
                                      key: Key(snapshot.data.cards[index].id
                                          .toString()),
                                      onDismissed: (d) {
                                        _scaffold = Scaffold.of(context);
                                        _swapCard(snapshot.data.cards[index]);
                                      },
                                      direction: DismissDirection.endToStart,
                                      child: KingdomCardItem(
                                          card: snapshot.data.cards[index],
                                          isBroughtCard: false,
                                          topBorder: false));
                                } else if (index >=
                                        snapshot.data.numberOfKingdomCards &&
                                    index <
                                        (snapshot.data.numberOfKingdomCards +
                                            snapshot
                                                .data.numberOfBroughtCards)) {
                                  return KingdomCardItem(
                                    card: snapshot.data.broughtCards[index -
                                        snapshot.data.numberOfKingdomCards],
                                    isBroughtCard: true,
                                    topBorder: index ==
                                        snapshot.data.numberOfKingdomCards,
                                  );
                                } else {
                                  // Events, Landmarks, and Projects
                                  return KingdomCardItem(
                                    card: snapshot.data.eventsLandmarksProjects[
                                        index -
                                            snapshot.data.numberOfKingdomCards -
                                            snapshot.data.numberOfBroughtCards],
                                    isEventProjectOrLandmark: true,
                                    topBorder: index ==
                                        (snapshot.data.numberOfKingdomCards +
                                            snapshot.data.numberOfBroughtCards),
                                  );
                                }
                              });
                    }
                  }))
        ])));
  }
}

class KingdomPage extends StatefulWidget {
  KingdomPage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  State<StatefulWidget> createState() => KingdomPageState();
}
