const String religionTable = 'religion';

class ReligionFields {
  static final List<String> values = [
    id, name
  ];

  static const String id = '_id';
  static const String name = '_name';
}

class Religion {
  int? id;
  String name;
  Religion({
    required this.id,
    required this.name
  });

  

  Religion copyWith({
    int? id,
    String? name,
  }) {
    return Religion(
      id: id ?? this.id,
      name: name ?? this.name,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'name': name,
    };
  }

  factory Religion.fromMap(Map<String, dynamic> map) {
    return Religion(
      id: map['id'] != null ? map['id'] as int : null,
      name: map['name'] as String,
    );
  }

  // String toJson() => json.encode(toMap());
  Map<String, Object?> toJson() => {
    ReligionFields.id: id,
    ReligionFields.name: name,
  };

  //factory Religion.fromJson(String source) => Religion.fromMap(json.decode(source) as Map<String, dynamic>);
  static Religion fromJson(Map<String, Object?> json) => Religion(
    id: json[ReligionFields.id] as int,
    name: json[ReligionFields.name] as String,
  );

  @override
  String toString() => 'Religion(id: $id, name: $name)';

  @override
  bool operator ==(covariant Religion other) {
    if (identical(this, other)) return true;
  
    return 
      other.id == id &&
      other.name == name;
  }

  @override
  int get hashCode => id.hashCode ^ name.hashCode;
}
