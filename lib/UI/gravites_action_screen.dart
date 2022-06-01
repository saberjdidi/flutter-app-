import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:first_app_flutter/Models/GraviteAction.dart';
import 'package:first_app_flutter/UI/actions_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import '../Services/gravite_action_service.dart';
import '../Widgets/loading_widget.dart';
import 'add_gravite_action.dart';

class GravitesActionScreen extends StatefulWidget {
  const GravitesActionScreen({Key? key}) : super(key: key);

  static const String graviteActionScreen = "graviteActionScreen";

  @override
  State<GravitesActionScreen> createState() => _GravitesActionScreenState();
}

class _GravitesActionScreenState extends State<GravitesActionScreen> {

  GraviteActionService service = GraviteActionService();
  List<GraviteAction> gravitesList = <GraviteAction>[];
  bool _isLoading = true;

  // This method will run once widget is loaded
  // i.e when widget is mounting
  @override
  void initState() {
    super.initState();
    loadList();
  }

  Future loadList() async {
    var response = await service.readData();
    response.forEach((data){
      setState(() {
        var model = GraviteAction();
        model.codegravite = data['codegravite'];
        model.gravite = data['gravite'];
        gravitesList.add(model);
        _isLoading = false;
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
              Navigator.pushNamedAndRemoveUntil(context, ActionPage.actionPage, (route) => false);
            },
            elevation: 0.0,
            child: Icon(Icons.arrow_back, color: Colors.blue,),
            color: Colors.white,
          ),
          title: Text(
            'Gravite Action List',
            style: TextStyle(color: Colors.black),
          ),
          backgroundColor: (lightPrimary),
          elevation: 0,
        ),
        backgroundColor: Colors.transparent,
        body: SafeArea(
            child: gravitesList.isNotEmpty ?
            Container(
              child: RefreshIndicator(
                onRefresh: () async {
                  await Future.delayed(Duration(seconds: 1),
                          (){
                        setState(() {
                          gravitesList;
                        });
                      }
                  );
                  //refreshData();
                },
                child: ListView.builder(
                  itemBuilder: (context, index) {
                    final gravite = gravitesList[index].gravite;
                    if (!_isLoading) {
                      return Card(
                        color: Colors.white60,
                        child: ListTile(
                          textColor: Colors.black87,
                          title: Text(gravite, style: TextStyle(
                            fontSize: 18.0,
                            fontFamily: "Brand-Regular",
                            color: Colors.grey[800],
                            fontWeight: FontWeight.w900,
                            fontStyle: FontStyle.normal,//make underline
                            decorationStyle: TextDecorationStyle.double, //dou
                            decorationThickness: 1.5,// ble underline
                          ),),
                          //subtitle: Text("${activitiesList[index].SourceAct}"),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                onPressed: () async {
                                  deleteData(context, gravitesList[index].codegravite);

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
                  itemCount: gravitesList.length,
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
                label: 'New Gravite',
                labelBackgroundColor: Colors.white,
                backgroundColor: Colors.white,
                onTap: (){
                  Navigator.push(context, MaterialPageRoute(builder: (context) => AddGraviteAction()));
                }
            ),
          ],
        ),
      ),
    );
  }

  deleteData(context, position){
    AwesomeDialog(
        context: context,
        animType: AnimType.SCALE,
        dialogType: DialogType.ERROR,
        body: Center(child: Text(
          'Are you sure to delete this item ${position}',
          style: TextStyle(fontStyle: FontStyle.italic),
        ),),
        title: 'Delete',
        btnOk: ElevatedButton(
          style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all(
              Colors.blue,
            ),
            shape: MaterialStateProperty.all(
              RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
            ),
          ),
          onPressed: () async {
            int response = await service.deleteData(position);
            if(response > 0){
              gravitesList.removeWhere((element) => element.codegravite == position);
              setState(() {});
              Navigator.of(context).pop();
            }
          },
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text('Ok',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.white,
                letterSpacing: 2,
              ),
            ),
          ),
        ),
        closeIcon: Icon(Icons.close, color: Colors.red,),
        btnCancel: ElevatedButton(
          style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all(
              Colors.redAccent,
            ),
            shape: MaterialStateProperty.all(
              RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
            ),
          ),
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text('Cancel',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.white,
                letterSpacing: 2,
              ),
            ),
          ),
        )
    )..show();
  }
}
