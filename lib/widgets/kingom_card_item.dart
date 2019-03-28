import 'package:dominionizer_app/model/dominion_card.dart';
import 'package:dominionizer_app/pages/card_page.dart';
import 'package:dominionizer_app/widgets/cardCost.dart';
import 'package:dominionizer_app/widgets/cardExtras.dart';
import 'package:flutter/material.dart';

class KingdomCardItem extends StatelessWidget {
  final DominionCard card;
  final bool isBroughtCard, isEventProjectOrLandmark, topBorder;
  final double fontSize;

  KingdomCardItem({@required this.card, this.isBroughtCard = false, this.isEventProjectOrLandmark = false, this.topBorder = false, this.fontSize = 14});
  
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          new MaterialPageRoute(builder: (ctxt) => CardPage(card)),
        );
      },
      child: Container(
        decoration: BoxDecoration(
            color: isBroughtCard ? Theme.of(context).highlightColor : isEventProjectOrLandmark ? Theme.of(context).backgroundColor : Theme.of(context).canvasColor,
            border: topBorder 
              ? BorderDirectional(
                top: BorderSide(
                  color: Theme.of(context).dividerColor
                )
            )
            : null
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
                          card.name, 
                          textAlign: TextAlign.start,
                          style: TextStyle(fontSize: fontSize),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: <Widget>[
                            Expanded(
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
                  TableCell(
                    verticalAlignment: TableCellVerticalAlignment.top,
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
                ]
              )
            ]
          ),
        ),
      ),
    );
  }
}