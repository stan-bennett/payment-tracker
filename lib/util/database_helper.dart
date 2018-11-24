import 'dart:async';

import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:payment_tracker/model/payment.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = new DatabaseHelper.internal();

  factory DatabaseHelper() => _instance;

  final String tablePayment = 'paymentTable';
  final String columnId = 'id';
  final String columnAmount = 'amount';
  final String columnDate = 'date';
  final String columnDay = 'day';
  final String columnName = 'name';

  static Database _db;

  DatabaseHelper.internal();

  Future<Database> get db async {
    if (_db != null) {
      return _db;
    }
    _db = await initDb();

    return _db;
  }

  initDb() async {
    String databasesPath = await getDatabasesPath();
    String path = join(databasesPath, 'payments.db');

    await deleteDatabase(path); // just for testing

    var db = await openDatabase(path, version: 1, onCreate: _onCreate);
    return db;
  }

  void _onCreate(Database db, int newVersion) async {
    await db.execute(
        'CREATE TABLE $tablePayment($columnId INTEGER PRIMARY KEY, $columnName TEXT, $columnAmount REAL, $columnDate INTEGER, $columnDay INTEGER)');
  }

  Future<int> savePayment(Payment payment) async {
    var dbClient = await db;
    var result = await dbClient.insert(tablePayment, payment.toMap());
//    var result = await dbClient.rawInsert(
//        'INSERT INTO $tablePayment ($columnTitle, $columnDescription) VALUES (\'${payment.name}\', \'${payment.description}\')');

    return result;
  }

  Future<List> getAllPayments() async {
    var dbClient = await db;
    var result = await dbClient.query(tablePayment,
        columns: [columnId, columnName, columnAmount, columnDate, columnDay]);
//    var result = await dbClient.rawQuery('SELECT * FROM $tablePayment');

    return result.toList();
  }

  Future<int> getCount() async {
    var dbClient = await db;
    return Sqflite.firstIntValue(
        await dbClient.rawQuery('SELECT COUNT(*) FROM $tablePayment'));
  }

  Future<Payment> getPayment(int id) async {
    var dbClient = await db;
    List<Map> result = await dbClient.query(tablePayment,
        columns: [columnId, columnName, columnAmount, columnDate, columnDay],
        where: '$columnId = ?',
        whereArgs: [id]);
//    var result = await dbClient.rawQuery('SELECT * FROM $tablePayment WHERE $columnId = $id');

    if (result.length > 0) {
      return new Payment.fromMap(result.first);
    }

    return null;
  }

  Future<int> deletePayment(int id) async {
    var dbClient = await db;
    return await dbClient
        .delete(tablePayment, where: '$columnId = ?', whereArgs: [id]);
//    return await dbClient.rawDelete('DELETE FROM $tablePayment WHERE $columnId = $id');
  }

  Future<int> updatePayment(Payment payment) async {
    var dbClient = await db;
    return await dbClient.update(tablePayment, payment.toMap(),
        where: "$columnId = ?", whereArgs: [payment.id]);
//    return await dbClient.rawUpdate(
//        'UPDATE $tablePayment SET $columnTitle = \'${payment.name}\', $columnDescription = \'${payment.description}\' WHERE $columnId = ${payment.id}');
  }

  Future close() async {
    var dbClient = await db;
    return dbClient.close();
  }
}
