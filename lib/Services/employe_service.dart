import '../Config/db_table.dart';
import '../Models/Source.dart';
import '../Repositories/db_helper.dart';

class EmployeService {

  DBHelper dbHelper = DBHelper();

  readData() async {
    return await dbHelper.readEmploye(DBTable.employe);
  }

  saveData(Source action) async {
    return await dbHelper.insertEmploye(DBTable.employe, action.sourceMap());
  }

  deleteData(final mat) async{
    return await dbHelper.deleteEmploye(
        DBTable.employe,
        "Mat = ${mat}"
    );
  }

}