
import 'dart:async';

import 'package:first_app_flutter/Models/Action.dart';
import 'package:first_app_flutter/Repositories/db_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import '../Config/customcolors.dart';
import '../Models/category.dart';
import '../Services/action_service.dart';
import '../Widgets/loading_widget.dart';
import 'action_list.dart';
import 'add_action.dart';
import 'dashboardscreen.dart';
import 'search_actions.dart';

class ActionPage extends StatefulWidget {
  const ActionPage({Key? key}) : super(key: key);

  static const String actionPage = "actionPage";

  @override
  State<ActionPage> createState() => _ActionPageState();
}

class _ActionPageState extends State<ActionPage> {
  /// define two User type list views as users and usersDisplay ///
  // used to view fetched data to list //
  List<ActionModel> _actions = <ActionModel>[];
  // used to view all list in our app alse to filtered data as list when searching //
  List<ActionModel> actionsList = <ActionModel>[];
  //service
  ActionService actionService = ActionService();
  DBHelper dbHelper = DBHelper();

  /// this variable use to check if the app still fetching data or not. ///
  bool _isLoading = true;
  var count;

  @override
  void initState() {
    super.initState();
    getData();
    getCount();
  }

  getData() async {
    var categories = await actionService.readData();
    categories.forEach((action){
        setState(() {
          var actionModel = ActionModel();
          actionModel.NAct = action['NAct'];
          actionModel.Act = action['Act'];
          actionModel.DescPb = action['DescPb'];
          actionModel.MatDeclancheur = action['MatDeclancheur'];
          actionModel.Date = action['Date'];
          actionModel.CodeSite = action['CodeSite'];
          _actions.add(actionModel);
          actionsList = _actions;
          _isLoading = false;
          print(actionsList.length);
        });
    });

  }

  getCount() async {
    count = await dbHelper.getCountAction();
    print('count : ${count}');
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
            'Actions ${count}',
            style: TextStyle(color: Colors.black),
          ),
          backgroundColor: (lightPrimary),
          elevation: 0,
        ),
        backgroundColor: Colors.transparent,
        body: SafeArea(
          child: actionsList.isNotEmpty ?
          Container(
            child: RefreshIndicator(
              onRefresh: () async {
                await Future.delayed(Duration(seconds: 1));
                //refreshData();
              },
              child: ListView.builder(
                itemBuilder: (context, index) {
                  if (!_isLoading) {
                    //without search
                    return ActionList(actionModel: this.actionsList[index], );
                    //with search
                    /* return index == 0
                        ? _searchBar()
                        : ActionList(actionModel: this.actionsList[index - 1], ); */
                  } else {
                    return LoadingView();
                  }
                },
                itemCount: actionsList.length,
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
              label: 'New Action',
                labelBackgroundColor: Colors.white,
                backgroundColor: Colors.white,
              onTap: (){
                Navigator.push(context, MaterialPageRoute(builder: (context) => AddAction()));
              }
            ),
            SpeedDialChild(
              labelBackgroundColor: Colors.white,
                backgroundColor: Colors.white,
                child: Icon(Icons.search, color: Colors.blue, size: 32),
                label: 'Search Action',
                onTap: (){
                  showSearch(
                    context: context,
                    delegate: SearchActionDelegate(actionsList),
                  );
                }
            )
          ],
        ),
      ),
    );
  }

  void refreshData() {
    new Timer.periodic(
        Duration(seconds: 1),
            (Timer timer){

          timer.cancel();
          setState(() {
            getData();
          });
        }
    );
  }

  /// to control with search view as list ///
  _searchBar() {
    return Padding(
      padding: EdgeInsets.all(3.0),
      child: TextField(
        autofocus: false,
        onChanged: (searchText) {
          searchText = searchText.toLowerCase();
          setState(() {
            actionsList = _actions.where((u) {
              var description = u.DescPb.toLowerCase();
              var declencheur = u.MatDeclancheur.toLowerCase();
              return description.contains(searchText) ||
                  declencheur.contains(searchText);
            }).toList();
          });
        },
        decoration: InputDecoration(
          border: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.lightBlue, width: 1),
            borderRadius: BorderRadius.all(Radius.circular(10))
          ),
          prefixIcon: Icon(Icons.search),
          hintText: 'Search Actions',
        ),
      ),
    );
  }

}
