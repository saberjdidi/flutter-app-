import '../Config/db_table.dart';
import '../Models/Activity.dart';
import '../Repositories/db_helper.dart';

class ActivityService {

  DBHelper dbHelper = DBHelper();

  readData() async {
    return await dbHelper.readActivite(DBTable.activite);
  }

  saveData(Activity action) async {
    return await dbHelper.insertActivite(DBTable.activite, action.activityMap());
  }

  editData(Activity action) async {
    return await dbHelper.updateActivite(
        DBTable.activite,
        action.activityMap()
    );
  }

  deleteData(final id) async{
    return await dbHelper.deleteActivite(
        DBTable.activite,
        "Code_domaine = ${id}"
    );
  }

}