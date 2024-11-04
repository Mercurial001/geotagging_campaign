import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:geotagging_campaign/religion.dart';

class ReligionDatabase {
  static final ReligionDatabase instance = ReligionDatabase._init();

  static Database? _database;

  ReligionDatabase._init();
 
  Future<Database> get database async {
    if (_database !=null) return _database!;

    _database = await _initDB('geo_campaign_religion.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dBPath = await getDatabasesPath();
    final path = join(dBPath, filePath);

    return await openDatabase(path, version: 1, onCreate: _createDB);
  }

  Future _createDB(Database db, int version) async {
    const idType = 'INTEGER PRIMARY KEY AUTOINCREMENT';
    const textType = 'TEXT NOT NULL';
    // const realType = 'REAL NOT NULL';
    // const integerType = 'INTEGER NOT NULL';

    await db.execute('''
      CREATE TABLE $religionTable (
        ${ReligionFields.id} $idType,
        ${ReligionFields.name} $textType
      )
    '''); 
  }

  Future<Religion> createReligion(Religion religion) async {
    final db = await instance.database;

    final existingReligion = await db.query(
      religionTable,
      where: '${ReligionFields.id} = ?',
      whereArgs: [religion.id],
    );

    if (existingReligion.isNotEmpty) {
      await updateReligion(religion);
      return religion;
    } else {
      final id = await db.insert(religionTable, religion.toJson());
      return religion.copyWith(id: id);
    }
  }

  Future<Religion> readReligion(int id) async {
    final db = await instance.database;

    final maps = await db.query(
      religionTable,
      columns: ReligionFields.values,
      where: '${ReligionFields.id} = ?',
      whereArgs: [id]
    );

    if (maps.isNotEmpty) {
      return Religion.fromJson(maps.first);
    } else {
      throw Exception('Not Found');
    }
  }

  Future<List<Religion>> readAllReligion() async {
    final db = await instance.database;

    const orderBy = '${ReligionFields.id} DESC';

    final result = await db.query(religionTable, orderBy: orderBy);

    return result.map((json) => Religion.fromJson(json)).toList();
  }

  Future<int> updateReligion(Religion religion) async {
    final db = await instance.database;

    return db.update(
      religionTable, 
      religion.toJson(),
      where: '${religion.id} = ?',
      whereArgs: [religion.id],
    );
  }

  Future<int> deleteReligion(int id) async {
    final db = await instance.database;

    return await db.delete(
      religionTable,
      where: '${ReligionFields.id} = ?',
      whereArgs: [id],
    );
  }

  Future close() async {
    final db = await instance.database;

    db.close();
  }
}