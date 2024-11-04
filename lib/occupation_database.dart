import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:geotagging_campaign/occupation.dart';


class OccupationDatabase {
  static final OccupationDatabase objects = OccupationDatabase.init();

  static Database? _database;

  OccupationDatabase.init();

  Future<Database> get database async {
    if (_database != null) return _database!;

    _database = await _initDB('geotagging_occupation.db');
    return _database!;
  }

  Future<Database> _initDB(String filepath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filepath);

    return await openDatabase(path, version: 1, onCreate: _createDB);
  }

  Future _createDB(Database db, int version) async {
    const idType = 'INTEGER PRIMARY KEY AUTOINCREMENT'; // Corrected spelling
    const stringType = 'TEXT NOT NULL';

    await db.execute('''
      CREATE TABLE $occupationTable (
        ${OccupationFields.id} $idType,
        ${OccupationFields.name} $stringType
      )
    ''');
  }

  Future<Occupation> createOccupation(Occupation occupation) async {
    final db = await objects.database;

    final existingOccupations = await db.query(
      occupationTable,
      where: '${OccupationFields.name} = ?',
      whereArgs: [occupation.name],
    );

    if (existingOccupations.isNotEmpty) {
      await updateOccupation(occupation);
      return occupation;
    } else {
      final id = await db.insert(
        occupationTable,
        occupation.toJson()
      );

      return occupation.copyWith(id: id);
    }
  }

  Future<Occupation> readOccupation(int id) async {
    final db = await objects.database;

    final maps = await db.query(
      occupationTable,
      where: '${OccupationFields.id} = ?',
      whereArgs: [id]
    );

    if (maps.isNotEmpty) {
      return Occupation.fromJson(maps.first);
    } else {
      throw Exception('Occupation not Found!');
    }
  }

  Future<List<Occupation>> readAllOccupation() async {
    final db = await objects.database;

    const orderBy = '${OccupationFields.id} ASC';

    final result = await db.query(
      occupationTable,
      orderBy: orderBy
    );

    return result.map((json) => Occupation.fromJson(json)).toList();
  }

  Future<int> updateOccupation(Occupation occupation) async {
    final db = await objects.database;

    return db.update(
      occupationTable,
      occupation.toJson(),
      where:'${OccupationFields.id} = ?',
      whereArgs: [occupation.id],
    );
  }

  Future<int> delete(int id) async {
    final db = await objects.database;

    return await db.delete(
      occupationTable,
      where: '${OccupationFields.id} = ?',
      whereArgs: [id],
    );
  }

  Future close() async {
    final db = await objects.database;

    db.close();
  }
}