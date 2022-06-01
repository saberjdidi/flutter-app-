import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

import '../Config/db_table.dart';

class DBHelper {
  // ? accept null
  //! return !null
  static Database? _db; //_db static and private

  Future<Database?> get db async {
    if(_db == null) {
      //intialization
      _db = await initializeDb();
      return _db;
    }
    else {
      return _db;
    }
  }

  //initialize the database
  initializeDb() async {
    // Get a location using getDatabasesPath
    String databasepath = await getDatabasesPath();
    // Set your path to the database.
    String path = join(databasepath, DBTable.DB_Name);
    // to Opening a database path
    Database mydb = await openDatabase(path, onCreate: _onCreatingDatabase, version: 1, onUpgrade: _onUpgradingDatabase);
    return mydb;
  }

  _onCreatingDatabase(Database database, int version) async {
    //add on table
    /*await database.execute("CREATE TABLE site(id INTEGER PRIMARY KEY AUTOINCREMENT, name TEXT, description TEXT)");
    print("create database and table"); */

    //many tables
    //Batch use when add many table in database
    Batch batch = database.batch();
    batch.execute("CREATE TABLE site(id INTEGER PRIMARY KEY AUTOINCREMENT, name TEXT, description TEXT)");
    batch.execute("CREATE TABLE processus(id INTEGER PRIMARY KEY AUTOINCREMENT, name TEXT, description TEXT)");
    batch.execute("CREATE TABLE categorie(id INTEGER PRIMARY KEY AUTOINCREMENT, name TEXT, description TEXT)");
    batch.execute("CREATE TABLE ${DBTable.action}(NAct INTEGER PRIMARY KEY AUTOINCREMENT, Act TEXT, MatDeclancheur TEXT, CodeTypeAct INTEGER, CodeSourceAct INTEGER, RefAudit TEXT, DescPb TEXT, Cause TEXT, Date DATETIME, CodeSite INTEGER, id_domaine INTEGER)");
    batch.execute("CREATE TABLE ${DBTable.source_action}(CodeSourceAct INTEGER PRIMARY KEY AUTOINCREMENT, SourceAct TEXT, act_simp INTEGER, obs_constat INTEGER, Supp INTEGER)");
    batch.execute("CREATE TABLE ${DBTable.type_action}(CodetypeAct INTEGER PRIMARY KEY AUTOINCREMENT, TypeAct TEXT, codif_auto INTEGER, act_simpl INTEGER, Supp INTEGER, analyse_cause INTEGER)");
    batch.execute("CREATE TABLE ${DBTable.cause_action}(codetypecause INTEGER PRIMARY KEY AUTOINCREMENT, typecause TEXT, Amdec INTEGER)");
    batch.execute("CREATE TABLE IF NOT EXISTS ${DBTable.activite}(Code_domaine INTEGER PRIMARY KEY AUTOINCREMENT, domaine TEXT, abreviation TEXT)");
    batch.execute("CREATE TABLE ${DBTable.sous_action}(id INTEGER PRIMARY KEY AUTOINCREMENT, NAct INTEGER, Designation TEXT, date_real TEXT, date_suivi TEXT, risque TEXT)");
    batch.execute("CREATE TABLE ${DBTable.priorite}(codepriorite INTEGER PRIMARY KEY AUTOINCREMENT, priorite TEXT)");
    batch.execute("CREATE TABLE ${DBTable.gravite_action}(codegravite INTEGER PRIMARY KEY AUTOINCREMENT, gravite TEXT)");
    batch.execute("CREATE TABLE ${DBTable.employe}(id INTEGER PRIMARY KEY AUTOINCREMENT, Mat TEXT, Nompre TEXT, Adresse_mail TEXT, Tel TEXT)");
    batch.execute("CREATE TABLE Note(id INTEGER PRIMARY KEY AUTOINCREMENT, name TEXT, description TEXT, image TEXT)");
    await batch.commit();
  }

  _onUpgradingDatabase(Database database, int oldVersion, int newVersion) async {
    print("upgrade database and table");
    //await database.execute("ALTER TABLE site ADD COLUMN color TEXT");
  }

  deletingDatabase() async {
    String databasepath = await getDatabasesPath();
    String path = join(databasepath, 'todolist.db');
    await deleteDatabase(path);
  }

  //first method
  readSite(String sql) async {
    Database? mydb = await db;
    List<Map> response = await mydb!.rawQuery(sql);
    return response;
  }

