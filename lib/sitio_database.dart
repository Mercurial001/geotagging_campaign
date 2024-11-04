import 'package:geotagging_campaign/sitios.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class SitioDatabase {
  static final SitioDatabase objects = SitioDatabase._init();

  static Database? _database;

  SitioDatabase._init();

  Future<Database> get database async {
    if (_database != null) return _database!;

    _database = await _initDB('geotagging_sitio.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dBPath = await getDatabasesPath();
    final path = join(dBPath, filePath);

    return await openDatabase(path, version: 2, onCreate: _createDB, onUpgrade: _upgradeDB);
  }

  Future _createDB(Database db, int version) async {
    const idType = 'INTEGER PRIMARY KEY AUTOINCREMENT';
    const textType = 'TEXT NOT NULL';
    const intType = 'INTEGER NOT NULL';
    const intTypeNullable = 'INTEGER';
    const realTypeNullable = 'REAL';

    await db.execute('''
      CREATE TABLE $sitioTable (
        ${SitioFields.id} $idType,
        ${SitioFields.name} $textType,
        ${SitioFields.population} $intTypeNullable,
        ${SitioFields.brgy} $intType,
        ${SitioFields.lat} $realTypeNullable,
        ${SitioFields.long} $realTypeNullable
      )
    ''');
  }

  Future<Sitio> createSitio(Sitio sitio) async {
    final db = await objects.database;

    final existingSitio = await db.query(
      sitioTable,
      where: '${SitioFields.name} = ?',
      whereArgs: [sitio.name]
    );

    if (existingSitio.isNotEmpty) {
      await updateSitio(sitio);
      return sitio;
    } else {
      final id = await db.insert(
        sitioTable,
        sitio.toJson()
      );
      return sitio.copyWith(id: id);
    }
  }

  Future<Sitio> readSitio(int id) async {
    final db = await objects.database;

    final maps = await db.query(
      sitioTable,
      columns: SitioFields.values,
      where: '${SitioFields.id} = ?',
      whereArgs: [id]
    );

    if (maps.isNotEmpty) {
      return Sitio.fromMap(maps.first);
    } else {
      throw Exception('Not Found');
    }
  }

  Future<List<Sitio>> allSitios() async {
    final db = await objects.database;

    const orderBy = '${SitioFields.brgy} ASC';

    final result = await db.query(
      sitioTable,
      orderBy: orderBy
    );

    return result.map((json) => Sitio.fromJson(json)).toList();
  }

  Future<int> updateSitio(Sitio sitio) async {
    final db = await objects.database;

    return db.update(
      sitioTable,
      sitio.toJson(),
      where: '${SitioFields.id} = ?',
      whereArgs: [sitio.id]
    );
  }

  Future<int> deleteSitio(int? id) async {
    final db = await objects.database;

    return db.delete(
      sitioTable,
      where: '${SitioFields.id} = ?',
      whereArgs: [id]
    );
  }

  Future<void> _upgradeDB(Database db, int oldVersion, int newVersion) async {
    if (oldVersion < 2) {
      await db.execute('ALTER TABLE $sitioTable ADD COLUMN ${SitioFields.population} INTEGER');
    }
  }

  Future<void> deleteDatabase(path) async { // Use your database name
    try {
      await deleteDatabase(path);
      print('Database deleted successfully');
    } catch (e) {
      print('Error deleting database: $e');
    }
  }

  Future close() async {
    final db = await objects.database;

    db.close();
  }
}