import 'dart:async';

import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:payment_tracker/model/payment.dart';

class PaymentService {
  static final PaymentService _instance = new PaymentService.internal();

  factory PaymentService() => _instance;

  final String tablePayment = 'paymentTable';
  final String columnId = 'id';
  final String columnAmount = 'amount';
  final String columnDate = 'date';
  final String columnName = 'name';

  static Database _db;

  PaymentService.internal();

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
        'CREATE TABLE $tablePayment($columnId INTEGER PRIMARY KEY, $columnName TEXT, $columnAmount REAL, $columnDate INTEGER)');
  }

  Future<int> savePayment(Payment payment) async {
    var dbClient = await db;
    return await dbClient.insert(tablePayment, payment.toMap());
  }

  Future<List> getAllPayments() async {
    var dbClient = await db;
    var result = await dbClient.query(tablePayment,
        columns: [columnId, columnName, columnAmount, columnDate]);
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
        columns: [columnId, columnName, columnAmount, columnDate],
        where: '$columnId = ?',
        whereArgs: [id]);

    // guard clause - payment not found
    if (result.length == 0) {
      return null;
    }

    return new Payment.fromMap(result.first);
  }

  Future<int> deletePayment(int id) async {
    var dbClient = await db;
    return await dbClient
        .delete(tablePayment, where: '$columnId = ?', whereArgs: [id]);
  }

  Future<int> updatePayment(Payment payment) async {
    var dbClient = await db;
    return await dbClient.update(tablePayment, payment.toMap(),
        where: "$columnId = ?", whereArgs: [payment.id]);
  }

  Future close() async {
    var dbClient = await db;
    return dbClient.close();
  }
}
