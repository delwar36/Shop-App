import 'package:sqflite/sqflite.dart' as sql;
import 'package:path/path.dart' as path;
import 'package:sqflite/sqlite_api.dart';

class DBHelper {
  static Future<Database> database(String sqlCode, String dbName) async {
    final dbPath = await sql.getDatabasesPath();
    return sql.openDatabase(
      path.join(dbPath, '$dbName.db'),
      onCreate: (db, version) {
        db.execute(sqlCode);
      },
      version: 1,
    );
  }

  static Future<void> insert(
    String table,
    String dbName,
    String sqlCreate,
    Map<String, Object> data,
  ) async {
    final sqlDb = await DBHelper.database(sqlCreate, dbName);
    sqlDb.insert(
      table,
      data,
      conflictAlgorithm: sql.ConflictAlgorithm.replace,
    );
  }

  static Future<List<Map<String, dynamic>>> getData(String table,String dbName, String sqlCreate) async {
    final sqlDb = await DBHelper.database(sqlCreate, dbName);
    return sqlDb.query(table);
  }
}
