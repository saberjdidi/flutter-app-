import 'package:first_app_flutter/Models/SousAction.dart';

import '../Config/db_table.dart';
import '../Models/Action.dart';
import '../Repositories/db_helper.dart';

class SousActionService {

  DBHelper dbHelper = DBHelper();

  readDataByIdAction(id) async {
    return await dbHelper.readSousAction(DBTable.sous_action,id);
  }

  saveData(SousAction action) async {
    return await dbHelper.insertSousAction(DBTable.sous_action, action.sousActionMap());
  }

  editData(ActionModel action) async {
    return await dbHelper.updateSousAction(
        DBTable.sous_action,
        action.actionMap()
    );
  }

  deleteData(final id) async{
    return await dbHelper.deleteSousAction(
        DBTable.sous_action,
        "id = ${id}"
    );
  }

}