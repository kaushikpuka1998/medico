//@dart = 2.9
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';

class DatabaseConnection {
  setDatabase() async {
    var dir = await getApplicationDocumentsDirectory();
    var path = join(dir.path, 'medico');
    var database =
        await openDatabase(path, version: 1, onCreate: _oncreateDatabase);

    return database;
  }

  _oncreateDatabase(Database database, int version) async {
    await database.execute(
        "CREATE TABLE data(id INTEGER PRIMARY KEY,name TEXT,phone TEXT,amount TEXT,date TEXT,ptype TEXT,amtype TEXT)");
  }
}
