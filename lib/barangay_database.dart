import "package:geotagging_campaign/barangay.dart";
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class BarangayDatabase {
  static final BarangayDatabase objects = BarangayDatabase.init();

  static Database? _database;

  BarangayDatabase.init();

  Future<Database> get database async {
    if (_database != null) return _database!;

    _database = await _initDB('geotagging_brgys.db');

    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(path, version: 1, onCreate: _createDB);
  }

Future _createDB(Database db, int version) async {
  const idType = 'INTEGER PRIMARY KEY AUTOINCREMENT'; // Corrected spelling
  const textType = 'TEXT NOT NULL';
  const doubleTypeNullable = 'REAL';
  const intTypeNullable = 'INTEGER';

  await db.execute('''
    CREATE TABLE $barangayTable (
      ${BarangayFields.id} $idType,
      ${BarangayFields.brgy_name} $textType,
      ${BarangayFields.brgy_voter_population} $intTypeNullable,
      ${BarangayFields.lat} $doubleTypeNullable,
      ${BarangayFields.long} $doubleTypeNullable
    )
  ''');
}

  Future<Barangay> createBarangay(Barangay barangay) async {
    final db = await objects.database;

    final existingBarangay = await db.query(
      barangayTable,
      where: '${BarangayFields.brgy_name} = ?',
      whereArgs: [barangay.brgy_name]
    );

    if (existingBarangay.isNotEmpty) {
      await updateBarangay(barangay);
      return barangay;
    } else {
      final id = await db.insert(
        barangayTable,
        barangay.toJson()
      );
      return barangay.copyWith(id: id);
    }
  }

  Future<Barangay> readBarangay(int id) async {
    final db = await objects.database;

    final maps = await db.query(
      barangayTable,
      columns: BarangayFields.values,
      where: '${BarangayFields.id} = ?',
      whereArgs: [id]
    );

    if (maps.isNotEmpty) {
      return Barangay.fromJson(maps.first);
    } else {
      throw Exception('Not Found');
    }
  }

  Future<List<Barangay>> readAllBarangays() async {
    final db = await objects.database;

    const orderBy = '${BarangayFields.brgy_name} ASC';

    final result = await db.query(
      barangayTable,
      orderBy: orderBy
    );

    return result.map((json) => Barangay.fromJson(json)).toList();
  }
  
  Future<int> updateBarangay(Barangay barangay) async {
    final db = await objects.database;

    return db.update(
      barangayTable,
      barangay.toJson(),
      where: '${BarangayFields.id} = ?',
      whereArgs: [barangay.id]
    );
  }

  Future<int> deleteBarangay(int? id) async {
    final db = await objects.database;

    return await db.delete(
      barangayTable,
      where: '${BarangayFields.id} = ?',
      whereArgs: [id]
    );
  }

  Future<void> deleteAllBarangayObjects() async {
    final db = await objects.database;

    await db.delete(barangayTable);
  }

  Future close() async {
    final db = await objects.database;

    db.close();
  }
}