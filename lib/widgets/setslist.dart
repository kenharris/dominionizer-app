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

  @override
  Widget build (BuildContext ctxt) {
    bloc = ServiceProviderWidget.of(context);
    bloc.initialize();

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
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
                      itemCount: snapshot.data.sets.length,
                      itemBuilder: (BuildContext ctxt, int index) {
                        return Container(
                          child: ListTile(
                            title: Text(
                              snapshot.data.sets[index].name, 
                              style: TextStyle(
                                color: snapshot.data.sets[index].included ? Theme.of(context).accentColor : Theme.of(context).disabledColor,
                                fontWeight: snapshot.data.sets[index].included ? FontWeight.bold :FontWeight.normal,
                              ),
                              textAlign: TextAlign.start
                            ),
                            trailing: snapshot.data.sets[index].included
                              ? Icon(FontAwesomeIcons.checkCircle, color: Theme.of(context).accentColor)
                              : null,
                          onTap: () => _toggleSelectedState(snapshot.data.sets[index].id, !snapshot.data.sets[index].included)
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