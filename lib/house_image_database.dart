import 'dart:io';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:geotagging_campaign/house_image.dart';

class HouseImageDatabase {
  static final HouseImageDatabase objects = HouseImageDatabase._init();

  static Database? _database;

  HouseImageDatabase._init();

  Future<Database> get database async {
    if (_database != null) {
      return _database!;
    }
    _database = await _initDB('geotaggingHouseImage.db');
    return _database!;
  }

  Future<Database> _initDB(String filepath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filepath);

    // return await openDatabase(path, version: 1, onCreate: _createDB);
    // UPgraded on 03/11/2024 dd/mm/yyyy 
    return await openDatabase(path, version: 2, onCreate: _createDB, onUpgrade: _upgradeDB);
    // return await openDatabase(path, version: 2, onCreate: _createDB, onUpgrade: _upgradeDB);
    // return await openDatabase(path, version: 3, onCreate: _createDB, onUpgrade: _upgradeDB);
  }

  Future _createDB(Database db, int version) async {
    const idType = 'INTEGER PRIMARY KEY AUTOINCREMENT';
    const textType = 'TEXT NOT NULL';
    const realType = 'REAL NOT NULL';

    await db.execute('''
      CREATE TABLE $houseImageTable (
        ${HouseImageFields.id} $idType,
        ${HouseImageFields.imagePath} $textType,
        ${HouseImageFields.residence} $textType,
        ${HouseImageFields.brgy} $textType,        
        ${HouseImageFields.sitio} $textType,
        ${HouseImageFields.latitude} $realType,
        ${HouseImageFields.longitude} $realType
      )
    ''');
  }

  Future<HouseImage> create(HouseImage houseImage) async {
    final db = await objects.database;

    // Check if the residence already exists in the database
    final existingHouseImageResidence = await db.query(
      houseImageTable,
      where: '${HouseImageFields.residence} = ?',
      whereArgs: [houseImage.residence],
    );

    if (existingHouseImageResidence.isNotEmpty) {
      // Convert the first matching map to a HouseImage object
      await update(HouseImage.fromJson(existingHouseImageResidence.first));
      return HouseImage.fromJson(existingHouseImageResidence.first);
    } else {
      // Insert the new HouseImage record
      final id = await db.insert(
        houseImageTable,
        houseImage.toJson(),
      );

      // Return the new HouseImage with the assigned id
      return houseImage.copyWith(id: id);
    }
  }

  Future<HouseImage> get(int id) async {
    final db = await objects.database;

    final maps = await db.query(
      houseImageTable,
      columns: HouseImageFields.values,
      where: '${HouseImageFields.id} = ?',
      whereArgs: [id]
    );

    if (maps.isNotEmpty) {
      return HouseImage.fromJson(maps.first);
    } else {
      throw Exception("House Image not Found");
    }
  }

  Future<List<HouseImage>> all() async {
    final db = await objects.database;
    final orderBy = '${HouseImageFields.brgy} ASC ';

    final results = await db.query(
      houseImageTable,
      orderBy: orderBy
    );

    return results.map((json) => HouseImage.fromJson(json)).toList();
  }

  Future<int> update(HouseImage houseImage) async {
    final db = await objects.database;

    return db.update(
      houseImageTable,
      houseImage.toJson(),
      where: '${HouseImageFields.id} = ?',
      whereArgs: [houseImage.id]
    );
  }

  Future<int> delete(int id) async {
    final db = await objects.database;

    final houseImage = await db.query(
      houseImageTable,
      columns: [HouseImageFields.imagePath],
      where: '${HouseImageFields.id} = ?',
      whereArgs: [id]
    );

    if (houseImage.isNotEmpty) {
      final pathOfImage = houseImage.first[HouseImageFields.imagePath] as String;

      if (pathOfImage.isNotEmpty) {
        final file = File(pathOfImage);
        if (await file.exists()) {
          await file.delete();
        }
      }
    }

    return db.delete(
      houseImageTable,
      where: '${HouseImageFields.id} = ?',
      whereArgs: [id]
    );
  }

  // Future<void> _upgradeDB(Database db, int oldVersion, int newVersion) async {
  //   if (oldVersion < 2) {
  //     await db.execute('ALTER TABLE $houseImageTable ADD COLUMN ${HouseImageFields.brgy} TEXT');
  //     await db.execute('ALTER TABLE $houseImageTable ADD COLUMN ${HouseImageFields.sitio} TEXT');
  //   }
  // }

  // Future<void> _upgradeDB(Database db, int oldVersion, int newVersion) async {
  //   if (oldVersion < 3) {
  //     await db.execute('ALTER TABLE $houseImageTable ADD COLUMN ${HouseImageFields.brgy} TEXT');
  //     await db.execute('ALTER TABLE $houseImageTable ADD COLUMN ${HouseImageFields.sitio} TEXT');
  //   }
  // }

  Future<void> _upgradeDB(Database db, int oldVersion, int newVersion) async {
    if (oldVersion < 2) {
      await db.execute('ALTER TABLE $houseImageTable ADD COLUMN ${HouseImageFields.latitude} REAL NOT NULL');
      await db.execute('ALTER TABLE $houseImageTable ADD COLUMN ${HouseImageFields.longitude} REAL NOT NULL');
    }
  }

  Future<void> close() async {
    final db = await objects.database;
    await db.close();
  }
}