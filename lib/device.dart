const String deviceTable = 'device';

class DeviceFields {
  static final List<String> values  = [
    id, name, uuid, isBlocked 
  ];

  static const String id = 'id';
  static const String name = 'name';
  static const String uuid = 'uuid';
  static const String isBlocked = 'isBlocked';
}

class Device {
  final int? id;
  final String name;
  final String uuid;
  bool isBlocked;
  Device({
    this.id,
    required this.name,
    required this.uuid,
    this.isBlocked = true,
  });


  Device copyWith({
    int? id,
    String? name,
    String? uuid,
    bool? isBlocked,
  }) {
    return Device(
      id: id ?? this.id,
      name: name ?? this.name,
      uuid: uuid ?? this.uuid,
      isBlocked: isBlocked ?? this.isBlocked,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'name': name,
      'uuid': uuid,
      'isBlocked': isBlocked,
    };
  }

  factory Device.fromMap(Map<String, dynamic> map) {
    return Device(
      id: map['id'] != null ? map['id'] as int : null,
      name: map['name'] as String,
      uuid: map['uuid'] as String,
      isBlocked: map['isBlocked'] as bool,
    );
  }

  // String toJson() => json.encode(toMap());
  Map<String, Object?> toJson() => {
    DeviceFields.id: id,
    DeviceFields.name: name,
    DeviceFields.uuid: uuid,
    DeviceFields.isBlocked: isBlocked,
  };

  //factory Religion.fromJson(String source) => Religion.fromMap(json.decode(source) as Map<String, dynamic>);
  static Device fromJson(Map<String, Object?> json) => Device(
    id: json[DeviceFields.id] as int?,
    name: json[DeviceFields.name] as String,
    uuid: json[DeviceFields.uuid] as String,
    isBlocked: json[DeviceFields.isBlocked] as bool,
  );

  @override
  String toString() {
    return 'Device(id: $id, name: $name, uuid: $uuid, isBlocked: $isBlocked)';
  }

  @override
  bool operator ==(covariant Device other) {
    if (identical(this, other)) return true;
  
    return 
      other.id == id &&
      other.name == name &&
      other.uuid == uuid &&
      other.isBlocked == isBlocked;
  }

  @override
  int get hashCode {
    return id.hashCode ^
      name.hashCode ^
      uuid.hashCode ^
      isBlocked.hashCode;
  }
}
