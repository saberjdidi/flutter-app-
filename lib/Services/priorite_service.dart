import '../Config/db_table.dart';
import '../Models/Priorite.dart';
import '../Repositories/db_helper.dart';

class PrioriteService {

  DBHelper dbHelper = DBHelper();

  readData() async {
    return await dbHelper.readPriorite(DBTable.priorite);
  }

  saveData(Priorite priorite) async {
    return await dbHelper.insertPriorite(DBTable.priorite, priorite.prioriteMap());
  }

  editData(Priorite priorite) async {
    return await dbHelper.updatePriorite(
        DBTable.priorite,
        priorite.prioriteMap()
    );
  }

  deleteData(final id) async{
    return await dbHelper.deletePriorite(
        DBTable.priorite,
        "codepriorite = ${id}"
    );
  }

}