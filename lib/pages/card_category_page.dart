import 'package:dominionizer_app/blocs/category_bloc.dart';
import 'package:dominionizer_app/pages/card_page.dart';
import 'package:flutter/material.dart';

import 'package:dominionizer_app/widgets/card_cost.dart';


class CardCategoryPageState extends State<CardCategoryPage> {
  final CardCategoryBloc bloc = new CardCategoryBloc();
  final int cardCategoryId;
  final double _kingdomCardSize = 14;

  CardCategoryPageState(this.cardCategoryId);

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext ctxt) {
    bloc.loadCategoryCards(cardCategoryId);
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        // actions: <Widget>[
        //   IconButton(
        //     icon: Icon(Icons.clear),
        //     onPressed: () => _confirmEmptyBlacklist(),
        //   ),
        //   IconButton(
        //     icon: Icon(FontAwesomeIcons.sort),
        //     onPressed: _showDialog,
        //   )
        // ],
      ),
      body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center, 
            children: <Widget>[
              Expanded(
                child: StreamBuilder<CardCategoryState>(
                  stream: bloc.categoryStream,
                  builder: (BuildContext context, AsyncSnapshot<CardCategoryState> snapshot) {
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
                                  "This category is\ncurrently empty",
                                  style: TextStyle(fontSize: 48)));
                        else
                          return ListView.builder(
                            itemCount: snapshot.data.cards.length,
                            itemBuilder: (BuildContext ctxt, int index) {
                              return GestureDetector(
                                behavior: HitTestBehavior.opaque,
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    new MaterialPageRoute(builder: (ctxt) => CardPage(snapshot.data.cards[index])),
                                  );
                                },
                                child: Container(
                                  child: Padding(
                                    padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
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
                                                    style: TextStyle(
                                                      fontSize: _kingdomCardSize
                                                    ),
                                                  ),
                                                  CardCost(
                                                    coins: snapshot.data.cards[index].coins,
                                                    potions: snapshot.data.cards[index].potions,
                                                    debt: snapshot.data.cards[index].debt,
                                                    compositePile: snapshot.data.cards[index].isCompositePile,
                                                  ),
                                                ]
                                              )
                                            ),
                                            TableCell(
                                              verticalAlignment: TableCellVerticalAlignment.top,
                                              child: Text(
                                                "${snapshot.data.cards[index].setName}",
                                                style: TextStyle(
                                                  fontSize: _kingdomCardSize
                                                ),
                                              ),
                                            )
                                          ]
                                        )
                                      ]
                                    ),
                                  ),
                                ),
                              );
                            }
                          );
                    }
                  }
                )
              ),
            ]
          )
      )
    );
  }
}

class CardCategoryPage extends StatefulWidget {
  CardCategoryPage({Key key, this.title, this.categoryId}) : super(key: key);

  final String title;
  final int categoryId;

  @override
  State<StatefulWidget> createState() => new CardCategoryPageState(categoryId);
}
