import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';

import '../Models/Source.dart';
import '../Services/source_service.dart';
import '../Widgets/loading_widget.dart';
import '../Widgets/refresh_widget.dart';
import 'add_source.dart';
import 'dashboardscreen.dart';
import 'edit_source.dart';

class SourceScreen extends StatefulWidget {
  const SourceScreen({Key? key}) : super(key: key);

  static const String sourceScreen = "sourceScreen";

  @override
  State<SourceScreen> createState() => _SourceScreenState();
}

class _SourceScreenState extends State<SourceScreen> {

  final keyRefresh = GlobalKey<RefreshIndicatorState>();

  SourceService sourceService = SourceService();
  List<Source> sourcesList = <Source>[];
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

    var response = await sourceService.readData();
    response.forEach((action){
      setState(() {
        var sourceModel = Source();
        sourceModel.CodeSourceAct = action['CodeSourceAct'];
        sourceModel.SourceAct = action['SourceAct'];
        sourceModel.act_simp = action['act_simp'];
        sourceModel.obs_constat = action['obs_constat'];
        sourceModel.Supp = action['Supp'];
        sourcesList.add(sourceModel);
        _isLoading = false;
        print(sourcesList.length);
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
            'Sources',
            style: TextStyle(color: Colors.black),
          ),
          backgroundColor: (lightPrimary),
          elevation: 0,
        ),
        backgroundColor: Colors.transparent,
        body: SafeArea(
            child: sourcesList.isNotEmpty ?
            Container(
              child: RefreshIndicator(
                onRefresh: () async {
                  await Future.delayed(Duration(seconds: 1),
                      (){
                        setState(() {
                          sourcesList;
                        });
                      }
                  );
                  //refreshData();
                },
                child: ListView.builder(
                  itemBuilder: (context, index) {
                    final site = sourcesList[index].SourceAct;
                    if (!_isLoading) {
                      return Card(
                        color: Colors.white60,
                        child: ListTile(
                          textColor: Colors.black87,
                          title: Text(site, style: TextStyle(
                            fontSize: 18.0,
                            fontFamily: "Brand-Regular",
                            color: Colors.grey[800],
                            fontWeight: FontWeight.w900,
                            fontStyle: FontStyle.normal,//make underline
                            decorationStyle: TextDecorationStyle.double, //dou
                            decorationThickness: 1.5,// ble underline
                          ),),
                          //subtitle: Text("${sourcesList[index].SourceAct}"),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                onPressed: () async {
                                  _showDialog(context, sourcesList[index].CodeSourceAct);

                                },
                                icon: Icon(Icons.delete, color: Colors.red,),
                              ),
                              IconButton(
                                onPressed: () async {
                                  Navigator.of(context)
                                      .push(MaterialPageRoute(builder: (context) =>
                                      EditSource(source: sourcesList[index])
                                  ));
                                },
                                icon: Icon(Icons.edit, color: Colors.green,),
                              )
                            ],
                          ),
                        ),
                      );
                    } else {
                      return LoadingView();
                    }
                  },
                  itemCount: sourcesList.length,
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
                label: 'New Source',
                labelBackgroundColor: Colors.white,
                backgroundColor: Colors.white,
                onTap: (){
                  Navigator.push(context, MaterialPageRoute(builder: (context) => AddSource()));
                }
            ),
            SpeedDialChild(
                labelBackgroundColor: Colors.white,
                backgroundColor: Colors.white,
                child: Icon(Icons.search, color: Colors.blue, size: 32),
                label: 'Search Source',
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
                  int response = await sourceService.deleteData(position);
                  if(response > 0){
                    //sites.removeWhere((element) => element['id'] == position);
                    sourcesList.removeWhere((element) => element.CodeSourceAct == position);
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

  /*
  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(
      title: Text('Sources'),
      actions: [
        IconButton(
          icon: Icon(Icons.refresh),
          onPressed: loadList,
        ),
      ],
    ),
    body: buildList(),
  );

  Widget buildList() => sourcesList.isEmpty
      ? Center(child: CircularProgressIndicator())
      : RefreshWidget(
    keyRefresh: keyRefresh,
    onRefresh: loadList,
    child: ListView.builder(
      shrinkWrap: true,
      primary: false,
      padding: EdgeInsets.all(16),
      itemCount: sourcesList.length,
      itemBuilder: (context, index) {
        final number = sourcesList[index].SourceAct;

        return ListTile(
          title: Center(
            child: Text('$number', style: TextStyle(fontSize: 32)),
          ),
        );
      },
    ),
  );
 */
}

