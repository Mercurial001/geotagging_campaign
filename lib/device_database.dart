import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'device.dart';

class DeviceDatabase {
  static final DeviceDatabase instance = DeviceDatabase._init();

  static Database? _database;

  DeviceDatabase._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('devices.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(
      path,
      version: 1,
      onCreate: _createDB,
    );
  }
  
  Future _createDB(Database db, int version) async {
    const textType = 'TEXT NOT NULL';
    const boolType = 'BOOLEAN NOT NULL DEFAULT 1'; // Set default to true (1)
    const idType = 'INTEGER PRIMARY KEY AUTOINCREMENT';

    await db.execute('''
      CREATE TABLE $deviceTable (
        ${DeviceFields.id} $idType,
        ${DeviceFields.name} $textType,
        ${DeviceFields.uuid} $textType,
        ${DeviceFields.isBlocked} $boolType
      )
    ''');
  }
  // Future _createDB(Database db, int version) async {
  //   const textType = 'TEXT NOT NULL';
  //   const boolType = 'BOOLEAN NOT NULL';
  //   const idType = 'INTEGER PRIMARY KEY AUTOINCREMENT';

  //   await db.execute('''
  //     CREATE TABLE $deviceTable (
  //       ${DeviceFields.id} $idType,
  //       ${DeviceFields.name} $textType,
  //       ${DeviceFields.uuid} $textType,
  //       ${DeviceFields.isBlocked} $boolType
  //     )
  //   ''');
  // }

  Future<Device> create(Device device) async {
    final db = await instance.database;

    final existingDevice = await db.query(
      deviceTable,
      where: '''
        ${DeviceFields.name} = ? AND 
        ${DeviceFields.uuid} = ?
      ''',
      whereArgs: [
        device.name, 
        device.uuid, 
      ],
    );
    if (existingDevice.isNotEmpty) {
      await update(device);
      return device;
    } else {
      final id = await db.insert(deviceTable, device.toJson());
      return device.copyWith(id: id);
    }

    // await db.insert('devices', device.toMap());
    // return device;
  }

  Future<Device?> readDevice(String uuid) async {
    final db = await instance.database;
    final maps = await db.query(
      'devices',
      columns: ['name', 'uuid', 'isBlocked'],
      where: 'uuid = ?',
      whereArgs: [uuid],
    );

    if (maps.isNotEmpty) {
      return Device.fromMap(maps.first);
    } else {
      return null;
    }
  }

  Future<Device> createOrUpdate(Device device) async {
    final db = await instance.database;
    // Check for existing device
    final existingDevice = await db.query(
      deviceTable,
      where: '${DeviceFields.uuid} = ?',
      whereArgs: [device.uuid],
    );

    if (existingDevice.isNotEmpty) {
      await update(device); // Call update if exists
    } else {
      await db.insert(deviceTable, device.toJson()); // Insert if not exists
    }
    return device;
  }

  Future<Device> findOrCreateDevice({String? name, String? uuid}) async {
    final db = await instance.database;

    // Search for an existing device by name or uuid
    final existingDevice = await db.query(
      deviceTable,
      where: '${DeviceFields.name} = ? OR ${DeviceFields.uuid} = ?',
      whereArgs: [name, uuid],
    );

    if (existingDevice.isNotEmpty) {
      // Device found, return it
      return Device.fromMap(existingDevice.first);
    } else {
      // No device found, create a new one
      final newDevice = Device(
        name: name ?? "Unknown Device",
        uuid: uuid ?? "Unknown UUID",
        isBlocked: false,
      );

      await db.insert(deviceTable, newDevice.toJson());
      return newDevice;
    }
  }

  Future<Device> get({String? name, String? uuid}) async {
    final db = await instance.database;

    // Search for an existing device by name or uuid
    final existingDevice = await db.query(
      deviceTable,
      where: '${DeviceFields.name} = ? OR ${DeviceFields.uuid} = ?',
      whereArgs: [name, uuid],
    );

    // if (existingDevice.isNotEmpty) {
    //   // Device found, return it
    //  return Device.fromMap(existingDevice.first);
    // } else {
    //   // No device found, create a new one
    //   final newDevice = Device(
    //     name: name ?? "Unknown Device",
    //     uuid: uuid ?? "Unknown UUID",
    //     isBlocked: false,
    //   );

    //   await db.insert(deviceTable, newDevice.toJson());
    //   return newDevice;
    // }
    return Device.fromMap(existingDevice.first);
  }

  Future<List<Device>> readAllDevices() async {
    final db = await instance.database;
    final result = await db.query('devices');
    return result.map((json) => Device.fromMap(json)).toList();
  }

  Future<int> update(Device device) async {
    final db = await instance.database;

    return db.update(
      deviceTable,
      device.toJson(),
      where: '${DeviceFields.uuid} = ?',
      whereArgs: [device.uuid]
    );
    // return db.update(
    //   '$deviceTable',
    //   device.toMap(),
    //   where: 'uuid = ?',
    //   whereArgs: [device.uuid],
    // );
  }

  Future<int> delete(String uuid) async {
    final db = await instance.database;
    return db.delete(
      'devices',
      where: 'uuid = ?',
      whereArgs: [uuid],
    );
  }

  Future close() async {
    final db = await instance.database;
    db.close();
  }
}
