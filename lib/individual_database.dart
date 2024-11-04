import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:geotagging_campaign/individual.dart';
import 'dart:io';

class IndividualDatabase {
  static final IndividualDatabase objects = IndividualDatabase._init();

  static Database? _database;

  IndividualDatabase._init();

  Future<Database> get database async {
    if (_database != null) {
      return _database!;
    }

    _database = await _initDB('geotagging_individual.db');
    return _database!;
  }

  Future<Database> _initDB(String filepath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filepath);

    return await openDatabase(path, version: 1, onCreate: _createDB);
  }

  Future _createDB(Database db, int version) async {
    const idType = 'INTEGER PRIMARY KEY AUTOINCREMENT';
    const textTypeNullable = 'TEXT';
    const textType = 'TEXT NOT NULL';
    const realTypeNullable = 'REAL';

    await db.execute('''
      CREATE TABLE $individualTable (
        ${IndividualFields.id} $idType,
        ${IndividualFields.firstname} $textType,
        ${IndividualFields.middlename} $textType,
        ${IndividualFields.lastname} $textType,
        ${IndividualFields.suffix} $textTypeNullable,
        ${IndividualFields.gender} $textType,
        ${IndividualFields.brgy} $textType,
        ${IndividualFields.sitio} $textType,
        ${IndividualFields.image} $textTypeNullable,
        ${IndividualFields.houseImage} $textTypeNullable,
        ${IndividualFields.religion} $textTypeNullable,
        ${IndividualFields.churchName} $textTypeNullable,
        ${IndividualFields.educationalAttainment} $textTypeNullable,
        ${IndividualFields.occupation} $textTypeNullable,
        ${IndividualFields.mobileNumber} $textTypeNullable,
        ${IndividualFields.latitude} $realTypeNullable,
        ${IndividualFields.longitude} $realTypeNullable,
        ${IndividualFields.birthday} $textType,
        ${IndividualFields.isLeader} $textType,
        ${IndividualFields.isOOT} $textType,
        ${IndividualFields.familyRole} $textType,
        ${IndividualFields.surveyDate} $textType
      )
    ''');
  }

  Future<Individual> createIndividual(Individual individual) async {
    final db = await objects.database;

    final existingIndividual = await db.query(
      individualTable,
      where: '''
        ${IndividualFields.firstname} = ? AND 
        ${IndividualFields.middlename} = ? AND 
        ${IndividualFields.lastname} = ? AND
        ${IndividualFields.brgy} = ? AND
        ${IndividualFields.birthday} = ?
      ''',
      whereArgs: [
        individual.firstname, 
        individual.middlename, 
        individual.lastname,
        individual.brgy,
        individual.birthday.toIso8601String()
      ],
    );

    if (existingIndividual.isNotEmpty) {
      await updateIndividual(individual);
      return individual;
    } else {
      final id = await db.insert(
        individualTable,
        individual.toJson()
      );
      return individual.copyWith(id: id);
    }
  }

  Future<Individual> readIndividual(int id) async {
    final db = await objects.database;

    final maps = await db.query(
      individualTable,
      columns: IndividualFields.values,
      where: '${IndividualFields.id} = ?',
      whereArgs: [id],
    );

    if (maps.isNotEmpty) {
      return Individual.fromJson(maps.first);
    } else {
      throw Exception("Individual Not Found");
    }
  }

  Future<List<Individual>> all() async {
    final db = await objects.database;
    final orderBy = '${IndividualFields.lastname} ASC';

    final results = await db.query(
      individualTable,
      orderBy: orderBy
    );

    return results.map((json) => Individual.fromJson(json)).toList();
  }

  Future<int> updateIndividual(Individual individual) async {
    final db = await objects.database;

    return db.update(
      individualTable,
      individual.toJson(),
      where: '${IndividualFields.id} = ?',
      whereArgs: [individual.id]
    );
  }

  Future<int> delete(int individualId) async {
    final db = await objects.database;

    final individual = await db.query(
      individualTable,
      columns: [IndividualFields.image, IndividualFields.houseImage],
      where: '${IndividualFields.id} = ?',
      whereArgs: [individualId]
    );

    if (individual.isNotEmpty) {
      final imagePath = individual.first[IndividualFields.image] as String?;
      // final houseImagePath = individual.first[IndividualFields.houseImage] as String?;

      if (imagePath != null && imagePath.isNotEmpty) {
        final file = File(imagePath);
        if (await file.exists()) {
          await file.delete();
        }
      }

      // if (houseImagePath != null && houseImagePath.isNotEmpty) {
      //   final file = File(houseImagePath);
      //   if (await file.exists()) {
      //     await file.delete();
      //   }
      // }
    }

    return await db.delete(
      individualTable,
      where: '${IndividualFields.id} = ?',
      whereArgs: [individualId]
    );
  }

  Future<void> close() async {
    final db = await objects.database;
    await db.close();
  }
}
