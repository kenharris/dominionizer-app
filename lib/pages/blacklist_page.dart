import 'package:flutter/material.dart';

import 'package:dominionizer_app/blocs/blacklist_bloc.dart';
import 'package:dominionizer_app/dialogs/sortDialog.dart';
import 'package:dominionizer_app/widgets/card_cost.dart';
import 'package:dominionizer_app/widgets/drawer.dart';

import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class BlacklistPageState extends State<BlacklistPage> {
  final BlacklistBloc blacklistBloc = BlacklistBloc();

  final double _kingdomCardSize = 14;
  BlacklistSortType _sortType = BlacklistSortType.CardNameAscending;

  Future<void> _confirmEmptyBlacklist() {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Empty Blacklist'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text('Are you sure you'),
                Text('want to empty your blacklist?'),
              ],
            ),
          ),
          actions: <Widget>[
            FlatButton(
              child: Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            FlatButton(
              child: Text('OK'),
              onPressed: () {
                blacklistBloc.emptyBlacklist();
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void _respondToState(BlacklistState state) {
    setState(() {
      _sortType = state.sortType;
    });
  }

  void _showDialog() {
    showDialog<int>(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return SortDialog(_sortType.index, BlacklistSortTypeNames, 300);
        }).then((sortValue) {
      if (sortValue != null) {
        blacklistBloc.sortBlacklist(BlacklistSortType.values[sortValue]);
      }
    });
  }

  @override
  void initState() {
    blacklistBloc.blacklistStream.listen(_respondToState);
    super.initState();
  }

  @override
  Widget build(BuildContext ctxt) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Blacklist Page"),
          actions: <Widget>[
            IconButton(
              icon: Icon(Icons.clear),
              onPressed: () => _confirmEmptyBlacklist(),
            ),
            IconButton(
              icon: Icon(FontAwesomeIcons.sort),
              onPressed: _showDialog,
            )
          ],
        ),
        drawer: new MyDrawer(),
        body: Center(
            child:
                Column(mainAxisAlignment: MainAxisAlignment.center, children: <
                    Widget>[
          Expanded(
              child: StreamBuilder<BlacklistState>(
                  stream: blacklistBloc.blacklistStream,
                  builder: (BuildContext context,
                      AsyncSnapshot<BlacklistState> snapshot) {
                    switch (snapshot.connectionState) {
                      case ConnectionState.waiting:
                        return const CircularProgressIndicator();
                      default:
                        if (snapshot.hasError)
                          return Text('Error: ${snapshot.error}');
                        else if (!snapshot.hasData ||
                            snapshot.data.cards.length == 0)
                          return Align(
                              alignment: Alignment.center,
                              child: const Text(
                                  "Your blacklist is\ncurrently empty",
                                  style: TextStyle(fontSize: 48)));
                        else
                          return ListView.builder(
                              itemCount: snapshot.data.cards.length,
                              itemBuilder: (BuildContext ctxt, int index) {
                                return Dismissible(
                                    background: Container(
                                        color: Theme.of(context).accentColor,
                                        padding: const EdgeInsets.fromLTRB(
                                            16.0, 0, 16.0, 0),
                                        child: Align(
                                          alignment: Alignment.centerRight,
                                          child: new Icon(Icons.delete,
                                              color: Theme.of(context)
                                                  .colorScheme
                                                  .onSecondary),
                                        )),
                                    key: Key(snapshot.data.cards[index].id
                                        .toString()),
                                    onDismissed: (d) {
                                      blacklistBloc.removeCardFromBlacklist(
                                          snapshot.data.cards[index].id);
                                      Scaffold.of(context)
                                          .showSnackBar(SnackBar(
                                        backgroundColor:
                                            Theme.of(context).primaryColorLight,
                                        content: Row(children: [
                                          Text(
                                              "${snapshot.data.cards[index].name}",
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  color: Theme.of(context)
                                                      .buttonColor)),
                                          Text(" removed from blacklist.",
                                              style: TextStyle(
                                                  color: Theme.of(context)
                                                      .primaryColorDark))
                                        ]),
                                        duration: const Duration(seconds: 2),
                                      ));
                                    },
                                    direction: DismissDirection.endToStart,
                                    child: Container(
                                        child: Padding(
                                      padding:
                                          EdgeInsets.fromLTRB(10, 10, 10, 10),
                                      child: Table(children: [
                                        TableRow(children: [
                                          TableCell(
                                              verticalAlignment:
                                                  TableCellVerticalAlignment
                                                      .top,
                                              child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                      snapshot.data.cards[index]
                                                          .name,
                                                      textAlign:
                                                          TextAlign.start,
                                                      style: TextStyle(
                                                          fontSize:
                                                              _kingdomCardSize),
                                                    ),
                                                    CardCost(
                                                      coins: snapshot.data
                                                          .cards[index].coins,
                                                      potions: snapshot.data
                                                          .cards[index].potions,
                                                      debt: snapshot.data
                                                          .cards[index].debt,
                                                      compositePile: snapshot
                                                          .data
                                                          .cards[index]
                                                          .isCompositePile,
                                                    ),
                                                  ])),
                                          TableCell(
                                            verticalAlignment:
                                                TableCellVerticalAlignment.top,
                                            child: Text(
                                              "${snapshot.data.cards[index].setName}",
                                              style: TextStyle(
                                                  fontSize: _kingdomCardSize),
                                            ),
                                          )
                                        ])
                                      ]),
                                    )));
                              });
                    }
                  }))
        ])));
  }
}

class BlacklistPage extends StatefulWidget {
  BlacklistPage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  State<StatefulWidget> createState() => BlacklistPageState();
}
