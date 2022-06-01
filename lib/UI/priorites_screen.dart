import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:first_app_flutter/Models/Priorite.dart';
import 'package:first_app_flutter/Services/priorite_service.dart';
import 'package:first_app_flutter/UI/actions_page.dart';
import 'package:first_app_flutter/UI/actions_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';

import '../Widgets/loading_widget.dart';
import 'add_priorite.dart';
import 'dashboardscreen.dart';

class PrioritesScreen extends StatefulWidget {
  const PrioritesScreen({Key? key}) : super(key: key);

  static const String prioriteScreen = "prioriteScreen";

  @override
  State<PrioritesScreen> createState() => _PrioritesScreenState();
}

class _PrioritesScreenState extends State<PrioritesScreen> {

  PrioriteService service = PrioriteService();
  List<Priorite> prioritesList = <Priorite>[];
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
        var model = Priorite();
        model.codepriorite = data['codepriorite'];
        model.priorite = data['priorite'];
        prioritesList.add(model);
        _isLoading = false;
        print(prioritesList.length);
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
            'Priorite List',
            style: TextStyle(color: Colors.black),
          ),
          backgroundColor: (lightPrimary),
          elevation: 0,
        ),
        backgroundColor: Colors.transparent,
        body: SafeArea(
            child: prioritesList.isNotEmpty ?
            Container(
              child: RefreshIndicator(
                onRefresh: () async {
                  await Future.delayed(Duration(seconds: 1),
                          (){
                        setState(() {
                          prioritesList;
                        });
                      }
                  );
                  //refreshData();
                },
                child: ListView.builder(
                  itemBuilder: (context, index) {
                    final type = prioritesList[index].priorite;
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
                          //subtitle: Text("${activitiesList[index].SourceAct}"),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                onPressed: () async {
                                  deleteData(context, prioritesList[index].codepriorite);

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
                  itemCount: prioritesList.length,
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
                label: 'New Priorite',
                labelBackgroundColor: Colors.white,
                backgroundColor: Colors.white,
                onTap: (){
                  Navigator.push(context, MaterialPageRoute(builder: (context) => AddPriorite()));
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
              prioritesList.removeWhere((element) => element.codepriorite == position);
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
