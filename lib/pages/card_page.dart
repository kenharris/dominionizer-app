import 'package:dominionizer_app/blocs/card_details_bloc.dart';
import 'package:dominionizer_app/model/dominion_card.dart';
import 'package:dominionizer_app/resources/repository.dart';
import 'package:dominionizer_app/widgets/card_cost.dart';
import 'package:dominionizer_app/widgets/card_text.dart';
import 'package:dominionizer_app/widgets/kingom_card_item.dart';
import 'package:flutter/material.dart';

class CardPageState extends State<CardPage> {
  CardDetailsBloc bloc = CardDetailsBloc();
  final Repository _repository = Repository();

  List<DominionCard> _broughtCards;
  List<DominionCard> _constituentCards;

  bool get _hasBroughtCards => (_broughtCards?.length ?? 0) > 0 ?? false;
  bool get _hasConstituentCards => (_constituentCards?.length ?? 0) > 0 ?? false;
  int get _flexSize {
    if (_hasBroughtCards) {
      if (_hasConstituentCards) {
        return 6;
      }
      return 7;
    }

    if (_hasConstituentCards) {
      return 7;
    }

    return 1;
  }
  
  int get _auxiliaryFlexSize {
    if (_hasBroughtCards && _hasConstituentCards)
      return 2;
    
    if (_hasBroughtCards || _hasConstituentCards)
      return 3;
    
    return 0;
  }

  final double detailFontSize = 12;

  @override
  void initState() {
    super.initState();

    _repository.getBroughtCards([widget._card.id]).then((broughtCards) {
      setState(() {
        _broughtCards = broughtCards;
      });
    });

    _repository.getCompositeCards(widget._card.id).then((constituentCards) {
      setState(() {
        _constituentCards = constituentCards;
      });
    });
  }

  @override
  void dispose() {
    bloc.dispose();
    super.dispose();
  }
  
  @override
  Widget build(BuildContext ctxt) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget._card.name),
      ),
      body: Padding(
        padding: EdgeInsets.fromLTRB(30, 10, 30, 10),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Flexible(
              flex: _flexSize,
              child: Container(
                decoration: BoxDecoration(
                  border: Border.all(
                    color: Theme.of(ctxt).primaryColorDark,
                    style: BorderStyle.solid,
                    width: 2,
                  ),
                  borderRadius: BorderRadius.all(Radius.circular(10))
                ),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                      color: Colors.white.withAlpha(100)
                    ),
                    child: Column(
                      children: [
                        Padding(
                          padding: EdgeInsets.all(10),
                          child: Text("${widget._card.name}",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 24,
                              decoration: TextDecoration.underline
                            )
                          )
                        ),

                        Expanded(
                          child: const Text("")
                        ),
                        
                        if (widget._card.topText.trim().isNotEmpty || widget._card.bottomText.trim().isNotEmpty)
                          Padding(
                            padding: EdgeInsets.all(10),
                            child: CardText(
                              top: widget._card.topText,
                              bottom: widget._card.bottomText,
                              fontSize: detailFontSize,
                            )
                          ),

                        Expanded(
                          child: const Text("")
                        ),

                        Padding(
                          padding:EdgeInsets.all(5),
                          child: Row(
                            children: <Widget>[
                              Flexible(
                                flex: 2,
                                fit: FlexFit.tight,
                                child: CardCost(
                                  coins: widget._card.coins,
                                  potions: widget._card.potions,
                                  debt: widget._card.debt,
                                  compositePile: widget._card.isCompositePile,
                                  fontSize: 18,
                                  iconSize: 10
                                )
                              ),
                              Flexible(
                                flex: 4,
                                fit: FlexFit.tight,
                                child: Center(
                                  child: Text("${widget._card.types.join(", ")}"),
                                )
                              ),
                              Flexible(
                                flex: 4,
                                fit: FlexFit.tight,
                                child: Align(
                                  alignment: Alignment.centerRight,
                                  child: Text("${widget._card.sets.join(", ")}"),
                                )
                              ),
                            ],
                          )
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ),
            if (_hasConstituentCards)
              Flexible(
                flex: _auxiliaryFlexSize,
                fit: FlexFit.loose,
                child: Padding(
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
                      Expanded(
                        child: ListView.builder(
                          itemCount: _constituentCards.length,
                          itemBuilder: (BuildContext context, int index) {
                            return KingdomCardItem(
                              card: _constituentCards[index],
                              borders: false
                            );
                          },
                        ),
                      ),
                    ]
                  )
                ) 
              ),
            
            if (_hasBroughtCards)
              Flexible(
                flex: _auxiliaryFlexSize,
                fit: FlexFit.loose,
                child: Padding(
                  padding: EdgeInsets.all(10),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Text(
                        "This card pile brings the following cards:",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: detailFontSize,
                          fontWeight: FontWeight.bold,
                          decoration: TextDecoration.underline
                        )
                      ),
                      Expanded(
                        child: ListView.builder(
                          itemCount: _broughtCards.length,
                          itemBuilder: (BuildContext context, int index) {
                            return KingdomCardItem(
                              card: _broughtCards[index],
                              borders: false
                            );
                          },
                        ),
                      ),
                    ]
                  )
                ) 
              ),
          ]
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
