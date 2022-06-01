
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:first_app_flutter/Models/site.dart';
import 'package:flutter/material.dart';

import '../Models/Action.dart';
import '../Services/action_service.dart';
import '../Services/site_service.dart';
import 'actions_page.dart';
import 'edit_action.dart';
import 'edit_site.dart';
import 'sous_action_list.dart';

class SearchActionDelegate extends SearchDelegate<Site> {

  ActionService actionService = ActionService();
  //final List<ActionModel> actionList;
  bool isLoading = true;
  List<ActionModel> actionsList = <ActionModel>[];
  List<ActionModel> _filter = [];

  SearchActionDelegate(this.actionsList);

  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      IconButton(
        onPressed: () {
          query = '';
        },
        icon: const Icon(Icons.close),
      ),
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    IconButton(
      onPressed: () {
        close(context, Site());
      },
      icon: const Icon(Icons.arrow_back),
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    return Container();
  /*  return ListView.builder(
      itemCount: _filter.length,
      itemBuilder: (_, index) {
        return Container(
          color: Colors.white,
          child: ListView(
            children: [
              /* MaterialButton(onPressed: () async {
             await dbHelper.deletingDatabase();
            },
            child: Text("delete database"),), */
              ListView.builder(
                  itemCount: _filter.length,
                  physics: NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemBuilder: (context, index){

                    String declencheur = _filter[index].declencheur;
                    String description = _filter[index].description;
                    //String designation = actionList[index].designation;
                    String date = _filter[index].date;

                    return Card(
                      color: Colors.white,
                      child: ListTile(
                        textColor: Colors.black87,
                        //title: Text("${actionsList[index]['name']}"),
                        title: Text(declencheur),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(description),
                            Text(date,
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
                                //_showDialog(context, actionsList[index].id);

                              },
                              icon: Icon(Icons.delete, color: Colors.red,),
                            ),
                            IconButton(
                              onPressed: () async {

                              },
                              icon: Icon(Icons.edit, color: Colors.green,),
                            )
                          ],
                        ),
                      ),
                    );
                  }
              )
            ],
          ),
        );
      },
    ) */
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    _filter = actionsList.where((action) {
      return action.MatDeclancheur.toLowerCase().contains(query.trim().toLowerCase())
          || action.DescPb.toLowerCase().contains(query.trim().toLowerCase());
    }).toList();
    return _filter.isNotEmpty ?
    ListView.builder(
      itemCount: _filter.length,
      itemBuilder: (context, index) {
        String declencheur = _filter[index].MatDeclancheur;
        String description = _filter[index].DescPb;
        //String designation = actionList[index].designation;
        String date = _filter[index].Date.toString();
        return Card(
          color: Colors.white,
          child: ListTile(
            textColor: Colors.black87,
            //title: Text("${actionsList[index]['name']}"),
            title: Text(declencheur,
                style: TextStyle(fontWeight: FontWeight.bold,
                    fontFamily: "Brand-Regular",
                    fontSize: 18.0)),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(description, style:
                TextStyle(fontWeight: FontWeight.bold, color: Colors.black54, fontFamily: "Brand-Bold"),),
                Text(date,
                  style: TextStyle(color: Colors.blue,
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
                    _showDialog(context, _filter[index].NAct);
                  },
                  icon: Icon(Icons.delete, color: Colors.red,),
                ),
                IconButton(
                  onPressed: () async {
                    Navigator.of(context)
                        .push(MaterialPageRoute(builder: (context) => EditAction(
                      actionModel: _filter[index],
                    )));
                  },
                  icon: Icon(Icons.edit, color: Colors.green,),
                )
              ],
            ),
            onTap: (){
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => SousActionList(actionModel: _filter[index])));
            },
          ),
        );
      },
    )
    : const Center(child: Text('Empty List', style: TextStyle(
      fontSize: 20.0,
      fontFamily: 'Brand-Bold'
    ),),)
    ;
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
                    AwesomeDialog(
                      context: context,
                      animType: AnimType.SCALE,
                      dialogType: DialogType.WARNING,
                      body: Center(child: Text(
                        'Action delete successfully',
                        style: TextStyle(fontStyle: FontStyle.italic),
                      ),),
                      title: 'Action deleted',
                      btnOkOnPress: () {
                        Navigator.of(context).pushNamedAndRemoveUntil(ActionPage.actionPage, (route) => false);
                      },
                    )..show();
                  }
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