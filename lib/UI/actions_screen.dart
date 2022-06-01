import 'package:first_app_flutter/UI/dashboardscreen.dart';
import 'package:flutter/material.dart';

import '../Config/customcolors.dart';
import '../Models/Action.dart';
import '../Services/action_service.dart';
import 'add_action.dart';
import 'edit_action.dart';

class ActionsScreen extends StatefulWidget {
  const ActionsScreen({Key? key}) : super(key: key);

  static const String actionScreen = "actionScreen";

  @override
  State<ActionsScreen> createState() => _ActionsScreenState();
}

class _ActionsScreenState extends State<ActionsScreen> {

  ActionService actionService = ActionService();
  List<ActionModel> actionList = List<ActionModel>.empty(growable: true);
  bool isLoading = true;

  @override
  void initState(){
    getData();
    super.initState();
  }

  getData() async {
    actionList = List<ActionModel>.empty(growable: true);
    var categories = await actionService.readData();
    categories.forEach((action){
      if(this.mounted) {
        setState(() {
          var actionModel = ActionModel();
          actionModel.NAct = action['NAct'];
          actionModel.DescPb = action['DescPb'];
          actionModel.MatDeclancheur = action['MatDeclancheur'];
          actionModel.Date = action['Date'];
          actionModel.CodeSite = action['CodeSite'];
          actionList.add(actionModel);
        });
      }
    });
    isLoading = false;

  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: RaisedButton(
          onPressed: (){
            Navigator.pushNamedAndRemoveUntil(context, DashboardScreen.idScreen, (route) => false);
          },
          elevation: 0.0,
          child: Icon(Icons.arrow_back, color: Colors.white,),
          color: Colors.blue,
        ),
        title: Text("Action"),
        backgroundColor: Colors.blue,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: (){
         // Navigator.push(context, MaterialPageRoute(builder: (context) => AddAction()));
        },
        child: const Icon(
          Icons.add,
          color: Colors.white,
          size: 32,),
        backgroundColor: CustomColors.googleBackground,
      ),
      body: Container(
        color: Colors.white,
        child: Padding(
          padding: const EdgeInsets.only(
            left: 3.0,
            right: 3.0,
            bottom: 2.0,
          ),

          /// 5- to call ui of ItemList class and show them in DashboardScreen ///
          child: isLoading==true ?
               Center(child: CircularProgressIndicator(),)
              :  ListView(
              children: [
                ListView.builder(
                    itemCount: actionList.length,
                    physics: NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemBuilder: (context, index){

                      String declencheur = actionList[index].MatDeclancheur;
                      String description = actionList[index].DescPb;
                      //String designation = actionList[index].designation;
                      final date = actionList[index].Date;

                      return Padding(
                        padding: const EdgeInsets.only(left: 5.0, right: 5.0),
                        child: Card(
                          elevation: 2.0,
                          color: Colors.white60,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.0)
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(2.0),
                            child: ListTile(
                              contentPadding: EdgeInsets.all(2.0),
                              textColor: Colors.black87,
                              title: Text(declencheur,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(
                                      fontSize: 18,
                                      color: Colors.lightBlue,
                                      fontWeight: FontWeight.bold)
                              ),
                              subtitle: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(description),
                                  Text(date.toString(),
                                  style: TextStyle(color: Colors.black54,
                                  fontSize: 16.0,
                                  ),
                                  ),
                                  //Text(designation),
                                ],
                              ),
                              trailing: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  IconButton(
                                    onPressed: () async {
                                      _showDialog(context, actionList[index].NAct);

                                    },
                                    icon: Icon(Icons.delete, color: Colors.red,),
                                  ),
                                  IconButton(
                                    onPressed: () async {
                                      Navigator.of(context)
                                          .push(MaterialPageRoute(builder: (context) => EditAction(
                                        actionModel: actionList[index],
                                      )));
                                    },
                                    icon: Icon(Icons.edit, color: Colors.green,),
                                  )
                                ],
                              ),
                            ),
                          ),
                        ),
                      );
                    }
                )
              ],
            ),
          ),
      ),
    );
  }

  void _showDialog(BuildContext context, position) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Alert'),
          content: const Text('Are you sure to delete this action?'),
          actions: <Widget>[
            IconButton(
                icon: Icon(
                  Icons.delete,
                  color: Colors.redAccent,
                ),
                onPressed: () async {
                  int response = await actionService.deleteData(position);
                  if(response > 0){
                    actionList.removeWhere((element) => element.NAct == position);
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
