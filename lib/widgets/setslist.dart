import 'package:flutter/material.dart';
import 'package:dominionizer_app/widgets.dart';
import 'package:dominionizer_app/model/setinfo.dart';
import 'package:dominionizer_app/blocs/sets_event.dart';
import 'package:dominionizer_app/blocs/sets_bloc.dart';

class SetsListState extends State<SetsList> {  
  void _toggleSelectedState (SetName id, bool included) async
  {
    ServiceProviderWidget.of(context).setsBloc.setsEventSink.add(SetInclusionEvent(id: id,  include: included));
  }

  @override
  Widget build (BuildContext ctxt) {
    return StreamBuilder<SetsBlocState>(
      stream: ServiceProviderWidget.of(context).setsBloc.sets,
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
                    decoration: const BoxDecoration(
                      border:Border(
                        top:BorderSide(width: 1.0, color: Colors.green),
                        bottom:BorderSide(width: 1.0, color: Colors.green),
                        left:BorderSide(width: 1.0, color: Colors.green),
                        right:BorderSide(width: 1.0, color: Colors.green)
                      )
                    ),
                    child: ListTile(
                      leading: Text("${snapshot.data.sets[index].id.index}"),
                      title: Text(
                        snapshot.data.sets[index].name, 
                        style: TextStyle (
                          color: snapshot.data.sets[index].included ? Colors.green : Colors.red,
                        ), 
                        textAlign: TextAlign.start
                      ),
                      trailing: Icon(
                        snapshot.data.sets[index].included ? Icons.check : Icons.close,
                        color: snapshot.data.sets[index].included ? Colors.green : Colors.red,
                      ),
                    onTap: () => _toggleSelectedState(snapshot.data.sets[index].id, !snapshot.data.sets[index].included)
                    ),
                  );
                }
              );
        }
      }
    );   
  }
}

class SetsList extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => SetsListState();
}