  insertSite(String sql) async {
    Database? mydb = await db;
    int response = await mydb!.rawInsert(sql);
    return response;
  }

  updateSite(String sql) async {
    Database? mydb = await db;
    int response = await mydb!.rawUpdate(sql);
    return response;
  }

  deleteSite(String sql) async {
    Database? mydb = await db;
    int response = await mydb!.rawDelete(sql);
    return response;
  }

  //second method
  readFromSqlite(String table) async {
    Database? mydb = await db;
    List<Map> response = await mydb!.query(table);
    return response;
  }

  insertInSqlite(String table, Map<String, Object?> value) async {
    Database? mydb = await db;
    int response = await mydb!.insert(table, value);
    return response;
  }

  updateFromSqlite(String table, Map<String, Object?> value, String? id) async {
    Database? mydb = await db;
    int response = await mydb!.update(table, value, where: id);
    return response;
  }

  deleteFromSqlite(String table, String? id) async {
    Database? mydb = await db;
    int response = await mydb!.delete(table, where: id);
    return response;
  }

  //category
  readCategory(String table) async {
    Database? mydb = await db;
    List<Map> response = await mydb!.query(table);
    return response;
  }

  insertCategory(String table, Map<String, Object?> value) async {
    Database? mydb = await db;
    int response = await mydb!.insert(table, value);
    return response;
  }

  updateCategory(String table, data) async {
    Database? mydb = await db;
    int response = await mydb!.update(table, data, where: 'id=?', whereArgs: [data['id']]);
    return response;
  }

  deleteCategory(String table, String? id) async {
    Database? mydb = await db;
    int response = await mydb!.delete(table, where: id);
    return response;
  }

  readCategoryById(table, itemId) async {
    Database? mydb = await db;
    var response = await mydb!.query(table, where: 'id=?', whereArgs: [itemId]);
    return response;
  }

  //Action
  readAction(String table) async {
    Database? mydb = await db;
    List<Map> response = await mydb!.query(table);
    return response;
  }

  insertAction(String table, data) async {
    Database? mydb = await db;
    int response = await mydb!.insert(table, data);
    return response;
  }

  updateAction(String table, data) async {
    Database? mydb = await db;
    int response = await mydb!.update(table, data, where: 'NAct=?', whereArgs: [data['NAct']]);
    return response;
  }

  deleteAction(String table, String? id) async {
    Database? mydb = await db;
    int response = await mydb!.delete(table, where: id);
    return response;
  }

  readActionById(table, itemId) async {
    Database? mydb = await db;
    var response = await mydb!.query(table, where: 'NAct=?', whereArgs: [itemId]);
    return response;
  }

  /*Future<int> countAction(String sql) async {
    Database? mydb = await db;
    int count = mydb!.execute("SELECT COUNT(*) FROM ${DBTable.action}") as int;
    var response = (await mydb!.rawQuery(sql));
    return count;
  }  */

  getCountAction() async {
    //database connection
    Database? mydb = await db;
    var x = await mydb!.rawQuery('SELECT COUNT (*) from ${DBTable.action}');
        int? count = Sqflite.firstIntValue(x);
    return count;
  }

  //Source
  readSource(String table) async {
    Database? mydb = await db;
    List<Map> response = await mydb!.query(table);
    return response;
  }

  insertSource(String table, data) async {
    Database? mydb = await db;
    int response = await mydb!.insert(table, data);
    return response;
  }

  updateSource(String table, data) async {
    Database? mydb = await db;
    int response = await mydb!.update(table, data, where: 'CodeSourceAct=?', whereArgs: [data['CodeSourceAct']]);
    return response;
  }

  deleteSource(String table, String? id) async {
    Database? mydb = await db;
    int response = await mydb!.delete(table, where: id);
    return response;
  }

  //TypeAction
  readTypeAction(String table) async {
    Database? mydb = await db;
    List<Map> response = await mydb!.query(table);
    return response;
  }

  insertTypeAction(String table, data) async {
    Database? mydb = await db;
    int response = await mydb!.insert(table, data);
    return response;
  }

  updateTypeAction(String table, data) async {
    Database? mydb = await db;
    int response = await mydb!.update(table, data, where: 'CodetypeAct=?', whereArgs: [data['CodetypeAct']]);
    return response;
  }

  deleteTypeAction(String table, String? id) async {
    Database? mydb = await db;
    int response = await mydb!.delete(table, where: id);
    return response;
  }

