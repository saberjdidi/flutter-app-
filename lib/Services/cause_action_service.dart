import '../Config/db_table.dart';
import '../Models/causeAction.dart';
import '../Repositories/db_helper.dart';

class CauseActionService {

  DBHelper dbHelper = DBHelper();

  readData() async {
    return await dbHelper.readCauseAction(DBTable.cause_action);
  }

  saveData(CauseAction action) async {
    return await dbHelper.insertCauseAction(DBTable.cause_action, action.causeActionMap());
  }

  editData(CauseAction action) async {
    return await dbHelper.updateCauseAction(
        DBTable.cause_action,
        action.causeActionMap()
    );
  }

  deleteData(final id) async{
    return await dbHelper.deleteCauseAction(
        DBTable.cause_action,
        "codetypecause = ${id}"
    );
  }

}