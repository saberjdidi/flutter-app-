import 'package:first_app_flutter/Models/causeAction.dart';
import 'package:first_app_flutter/Services/cause_action_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';

import '../Widgets/loading_widget.dart';
import 'add_cause_action.dart';
import 'dashboardscreen.dart';

class CauseScreen extends StatefulWidget {
  const CauseScreen({Key? key}) : super(key: key);

  static const String causeActionScreen = "causeActionScreen";

  @override
  State<CauseScreen> createState() => _CauseScreenState();
}

class _CauseScreenState extends State<CauseScreen> {
  
  CauseActionService service = CauseActionService();
  List<CauseAction> causeList = <CauseAction>[];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    loadList();
  }

  Future loadList() async {
    //keyRefresh.currentState?.show();
    //await Future.delayed(Duration(milliseconds: 4000));

    var response = await service.readData();
    response.forEach((action){
      setState(() {
        var model = CauseAction();
        model.codetypecause = action['codetypecause'];
        model.typecause = action['typecause'];
        model.Amdec = action['Amdec'];
        causeList.add(model);
        _isLoading = false;
        print(causeList.length);
      });
    });
  }
  @override
  Widget build(BuildContext context) {
    const Color lightPrimary = Colors.white;
    const Color darkPrimary = Colors.white;

    return Container(
      decoration: BoxDecoration(
          gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                lightPrimary,
                darkPrimary,
              ])),
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          leading: RaisedButton(
            onPressed: (){
              Navigator.pushNamedAndRemoveUntil(context, DashboardScreen.idScreen, (route) => false);
            },
            elevation: 0.0,
            child: Icon(Icons.arrow_back, color: Colors.blue,),
            color: Colors.white,
          ),
          title: Text(
            'Causes Action',
            style: TextStyle(color: Colors.black),
          ),
          backgroundColor: (lightPrimary),
          elevation: 0,
        ),
        backgroundColor: Colors.transparent,
        body: SafeArea(
            child: causeList.isNotEmpty ?
            Container(
              child: RefreshIndicator(
                onRefresh: () async {
                  await Future.delayed(Duration(seconds: 1),
                          (){
                        setState(() {
                          causeList;
                        });
                      }
                  );
                  //refreshData();
                },
                child: ListView.builder(
                  itemBuilder: (context, index) {
                    final type = causeList[index].typecause;
                    if (!_isLoading) {
                      return Card(
                        color: Colors.white60,
                        child: ListTile(
                          textColor: Colors.black87,
                          title: Text(type, style: TextStyle(
                            fontSize: 18.0,
                            fontFamily: "Brand-Regular",
                            color: Colors.grey[800],
                            fontWeight: FontWeight.w900,
                            fontStyle: FontStyle.normal,//make underline
                            decorationStyle: TextDecorationStyle.double, //dou
                            decorationThickness: 1.5,// ble underline
                          ),),
                          //subtitle: Text("${causeList[index].SourceAct}"),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                onPressed: () async {
                                  _showDialog(context, causeList[index].codetypecause);

                                },
                                icon: Icon(Icons.delete, color: Colors.red,),
                              ),
                            ],
                          ),
                        ),
                      );
                    } else {
                      return LoadingView();
                    }
                  },
                  itemCount: causeList.length,
                  //itemCount: actionsList.length + 1,
                ),
                triggerMode: RefreshIndicatorTriggerMode.anywhere,
                color: Colors.white,
                backgroundColor: Colors.blue,
              ),
            )
                : const Center(child: Text('Empty List', style: TextStyle(
                fontSize: 20.0,
                fontFamily: 'Brand-Bold'
            )),)
        ),
        floatingActionButton: SpeedDial(
          animatedIcon: AnimatedIcons.menu_close,
          spacing: 10.0,
          closeManually: false,
          backgroundColor: Colors.blue,
          spaceBetweenChildren: 15.0,
          children: [
            SpeedDialChild(
                child: Icon(Icons.add, color: Colors.blue, size: 32),
                label: 'New Cause Action',
                labelBackgroundColor: Colors.white,
                backgroundColor: Colors.white,
                onTap: (){
                  Navigator.push(context, MaterialPageRoute(builder: (context) => AddCauseAction()));
                }
            ),
            SpeedDialChild(
                labelBackgroundColor: Colors.white,
                backgroundColor: Colors.white,
                child: Icon(Icons.search, color: Colors.blue, size: 32),
                label: 'Search Type',
                onTap: (){
                  /* showSearch(
                    context: context,
                    delegate: SearchActionDelegate(actionsList),
                  ); */
                }
            )
          ],
        ),
      ),
    );
  }

  void _showDialog(context, position) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Alert'),
          content: const Text('Are you sure to delete this item?'),
          actions: <Widget>[
            IconButton(
                icon: Icon(
                  Icons.delete,
                  color: Colors.redAccent,
                ),
                onPressed: () async {
                  int response = await service.deleteData(position);
                  if(response > 0){
                    causeList.removeWhere((element) => element.codetypecause == position);
                    setState(() {});
                  }
                  Navigator.of(context).pop();
                }
            ),
            new FlatButton(
              child: Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
