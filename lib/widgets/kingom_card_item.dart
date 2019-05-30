import 'package:dominionizer_app/model/dominion_card.dart';
import 'package:dominionizer_app/pages/card_page.dart';
import 'package:dominionizer_app/widgets/card_cost.dart';
import 'package:dominionizer_app/widgets/card_extras.dart';
import 'package:dominionizer_app/widgets/card_side_decoration.dart';
import 'package:flutter/material.dart';

class KingdomCardItem extends StatelessWidget {
  final DominionCard card;
  final bool isBroughtCard, isEventProjectOrLandmark, topBorder, borders;
  final double fontSize;

  Color get _backgroundColor {
    if (this.isEventProjectOrLandmark)
      return Color(0xffeaecef);
    
    if (this.isBroughtCard)
      return Color(0xffefc77c);

    return Color(0x00ffffff);
  }

  KingdomCardItem({@required this.card, this.isBroughtCard = false, this.isEventProjectOrLandmark = false, 
                    this.topBorder = false, this.fontSize = 14, this.borders = true});
  
  BoxBorder _createBorder(BuildContext context) {
    if (borders) {
      if (topBorder) {
        return BorderDirectional(
          top: BorderSide(
            color: Theme.of(context).accentColor,
            // color: Colors.black,
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
          color: _backgroundColor
        ),
        child: Padding(
          padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
          child: IntrinsicHeight(
            child: Row(
              children: <Widget>[
                CardSideDecoration(
                  card: card,
                  width: 10,
                  padding: 5,
                  side: CardSideDecorationSide.Left
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 5),
                    child: Row(
                      children: [
                        Expanded(
                          flex: 7,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                card.name,
                                textAlign: TextAlign.start,
                                style: TextStyle(fontSize: fontSize)
                              ),
                              Row(
                                children: <Widget>[
                                  Expanded(
                                    flex: 4,
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
                                    flex: 3,
                                    child: Text(
                                      "${card.types.join(", ")}",
                                      style: TextStyle(fontSize: 8)
                                    ),
                                  ),
                                  Expanded(
                                    flex: 3,
                                    child: Text(
                                      "${card.categories.join(", ")}",
                                      style: TextStyle(fontSize: 8)
                                    ),
                                  )
                                ],
                              )
                            ]
                          ),
                        ),
                        Expanded(
                          flex: 3,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Expanded(
                                child: Text(
                                  "${card.setName}",
                                  style: TextStyle(fontSize: fontSize)
                                ),
                              ),
                              CardExtras(
                                bringsCards: card.bringsCards,
                                isCompositePile: card.isCompositePile,
                                // color: Colors.white,
                              )
                            ]
                          ),
                        ),
                      ]
                    )
                  )
                ),
                CardSideDecoration(
                  card: card,
                  width: 10,
                  padding: 5,
                  side: CardSideDecorationSide.Right
                ),
              ],
            ),
          )
        ),
      ),
    );
  }
}