  //CauseAction
  Future<List<Map>> readCauseAction(String table) async {
    Database? mydb = await db;
    List<Map> response = await mydb!.query(table);
    return response;
  }

  Future<int> insertCauseAction(String table, data) async {
    Database? mydb = await db;
    final response = await mydb!.insert(table, data);
    return response;
  }

  Future<int> updateCauseAction(String table, data) async {
    Database? mydb = await db;
    final response = await mydb!.update(table, data, where: 'codetypecause=?', whereArgs: [data['codetypecause']]);
    return response;
  }

  Future<int> deleteCauseAction(String table, String? id) async {
    Database? mydb = await db;
    final response = await mydb!.delete(table, where: id);
    return response;
  }

  //Activite
  Future<List<Map>> readActivite(String table) async {
    Database? mydb = await db;
    List<Map> response = await mydb!.query(table);
    return response;
  }

  Future<int> insertActivite(String table, data) async {
    Database? mydb = await db;
    final response = await mydb!.insert(table, data);
    return response;
  }

  Future<int> updateActivite(String table, data) async {
    Database? mydb = await db;
    final response = await mydb!.update(table, data, where: 'Code_domaine=?', whereArgs: [data['Code_domaine']]);
    return response;
  }

  Future<int> deleteActivite(String table, String? id) async {
    Database? mydb = await db;
    final response = await mydb!.delete(table, where: id);
    return response;
  }

  //SousAction
  readSousAction(String table, actionId) async {
    Database? mydb = await db;
    List<Map> response = await mydb!.query(table, where: 'NAct=?', whereArgs: [actionId]);
    return response;
  }

  insertSousAction(String table, data) async {
    Database? mydb = await db;
    int response = await mydb!.insert(table, data);
    return response;
  }

  updateSousAction(String table, data) async {
    Database? mydb = await db;
    int response = await mydb!.update(table, data, where: 'id=?', whereArgs: [data['id']]);
    return response;
  }

  deleteSousAction(String table, String? id) async {
    Database? mydb = await db;
    int response = await mydb!.delete(table, where: id);
    return response;
  }

  //Priorite
  Future<List<Map>> readPriorite(String table) async {
    Database? mydb = await db;
    List<Map> response = await mydb!.query(table);
    return response;
  }

  Future<int> insertPriorite(String table, data) async {
    Database? mydb = await db;
    final response = await mydb!.insert(table, data);
    return response;
  }

  Future<int> updatePriorite(String table, data) async {
    Database? mydb = await db;
    final response = await mydb!.update(table, data, where: 'codepriorite=?', whereArgs: [data['codepriorite']]);
    return response;
  }

  Future<int> deletePriorite(String table, String? id) async {
    Database? mydb = await db;
    final response = await mydb!.delete(table, where: id);
    return response;
  }

  //GraviteAction
  Future<List<Map>> readGraviteAction(String table) async {
    Database? mydb = await db;
    List<Map> response = await mydb!.query(table);
    return response;
  }

  Future<int> insertGraviteAction(String table, data) async {
    Database? mydb = await db;
    final response = await mydb!.insert(table, data);
    return response;
  }

  Future<int> updateGraviteAction(String table, data) async {
    Database? mydb = await db;
    final response = await mydb!.update(table, data, where: 'codegravite=?', whereArgs: [data['codegravite']]);
    return response;
  }

  Future<int> deleteGraviteAction(String table, String? id) async {
    Database? mydb = await db;
    final response = await mydb!.delete(table, where: id);
    return response;
  }

  //Employe
  Future<List<Map>> readEmploye(String table) async {
    Database? mydb = await db;
    List<Map> response = await mydb!.query(table);
    return response;
  }

  Future<int> insertEmploye(String table, data) async {
    Database? mydb = await db;
    final response = await mydb!.insert(table, data);
    return response;
  }

  Future<int> deleteEmploye(String table, String? id) async {
    Database? mydb = await db;
    final response = await mydb!.delete(table, where: id);
    return response;
  }

  //Note
  readNote(String table) async {
    Database? mydb = await db;
    List<Map> response = await mydb!.query(table);
    return response;
  }

  insertNote(String table, data) async {
    Database? mydb = await db;
    int response = await mydb!.insert(table, data);
    return response;
  }

  //User

  deleteAllUser() async {
    Database? mydb = await db;
    int response = await mydb!.rawDelete("DELETE FROM User");
    return response;
  }

  Future close() async{
    Database? mydb = await db;
    await mydb!.close();
  }

}

