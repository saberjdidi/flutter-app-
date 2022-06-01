import '../Config/db_table.dart';
import '../Models/typeAction.dart';
import '../Repositories/db_helper.dart';

class TypeActionService {

  DBHelper dbHelper = DBHelper();

  readData() async {
    return await dbHelper.readSource(DBTable.type_action);
  }

  saveData(TypeAction action) async {
    return await dbHelper.insertSource(DBTable.type_action, action.typeActionMap());
  }

  editData(TypeAction action) async {
    return await dbHelper.updateSource(
        DBTable.type_action,
        action.typeActionMap()
    );
  }

  deleteData(final id) async{
    return await dbHelper.deleteSource(
        DBTable.type_action,
        "CodetypeAct = ${id}"
    );
  }

}