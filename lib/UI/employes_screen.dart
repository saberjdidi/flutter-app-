import 'package:first_app_flutter/UI/actions_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import '../Models/Employe.dart';
import '../Services/employe_service.dart';
import '../Widgets/loading_widget.dart';
import 'dashboardscreen.dart';

class EmployesScreen extends StatefulWidget {
  const EmployesScreen({Key? key}) : super(key: key);

  static const String employeScreen = "employeScreen";

  @override
  State<EmployesScreen> createState() => _EmployesScreenState();
}

class _EmployesScreenState extends State<EmployesScreen> {

  EmployeService typeActService = EmployeService();
  List<Employe> employesList = <Employe>[];
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
    var response = await typeActService.readData();
    response.forEach((action){
      setState(() {
        var typeModel = Employe();
        typeModel.Mat = action['Mat'];
        typeModel.Nompre = action['Nompre'];
        typeModel.Adresse_mail = action['Adresse_mail'];
        typeModel.Tel = action['Tel'];
        employesList.add(typeModel);
        _isLoading = false;
        print(employesList.length);
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
            'Eemployes List',
            style: TextStyle(color: Colors.black),
          ),
          backgroundColor: (lightPrimary),
          elevation: 0,
        ),
        backgroundColor: Colors.transparent,
        body: SafeArea(
            child: employesList.isNotEmpty ?
            Container(
              child: RefreshIndicator(
                onRefresh: () async {
                  await Future.delayed(Duration(seconds: 1),
                          (){
                        setState(() {
                          employesList;
                        });
                      }
                  );
                  //refreshData();
                },
                child: ListView.builder(
                  itemBuilder: (context, index) {

                    final matricule = employesList[index].Mat;
                    final nomprenom = employesList[index].Nompre;

                    if (!_isLoading) {
                      return Card(
                        color: Colors.white60,
                        child: ListTile(
                          textColor: Colors.black87,
                          title: Text(matricule, style: TextStyle(
                            fontSize: 18.0,
                            fontFamily: "Brand-Regular",
                            color: Colors.grey[800],
                            fontWeight: FontWeight.w900,
                            fontStyle: FontStyle.normal,//make underline
                            decorationStyle: TextDecorationStyle.double, //dou
                            decorationThickness: 1.5,// ble underline
                          ),),
                          //subtitle: Text("${employesList[index].SourceAct}"),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                onPressed: () async {
                                  _showDialog(context, employesList[index].Mat);

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
                  itemCount: employesList.length,
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
                label: 'New Employe',
                labelBackgroundColor: Colors.white,
                backgroundColor: Colors.white,
                onTap: (){
                  //Navigator.push(context, MaterialPageRoute(builder: (context) => AddTypeAction()));
                }
            ),
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
                  int response = await typeActService.deleteData(position);
                  if(response > 0){
                    employesList.removeWhere((element) => element.Mat == position);
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
