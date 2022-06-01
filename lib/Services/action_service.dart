import '../Config/db_table.dart';
import '../Models/Action.dart';
import '../Repositories/db_helper.dart';

class ActionService {

  DBHelper dbHelper = DBHelper();

  readData() async {
    return await dbHelper.readAction(DBTable.action);
  }

  saveData(ActionModel action) async {
    return await dbHelper.insertAction(DBTable.action, action.actionMap());
  }

  editData(ActionModel action) async {
    return await dbHelper.updateAction(
        DBTable.action,
        action.actionMap()
    );
  }

  deleteData(final id) async{
    return await dbHelper.deleteAction(
        DBTable.action,
        "NAct = ${id}"
    );
  }

  getActionById(id) async {
    return await dbHelper.readActionById(DBTable.action,id);
  }

  /*actionCount() async {
    return await dbHelper.countAction("SELECT COUNT(*) FROM ${DBTable.action}");
  } */
}