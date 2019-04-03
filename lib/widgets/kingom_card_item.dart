import 'package:dominionizer_app/model/dominion_card.dart';
import 'package:dominionizer_app/pages/card_page.dart';
import 'package:dominionizer_app/widgets/card_cost.dart';
import 'package:dominionizer_app/widgets/card_extras.dart';
import 'package:dominionizer_app/widgets/card_gradient.dart';
import 'package:flutter/material.dart';

class KingdomCardItem extends StatelessWidget {
  final DominionCard card;
  final bool isBroughtCard, isEventProjectOrLandmark, topBorder, borders;
  final double fontSize;

  KingdomCardItem({@required this.card, this.isBroughtCard = false, this.isEventProjectOrLandmark = false, 
                    this.topBorder = false, this.fontSize = 14, this.borders = true});
  
  BoxBorder _createBorder(BuildContext context) {
    if (borders) {
      if (topBorder) {
        return BorderDirectional(
          top: BorderSide(
            color: Theme.of(context).accentColor,
            width: 2
          )
        );
      }

      return BorderDirectional(
        top:BorderSide(
          color: Theme.of(context).dividerColor
        )
      );
    }
  }

  Color _getBackgroundColor(BuildContext context) {
    if (isBroughtCard) {
      return Theme.of(context).highlightColor;
    } else if (isEventProjectOrLandmark) {
      return Theme.of(context).backgroundColor;
    }
    
    return Theme.of(context).canvasColor;
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () {
        Navigator.push(
          context,
          new MaterialPageRoute(builder: (ctxt) => CardPage(card)),
        );
      },
      child: Container(
        decoration: BoxDecoration(
          gradient: CardGradient.createLinearGradient(card),
          // color: _getBackgroundColor(context),
          border: _createBorder(context)
        ),
        child: Padding(
          padding: EdgeInsets.fromLTRB(10, 5, 10, 5),
          child: Row(
            children: <Widget>[
              // Expanded(
              //   flex: 1,
              //   child: Container(
              //     decoration: BoxDecoration(
              //       gradient: CardGradient.createLinearGradient(card),
              //     ),
              //   ),
              // ),
              Expanded(
                flex: 7,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      card.name, 
                      textAlign: TextAlign.start,
                      style: TextStyle(fontSize: fontSize),
                    ),
                    Row(
                      // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[
                        Expanded(
                          flex: 4,
                          // child: Placeholder()
                          child: CardCost(
                            coins: card.coins, 
                            potions: card.potions, 
                            debt: card.debt,
                            compositePile: card.isCompositePile ?? false,
                            broughtCard: isBroughtCard ?? false,
                            fontSize: 8,
                            iconSize: 8,
                            width: 15
                          ),
                        ),
                        Expanded(
                          flex: 6,
                          child: Text(
                            card.types.join(", "),
                            style: TextStyle(
                              fontSize: 8
                            ),
                          ),
                        )
                      ],
                    )
                  ]
                )
              ),
              Expanded(
                flex: 3,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(
                      "${card.setName}",
                      style: TextStyle(fontSize: fontSize),
                    ),
                    CardExtras(
                      bringsCards: card.bringsCards,
                      isCompositePile: card.isCompositePile,
                    )
                  ]
                )
              )
            ],
          )
        ),
      ),
    );
  }
}