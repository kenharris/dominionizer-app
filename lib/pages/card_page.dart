import 'package:dominionizer_app/blocs/card_details_bloc.dart';
import 'package:dominionizer_app/model/dominion_card.dart';
import 'package:dominionizer_app/widgets/card_cost.dart';
import 'package:dominionizer_app/widgets/card_text.dart';
import 'package:dominionizer_app/widgets/kingom_card_item.dart';
import 'package:flutter/material.dart';

class CardPageState extends State<CardPage> {
  CardDetailsBloc bloc = CardDetailsBloc();

  final double detailFontSize = 12;

  @override
  void initState() {
    bloc.loadBroughtCards(widget._card.id);
    bloc.loadConstituentCards(widget._card.id);
    super.initState();
  }

  @override
  void dispose() {
    bloc.dispose();
    super.dispose();
  }

  List<Widget> _cardInfoWidgets() {
    List<Widget> builder = List<Widget>();

    builder.add(
      Padding(
        padding: EdgeInsets.all(10),
        child: Text("${widget._card.name}",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 24,
            decoration: TextDecoration.underline
          )
        )
      )
    );

    builder.add(
      Padding(
        padding:EdgeInsets.all(5),
        child: Text("${widget._card.sets.join(", ")}"),
      )
    );

    builder.add(
      Padding(
        padding:EdgeInsets.all(5),
        child: Text("${widget._card.types.join(", ")}"),
      )
    );
    
    if (widget._card.totalCost > 0) {
      builder.add(
        Padding(
          padding: EdgeInsets.all(10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text("Cost: ", style: TextStyle(fontSize: 18)),
              CardCost(
                coins: widget._card.coins,
                potions: widget._card.potions,
                debt: widget._card.debt,
                compositePile: widget._card.isCompositePile,
                fontSize: 18,
                iconSize: 10
              )
            ]
          )
        ),
      );
    }

    if (widget._card.topText.trim().isNotEmpty || widget._card.bottomText.trim().isNotEmpty) {
      builder.add(
        Padding(
          padding: EdgeInsets.all(10),
          child: CardText(
            top: widget._card.topText,
            bottom: widget._card.bottomText,
            fontSize: detailFontSize,
          )
        ),
      );
    }

    return builder.toList();                        
  }
  @override
  Widget build(BuildContext ctxt) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Card Details"),
      ),
      body: Padding(
        padding: EdgeInsets.fromLTRB(30, 10, 30, 10),
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Column(
                children: _cardInfoWidgets(),
              ),
              StreamBuilder<CardDetailsState>(
                stream: bloc.cardDetailsStream,
                builder: (BuildContext context,
                    AsyncSnapshot<CardDetailsState> snapshot) {
                  if (snapshot.hasData &&
                      (snapshot.data.constituentCards != null &&
                          snapshot.data.constituentCards.length > 0)) {
                    return Container(
                      padding: EdgeInsets.all(10),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          Text(
                            "This card pile is composed of the following cards:",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: detailFontSize,
                              fontWeight: FontWeight.bold,
                              decoration: TextDecoration.underline
                            )
                          ),
                          Column(
                            children:
                              snapshot.data.constituentCards.map((dc) => KingdomCardItem(
                                card: dc,
                                borders: false,
                              )
                            ).toList()
                          )
                        ],
                      ),
                    );
                  } else {
                    return Container();
                  }
                },
              ),
              StreamBuilder<CardDetailsState>(
                stream: bloc.cardDetailsStream,
                builder: (BuildContext context,
                    AsyncSnapshot<CardDetailsState> snapshot) {
                  if (snapshot.hasData &&
                      (snapshot.data.broughtCards != null &&
                          snapshot.data.broughtCards.length > 0)) {
                    return Container(
                      padding: EdgeInsets.all(10),
                      child: Column(
                        children: <Widget>[
                          Text("This card pile brings the following cards:",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: detailFontSize,
                              fontWeight: FontWeight.bold,
                              decoration: TextDecoration.underline
                            )
                          ),
                          Column(
                            children: snapshot.data.broughtCards.map((dc) =>
                              KingdomCardItem(
                                card: dc,
                                borders: false,
                              )
                            ).toList()
                          )
                        ],
                      ),
                    );
                  } else {
                    return Container();
                  }
                },
              ),
            ]
          )
        )
      )
    );
  }
}

class CardPage extends StatefulWidget {
  final DominionCard _card;

  CardPage(this._card);

  @override
  State<StatefulWidget> createState() => CardPageState();
}
