
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:first_app_flutter/UI/sous_action_list.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../Models/Action.dart';
import '../Services/action_service.dart';
import 'actions_page.dart';
import 'edit_action.dart';

class ActionList extends StatefulWidget {

 final ActionModel actionModel;
  ActionList({required this.actionModel});
  //ActionList({Key? key, required this.actionModel}) : super(key: key);

  @override
  State<ActionList> createState() => _ActionListState();
}

class _ActionListState extends State<ActionList> {

  ActionService actionService = ActionService();
  late ActionModel action;

  @override
  void initState() {
    action = widget.actionModel;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final date = action.Date.toString();
    final name = action.MatDeclancheur.toString();

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 10.0),
      child: Column(
        children: [
          ListTile(
            leading: Hero(
              tag: action.MatDeclancheur,
              child: CircleAvatar(
                backgroundColor: Colors.blue,
                radius: 25,
                child: Text(action.NAct.toString()),
              ),
            ),
            title: Expanded(
              flex: 1,
              child: ListTile(
                  title: Text(
                    '${action.Act}',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                subtitle: Padding(
                  padding: const EdgeInsets.only(top: 10.0),
                  child: RichText(
                    text: TextSpan(
                      style: Theme.of(context).textTheme.bodyLarge,
                      children: [
                        WidgetSpan(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 2.0),
                            child: Icon(Icons.calendar_today),
                          ),
                        ),
                        TextSpan(text: '${date} by ${name}'),

                        //TextSpan(text: '${action.declencheur}'),
                      ],

                    ),
                  ),
                ),
              ),
            ),
            subtitle: Padding(
              padding: const EdgeInsets.only(left: 10.0),
              child: Text(action.DescPb,
                  style:
                  TextStyle(fontWeight: FontWeight.bold, color: Colors.blue)),
            ),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  onPressed: () async {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => SousActionList(actionModel: action,)));
                  },
                  icon: Icon(Icons.remove_red_eye, color: Colors.blue,),
                ),
                IconButton(
                  onPressed: () async {
                    _showDialog(context, action.NAct);

                  },
                  icon: Icon(Icons.delete, color: Colors.red,),
                ),
                IconButton(
                  onPressed: () async {
                    Navigator.of(context)
                        .push(MaterialPageRoute(builder: (context) => EditAction(
                      actionModel: action,
                    )));
                  },
                  icon: Icon(Icons.edit, color: Colors.green,),
                )
              ],
            ),
            /// this function uses to navigate (move to next screen) User Details page and pass user objects into the User Details page. ///
             onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => SousActionList(actionModel: action,)));
            },
          ),
          Divider(
            thickness: 1.0,
            color: Colors.blue,
          ),
        ],
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
                    setState(() {});
                  }
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
