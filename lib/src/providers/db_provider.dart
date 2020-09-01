import 'dart:io';

import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';

import 'package:qrreader/src/models/scan_model.dart';
export 'package:qrreader/src/models/scan_model.dart';

class DBProvider {
  static Database _database;
  static final DBProvider db = DBProvider._();

  DBProvider._();

  Future<Database> get database async {
    if (_database != null) return _database;

    _database = await _initDB();

    return _database;
  }

  _initDB() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();

    final path = join(documentsDirectory.path, 'ScanDB.db');

    return await openDatabase(path, version: 1, onOpen: (db) {}, onCreate: (Database db, int version) async {
      await db.execute('CREATE TABLE Scans ('
          ' id INTEGER PRIMARY KEY, '
          ' valor TEXT, '
          ' tipo TEXT )');
    });
  }

  Future<List<ScanModel>> getAllScans() async {
    final db = await database;
    final res = await db.rawQuery('SELECT * FROM Scans');
    List<ScanModel> list = res.isNotEmpty ? res.map((e) => ScanModel.fromJson(e)).toList() : [];
    return list;
  }

  Future<ScanModel> getScansID(int id) async {
    final db = await database;
    final res = await db.query('Scans', where: 'id = ?', whereArgs: [id]);
    return res.isNotEmpty ? ScanModel.fromJson(res.first) : null;
  }

  Future<List<ScanModel>> getScansTipo(String tipo) async {
    final db = await database;
    final res = await db.query('Scans', where: 'tipo = ?', whereArgs: [tipo]);
    List<ScanModel> list = res.isNotEmpty ? res.map((e) => ScanModel.fromJson(e)).toList() : [];
    return list;
  }

  nuevoScanRow(ScanModel nuevoScan) async {
    final db = await database;
    return await db.rawInsert("INSERT INTO Scans (id, tipo, valor) "
        " VALUES (${nuevoScan.id}, '${nuevoScan.tipo}', '${nuevoScan.valor}')");
  }

  nuevoScan(ScanModel nuevoScan) async {
    final db = await database;
    return await db.insert('Scans', nuevoScan.toJson());
  }

  Future<int> actualizarScan(ScanModel scan) async {
    final db = await database;

    return await db.update(
      'Scans',
      scan.toJson(),
      where: 'id = ?',
      whereArgs: [scan.id],
    );
  }

  Future<int> eliminarScans(int id) async {
    final db = await database;
    return await db.delete('Scans', where: 'id = ?', whereArgs: [id]);
  }

  Future<int> deleteAll() async {
    final db = await database;
    return await db.rawDelete('DELETE FROM Scans');
  }
}
