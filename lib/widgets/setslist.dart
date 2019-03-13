import 'package:flutter/material.dart';
import 'package:dominionizer_app/widgets.dart';
import 'package:dominionizer_app/model/setinfo.dart';
import 'package:dominionizer_app/blocs/sets_bloc.dart';

class SetsListState extends State<SetsList> {  
  SetsBloc bloc;

  void _toggleSelectedState (SetName id, bool included) async
  {
    bloc.toggleIncludedState(id, included);
  }

  void _toggleInclusionOfAll(bool include) {
    if (include)
      bloc.toggleIncludedStateAllSets(true);
    else
      bloc.toggleIncludedStateAllSets(false);
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
                          decoration: BoxDecoration(
                            color: snapshot.data.sets[index].included ? Theme.of(context).primaryColor : Theme.of(context).backgroundColor,
                          ),
                          child: ListTile(
                            leading: Text("${snapshot.data.sets[index].id.index}"),
                            title: Text(
                              snapshot.data.sets[index].name, 
                              style: snapshot.data.sets[index].included ? Theme.of(ctxt).primaryTextTheme.body1 : Theme.of(ctxt).accentTextTheme.body1,
                              textAlign: TextAlign.start
                            ),
                          onTap: () => _toggleSelectedState(snapshot.data.sets[index].id, !snapshot.data.sets[index].included)
                          ),
                        );
                      }
                    );
              }
            }
          )
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            FlatButton(
              color: Theme.of(context).primaryColorDark,
              child: const Text("Exclude All"),
              onPressed: () => _toggleInclusionOfAll(false),
            ),
            FlatButton(
              color: Theme.of(context).primaryColorLight,
              child: const Text("Include All"),
              onPressed: () => _toggleInclusionOfAll(true),
            )
          ],
        )
      ],
    );
  }
}

class SetsList extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => SetsListState();
}