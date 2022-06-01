import '../Config/db_table.dart';
import '../Models/GraviteAction.dart';
import '../Repositories/db_helper.dart';

class GraviteActionService {

  DBHelper dbHelper = DBHelper();

  readData() async {
    return await dbHelper.readGraviteAction(DBTable.gravite_action);
  }

  saveData(GraviteAction graviteAction) async {
    return await dbHelper.insertGraviteAction(DBTable.gravite_action, graviteAction.graviteActionMap());
  }

  editData(GraviteAction graviteAction) async {
    return await dbHelper.updateGraviteAction(
        DBTable.gravite_action,
        graviteAction.graviteActionMap()
    );
  }

  deleteData(final id) async{
    return await dbHelper.deleteGraviteAction(
        DBTable.gravite_action,
        "codegravite = ${id}"
    );
  }

}