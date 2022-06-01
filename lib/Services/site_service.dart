import '../Repositories/db_helper.dart';

class SiteService {

  DBHelper dbHelper = DBHelper();

  readData() async {
    //first method
    //return await dbHelper.readSite("select * from site");
    //second method
    return await dbHelper.readFromSqlite("site");
  }

  saveData(final name, final description) async {
   /* return await dbHelper.insertSite('''
                        INSERT INTO site (`name`, `description`)
                        VALUES ("${name}", "${description}")
                        '''); */
    return await dbHelper.insertInSqlite("site", {
      "name": "${name}",
      "description": "${description}"
    });
  }

  editData(final id, final name, final description) async {
   /* return await dbHelper.updateSite(
        '''
          UPDATE site SET 
          name = "${name}", 
          description = "${description}" 
          WHERE id = "${id}"
        '''
    ); */
    return await dbHelper.updateFromSqlite("site", {
      "name": "${name}",
      "description": "${description}"
    },
      "id = ${id}"
    );
  }

  deleteData(final id) async{
    return await dbHelper.deleteSite(
        "DELETE FROM site WHERE id = ${id}"
    );
  }
}