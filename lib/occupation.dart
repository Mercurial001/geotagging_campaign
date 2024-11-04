String occupationTable = 'occupation';

class OccupationFields {
  static final List<String> values = [
    id, name,
  ];

  static const String id = 'id';
  static const String name = 'name';
}

class Occupation {
  int? id;
  String name;
  Occupation({
    required this.id,
    required this.name,
  });

  Occupation copyWith({
    int? id,
    String? name,
  }) {
    return Occupation(
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

  factory Occupation.fromMap(Map<String, dynamic> map) {
    return Occupation(
      id: map['id'] != null ? map['id'] as int : null,
      name: map['name'] as String,
    );
  }

  // String toJson() => json.encode(toMap());
  Map<String, Object?> toJson() => {
    OccupationFields.id: id,
    OccupationFields.name: name,
  };

  // factory Occupation.fromJson(String source) => Occupation.fromMap(json.decode(source) as Map<String, dynamic>);
  static Occupation fromJson(Map<String, Object?> json) => Occupation(
    id: json[OccupationFields.id] as int,
    name: json[OccupationFields.name] as String,
  );

  @override
  String toString() => 'Occupation(id: $id, name: $name)';

  @override
  bool operator ==(covariant Occupation other) {
    if (identical(this, other)) return true;
  
    return 
      other.id == id &&
      other.name == name;
  }

  @override
  int get hashCode => id.hashCode ^ name.hashCode;
}
