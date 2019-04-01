import 'package:dominionizer_app/model/dominion_set.dart';
import 'package:flutter/material.dart';
import 'package:dominionizer_app/widgets.dart';
import 'package:dominionizer_app/blocs/sets_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class SetsListState extends State<SetsList> {  
  SetsBloc bloc;

  void _toggleSelectedState (int id, bool included) async
  {
    bloc.toggleIncludedState(id, included);
  }

  List<Widget> _getSetRowChildren(DominionSet setInfo) {
    List<Widget> builder = List<Widget>();

    builder.add(
      Text(
        setInfo.name, 
        style: TextStyle(
          color: setInfo.included ? Theme.of(context).accentColor : Theme.of(context).disabledColor,
          fontWeight: setInfo.included ? FontWeight.bold :FontWeight.normal
        )
      )
    );

    if (setInfo.included) {
      builder.add(
        Icon(FontAwesomeIcons.checkCircle, color: Theme.of(context).accentColor)
      );
    }

    return builder.toList();
  }
  @override
  Widget build (BuildContext ctxt) {
    bloc = ServiceProviderWidget.of(context);
    bloc.initialize();

    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Flexible(
          child: StreamBuilder<SetsBlocState>(
            stream: ServiceProviderWidget.of(context).sets,
            builder: (BuildContext context, AsyncSnapshot<SetsBlocState> snapshot) {
              switch (snapshot.connectionState) {
                case ConnectionState.waiting:
                  return const CircularProgressIndicator();
                default:
                  if (snapshot.hasError)
                    return Text('Error: ${snapshot.error}');
                  else
                    return ListView.builder
                    (
                      shrinkWrap: true,
                      itemCount: snapshot.data.sets.length,
                      itemBuilder: (BuildContext ctxt, int index) {
                        return GestureDetector(
                          onTap: () => _toggleSelectedState(snapshot.data.sets[index].id, !snapshot.data.sets[index].included),
                          behavior: HitTestBehavior.opaque,
                          child: Container(
                            height: 45,
                            decoration: BoxDecoration(
                              border: BorderDirectional(
                                bottom: BorderSide(
                                  color: Theme.of(context).primaryColorDark
                                )
                              )
                            ),
                            child: Center(
                              child: Padding(
                                padding: const EdgeInsets.fromLTRB(10, 5, 10, 5),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: _getSetRowChildren(snapshot.data.sets[index])
                                ),
                              ),
                            )
                          ),
                        );
                      }
                    );
              }
            }
          )
        )
      ],
    );
  }
}

class SetsList extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => SetsListState();
}