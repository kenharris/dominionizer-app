import 'package:dominionizer_app/blocs/settings_bloc.dart';
import 'package:dominionizer_app/dialogs/sortDialog.dart';
import 'package:dominionizer_app/model/dominion_card.dart';
import 'package:dominionizer_app/widgets/kingom_card_item.dart';
import 'package:dominionizer_app/widgets/swap_card_snackbar.dart';
import 'package:dominionizer_app/widgets/undo_swap_card_snackbar.dart';
import 'package:flutter/material.dart';
import 'package:dominionizer_app/widgets/drawer.dart';
import 'package:dominionizer_app/blocs/kingdom_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class KingdomPageState extends State<KingdomPage> {
  final KingdomBloc kingdomBloc = KingdomBloc();
  final SettingsBloc settingsBloc = SettingsBloc();

  KingdomSortType _sortType = KingdomSortType.CardNameAscending;

  ScaffoldState _scaffold;

  void _respondToState(KingdomState state) {
    setState(() {
      _sortType = state.sortType;
    });
  }

  void _swapCard(DominionCard card) {
    kingdomBloc.exchangeCard(card);
  }

  void _swapEventLandmarkProject(DominionCard card) {
    kingdomBloc.exchangeEventLandmarkProject(card);
  }

  void _respondToSwap(SwapState state) {
    if (state.initialCard != null &&
        state.swappedCard != null &&
        _scaffold != null) {
      if (state.wasUndo) {
        _scaffold.hideCurrentSnackBar();
        _scaffold.showSnackBar(SnackBar(
          backgroundColor: Theme.of(context).buttonColor,
          content: UndoSwapCardSnackbar(),
          duration: const Duration(seconds: 2),
        ));
      } else {
        _scaffold.hideCurrentSnackBar();
        _scaffold.showSnackBar(SnackBar(
          backgroundColor: Theme.of(context).buttonColor,
          content: SwapCardSnackbar(
            initialCardName: state.initialCard.name,
            swappedCardName: state.swappedCard.name,
            undoFunc: () => kingdomBloc.undoExchange()
          ),
          duration: const Duration(seconds: 2),
        ));
      }
    }
  }

  void _newShuffle() {
    kingdomBloc.drawNewKingdom();
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
    kingdomBloc.swapStream.listen(_respondToSwap);
    settingsBloc.initialize();
    super.initState();
  }

  @override
  Widget build(BuildContext ctxt) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Current Kingdom"),
          actions: <Widget>[
            StreamBuilder<SettingsState>(
                stream: settingsBloc.stream,
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
                                    key: Key(snapshot.data.eventsLandmarksProjects[index - snapshot.data.numberOfKingdomCards - snapshot.data.numberOfBroughtCards].id
                                        .toString()),
                                    onDismissed: (d) {
                                      _scaffold = Scaffold.of(context);
                                      _swapEventLandmarkProject(snapshot.data.eventsLandmarksProjects[index - snapshot.data.numberOfKingdomCards - snapshot.data.numberOfBroughtCards]);
                                    },
                                    direction: DismissDirection.endToStart,
                                    child: KingdomCardItem(
                                        card:
                                            snapshot.data
                                                    .eventsLandmarksProjects[index - snapshot.data.numberOfKingdomCards - snapshot.data.numberOfBroughtCards],
                                        isEventProjectOrLandmark: true,
                                        topBorder: index ==
                                            (snapshot
                                                    .data.numberOfKingdomCards +
                                                snapshot.data
                                                    .numberOfBroughtCards)),
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
