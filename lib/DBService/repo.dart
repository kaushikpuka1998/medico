//@dart =2.9
import 'package:Medico/DBService/DatabaseConnection.dart';
import 'package:sqflite/sqflite.dart';

class Repo {
  DatabaseConnection _databaseConnection;

  Repo() {
    _databaseConnection = DatabaseConnection();
  }

  static Database _database;

  Future<Database> get database async {
    if (_database != null) return _database;

    _database = await _databaseConnection.setDatabase();
    return _database;
  }

  InsertData(table, data) async {
    var connection = await database;
    return await connection.insert(table, data);
  }

  readData(table) async {
    var connection = await database;
    return await connection.query(table);
  }
}
