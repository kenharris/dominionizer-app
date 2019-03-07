import 'package:flutter/material.dart';
import 'package:dominionizer_app/widgets.dart';
import 'package:dominionizer_app/model/setinfo.dart';
import 'package:dominionizer_app/blocs/sets_event.dart';

class SetsListState extends State<SetsList> {  
  void _toggleSelectedState (SetName id, bool included) async
  {
    ServiceProviderWidget.of(context).setsBloc.setsEventSink.add(SetInclusionEvent(id: id,  include: included));
  }

  @override
  Widget build (BuildContext ctxt) {
    return StreamBuilder<List<SetInfo>>(
      stream: ServiceProviderWidget.of(context).setsBloc.sets,
      builder: (BuildContext context, AsyncSnapshot<List<SetInfo>> snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.waiting:
            return const CircularProgressIndicator();
          default:
            if (snapshot.hasError)
              return Text('Error: ${snapshot.error}');
            else
              return ListView.builder
              (
                itemCount: snapshot.data.length,
                itemBuilder: (BuildContext ctxt, int index) {
                  return new GestureDetector(
                    child:Container(
                      decoration: const BoxDecoration(
                        border:Border(
                          top:BorderSide(width: 1.0, color: Colors.green),
                          bottom:BorderSide(width: 1.0, color: Colors.green),
                          left:BorderSide(width: 1.0, color: Colors.green),
                          right:BorderSide(width: 1.0, color: Colors.green)
                        )
                      ),
                      child: ListTile(
                        leading: Text("${snapshot.data[index].id.index}"),
                        title: Text(
                          snapshot.data[index].name, 
                          style: TextStyle (
                            color: snapshot.data[index].included ? Colors.red : Colors.black,
                          ), 
                          textAlign: TextAlign.start
                        ),
                        trailing: Icon(
                          snapshot.data[index].included ? Icons.check : Icons.close,
                          color: snapshot.data[index].included ? Colors.green : Colors.red,
                        ),
                      onTap: () => _toggleSelectedState(snapshot.data[index].id, !snapshot.data[index].included)
                      ),
                    )
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