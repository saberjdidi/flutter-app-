import 'package:first_app_flutter/Repositories/database_connection.dart';
import 'package:sqflite/sqflite.dart';

class Repository {
 late DatabaseConnection _databaseConnection;

 /* Repository(){
    //initialize _databaseConnection
    _databaseConnection = DatabaseConnection();
  } */

  static late Database _database;

  //check if database exist or not
  Future<Database> get database async {
    if(_database != null) return _database;

    _database = await _databaseConnection.setDatabase();

    return _database;
  }

  //insert data to table
   insertData(table, data) async {
    var connection = await database;
    return await connection.insert(table, data);
   }

   //read data from table
   readData(table) async {
     var connection = await database;
     return await connection.query(table);
   }
}