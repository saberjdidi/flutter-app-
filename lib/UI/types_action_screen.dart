import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';

import '../Models/typeAction.dart';
import '../Services/type_action_service.dart';
import '../Widgets/loading_widget.dart';
import 'add_type_action.dart';
import 'dashboardscreen.dart';

class TypeActionScreen extends StatefulWidget {
  const TypeActionScreen({Key? key}) : super(key: key);

  static const String typeActionScreen = "typeActionScreen";

  @override
  State<TypeActionScreen> createState() => _TypeActionScreenState();
}

class _TypeActionScreenState extends State<TypeActionScreen> {

  TypeActionService typeActService = TypeActionService();
  List<TypeAction> typeActList = <TypeAction>[];
  /// this variable use to check if the app still fetching data or not. ///
  bool _isLoading = true;

  // This method will run once widget is loaded
  // i.e when widget is mounting
  @override
  void initState() {
    super.initState();
    loadList();
  }

  Future loadList() async {
    //keyRefresh.currentState?.show();
    //await Future.delayed(Duration(milliseconds: 4000));

    var response = await typeActService.readData();
    response.forEach((action){
      setState(() {
        var typeModel = TypeAction();
        typeModel.CodetypeAct = action['CodetypeAct'];
        typeModel.TypeAct = action['TypeAct'];
        typeModel.codif_auto = action['codif_auto'];
        typeModel.act_simpl = action['act_simpl'];
        typeModel.Supp = action['Supp'];
        typeModel.analyse_cause = action['analyse_cause'];
        typeActList.add(typeModel);
        _isLoading = false;
        print(typeActList.length);
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
            'Types Action',
            style: TextStyle(color: Colors.black),
          ),
          backgroundColor: (lightPrimary),
          elevation: 0,
        ),
        backgroundColor: Colors.transparent,
        body: SafeArea(
            child: typeActList.isNotEmpty ?
            Container(
              child: RefreshIndicator(
                onRefresh: () async {
                  await Future.delayed(Duration(seconds: 1),
                          (){
                        setState(() {
                          typeActList;
                        });
                      }
                  );
                  //refreshData();
                },
                child: ListView.builder(
                  itemBuilder: (context, index) {
                    final type = typeActList[index].TypeAct;
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
                          //subtitle: Text("${typeActList[index].SourceAct}"),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                onPressed: () async {
                                  _showDialog(context, typeActList[index].CodetypeAct);

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
                  itemCount: typeActList.length,
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
                label: 'New Type',
                labelBackgroundColor: Colors.white,
                backgroundColor: Colors.white,
                onTap: (){
                  Navigator.push(context, MaterialPageRoute(builder: (context) => AddTypeAction()));
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
          content: const Text('Are you sure to delete this site?'),
          actions: <Widget>[
            IconButton(
                icon: Icon(
                  Icons.delete,
                  color: Colors.redAccent,
                ),
                onPressed: () async {
                  int response = await typeActService.deleteData(position);
                  if(response > 0){
                    typeActList.removeWhere((element) => element.CodetypeAct == position);
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
