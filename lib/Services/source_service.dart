import '../Config/db_table.dart';
import '../Models/Source.dart';
import '../Repositories/db_helper.dart';

class SourceService {

  DBHelper dbHelper = DBHelper();

  readData() async {
    return await dbHelper.readSource(DBTable.source_action);
  }

  saveData(Source action) async {
    return await dbHelper.insertSource(DBTable.source_action, action.sourceMap());
  }

  editData(Source action) async {
    return await dbHelper.updateSource(
        DBTable.source_action,
        action.sourceMap()
    );
  }

  deleteData(final id) async{
    return await dbHelper.deleteSource(
        DBTable.source_action,
        "CodeSourceAct = ${id}"
    );
  }

}