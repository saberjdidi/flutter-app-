import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:first_app_flutter/Services/sous_action_service.dart';
import 'package:first_app_flutter/UI/add_sous_action.dart';
import 'package:first_app_flutter/UI/gravites_action_screen.dart';
import 'package:first_app_flutter/UI/priorites_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';

import '../Config/customcolors.dart';
import '../Models/Action.dart';
import '../Models/SousAction.dart';
import '../Widgets/loading_widget.dart';
import 'actions_page.dart';
import 'add_action.dart';

class SousActionList extends StatefulWidget {

  ActionModel actionModel;
  SousActionList({Key? key, required this.actionModel}) : super(key: key);

  static const String sousActionList = "sousActionList";

  @override
  State<SousActionList> createState() => _SousActionListState();
}

class _SousActionListState extends State<SousActionList> {

  late final String title;
  SousActionService service = SousActionService();
  List<SousAction> sousactionsList = <SousAction>[];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    title = widget.actionModel.NAct.toString();
    loadList();
  }

  Future loadList() async {

    var response = await service.readDataByIdAction(widget.actionModel.NAct);
    response.forEach((action){
      setState(() {
        var model = SousAction();
        model.id = action['id'];
        model.NAct = action['NAct'];
        model.Designation = action['Designation'];
        model.date_real = action['date_real'];
        model.date_suivi = action['date_suivi'];
        model.risque = action['risque'];
        sousactionsList.add(model);
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
            'Sous Action of Action ${title}',
            style: TextStyle(color: Colors.black),
          ),
          backgroundColor: (lightPrimary),
          elevation: 0,
        ),
        backgroundColor: Colors.transparent,
        body: SafeArea(
            child: sousactionsList.isNotEmpty ?
            Container(
              child: RefreshIndicator(
                onRefresh: () async {
                  await Future.delayed(Duration(seconds: 1),
                          (){
                        setState(() {
                          sousactionsList;
                        });
                      }
                  );
                  //refreshData();
                },
                child: ListView.builder(
                  itemBuilder: (context, index) {
                    
                    final designation = sousactionsList[index].Designation;
                    final date_real = sousactionsList[index].date_real;
                    
                    if (!_isLoading) {
                      return Card(
                        color: Colors.white60,
                        child: ListTile(
                          textColor: Colors.black87,
                          leading: Hero(
                            tag: '${sousactionsList[index].id}',
                            child: CircleAvatar(
                              backgroundColor: Colors.blue,
                              radius: 25,
                              child: Text(sousactionsList[index].id.toString()),
                            ),
                          ),
                          title: Text(designation, style: TextStyle(
                            fontSize: 18.0,
                            fontFamily: "Brand-Regular",
                            color: Colors.grey[800],
                            fontWeight: FontWeight.w900,
                            fontStyle: FontStyle.normal,//make underline
                            decorationStyle: TextDecorationStyle.double, //dou
                            decorationThickness: 1.5,// ble underline
                          ),),
                          subtitle: RichText(
                            text: TextSpan(
                              style: Theme.of(context).textTheme.bodyLarge,
                              children: [
                                WidgetSpan(
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(horizontal: 2.0),
                                    child: Icon(Icons.calendar_today),
                                  ),
                                ),
                                TextSpan(text: '${date_real}'),

                                //TextSpan(text: '${action.declencheur}'),
                              ],

                            ),
                          ),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                onPressed: () async {
                                  deleteSousAction(context, sousactionsList[index].id);

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
                  itemCount: sousactionsList.length,
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
                label: 'New Sous Action',
                labelBackgroundColor: Colors.white,
                backgroundColor: Colors.white,
                onTap: (){
                  Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => AddSousAction(actionModel: widget.actionModel,))
                  );
                }
            ),
            SpeedDialChild(
                labelBackgroundColor: Colors.white,
                backgroundColor: Colors.white,
                child: Icon(Icons.search, color: Colors.blue, size: 32),
                label: 'Search Sous Action',
                onTap: (){
                  /* showSearch(
                    context: context,
                    delegate: SearchActionDelegate(actionsList),
                  ); */
                }
            ),
            SpeedDialChild(
                labelBackgroundColor: Colors.white,
                backgroundColor: Colors.white,
                child: Icon(Icons.print_outlined, color: Colors.blue, size: 32),
                label: 'Priorite',
                onTap: (){
                  Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => PrioritesScreen())
                  );
                }
            ),
            SpeedDialChild(
                labelBackgroundColor: Colors.white,
                backgroundColor: Colors.white,
                child: Icon(Icons.gradient_outlined, color: Colors.blue, size: 32),
                label: 'Gravite',
                onTap: (){
                  Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => GravitesActionScreen())
                  );
                }
            ),
          ],
        ),
      ),
    );
  }

  deleteSousAction(context, position){
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
              sousactionsList.removeWhere((element) => element.id == position);
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
