const String barangayTable = 'barangay';

class BarangayFields {
  static final List<String> values = [
    id, brgy_name, brgy_voter_population, lat, long
  ];

  static const String id = 'id';
  static const String brgy_name = 'brgy_name';
  static const String brgy_voter_population = 'brgy_voter_population';
  static const String lat = 'lat';
  static const String long = 'long';
}

class Barangay {
  int? id;
  String brgy_name;
  int? brgy_voter_population;
  double? lat;
  double? long;
  Barangay({
    this.id,
    required this.brgy_name,
    this.brgy_voter_population,
    this.lat,
    this.long,
  });

  Barangay copyWith({
    int? id,
    String? brgy_name,
    int? brgy_voter_population,
    double? lat,
    double? long,
  }) {
    return Barangay(
      id: id ?? this.id,
      brgy_name: brgy_name ?? this.brgy_name,
      brgy_voter_population: brgy_voter_population ?? this.brgy_voter_population,
      lat: lat ?? this.lat,
      long: long ?? this.long,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'brgy_name': brgy_name,
      'brgy_voter_population': brgy_voter_population,
      'lat': lat,
      'long': long,
    };
  }

  factory Barangay.fromMap(Map<String, dynamic> map) {
    return Barangay(
      id: map[BarangayFields.id] != null ? map[BarangayFields.id] as int : null,
      brgy_name: map[BarangayFields.brgy_name] as String,
      brgy_voter_population: map[BarangayFields.brgy_voter_population] != null 
          ? (map[BarangayFields.brgy_voter_population] is int 
              ? map[BarangayFields.brgy_voter_population] as int 
              : (map[BarangayFields.brgy_voter_population] as num).toInt()) 
          : null,
      lat: map[BarangayFields.lat] != null 
          ? (map[BarangayFields.lat] is double 
              ? map[BarangayFields.lat] as double 
              : (map[BarangayFields.lat] as num).toDouble()) 
          : null,
      long: map[BarangayFields.long] != null 
          ? (map[BarangayFields.long] is double 
              ? map[BarangayFields.long] as double 
              : (map[BarangayFields.long] as num).toDouble()) 
          : null,
    );
  }
  // factory Barangay.fromMap(Map<String, dynamic> map) {
  //   return Barangay(
  //     id: map['id'] != null ? map['id'] as int : null,
  //     brgy_name: map['brgy_name'] as String,
  //     brgy_voter_population: map['brgy_voter_population'] != null ? map['brgy_voter_population'] as int : null,
  //     lat: map['lat'] != null ? map['lat'] as double : null,
  //     long: map['long'] != null ? map['long'] as double : null,
  //   );
  // }

  Map<String, Object?> toJson() => {
    BarangayFields.id: id,
    BarangayFields.brgy_name: brgy_name,
    BarangayFields.brgy_voter_population: brgy_voter_population,
    BarangayFields.lat: lat,
    BarangayFields.long: long,
  };

  // factory Barangay.fromJson(String source) => Barangay.fromMap(json.decode(source) as Map<String, dynamic>);
  // static Barangay fromJson(Map<String, Object?> json) => Barangay(
  //   id: json[BarangayFields.id] as int?,
  //   brgy_name: json[BarangayFields.brgy_name] as String,
  //   brgy_voter_population: json[BarangayFields.brgy_voter_population] as int?,
  //   lat: json[BarangayFields.lat] as double?,
  //   long: json[BarangayFields.long] as double?
  // );

  static Barangay fromJson(Map<String, Object?> json) => Barangay(
    id: json[BarangayFields.id] as int?,
    brgy_name: json[BarangayFields.brgy_name] as String,
    brgy_voter_population: json[BarangayFields.brgy_voter_population] != null 
        ? (json[BarangayFields.brgy_voter_population] is int 
            ? json[BarangayFields.brgy_voter_population] as int 
            : (json[BarangayFields.brgy_voter_population] as num).toInt()) 
        : null,
    lat: json[BarangayFields.lat] != null 
        ? (json[BarangayFields.lat] is double 
            ? json[BarangayFields.lat] as double 
            : (json[BarangayFields.lat] as num).toDouble()) 
        : null,
    long: json[BarangayFields.long] != null 
        ? (json[BarangayFields.long] is double 
            ? json[BarangayFields.long] as double 
            : (json[BarangayFields.long] as num).toDouble()) 
        : null,
  );

  @override
  String toString() {
    return 'Barangay(id: $id, brgy_name: $brgy_name, brgy_voter_population: $brgy_voter_population, lat: $lat, long: $long)';
  }

  @override
  bool operator ==(covariant Barangay other) {
    if (identical(this, other)) return true;
  
    return 
      other.id == id &&
      other.brgy_name == brgy_name &&
      other.brgy_voter_population == brgy_voter_population &&
      other.lat == lat &&
      other.long == long;
  }

  @override
  int get hashCode {
    return id.hashCode ^
      brgy_name.hashCode ^
      brgy_voter_population.hashCode ^
      lat.hashCode ^
      long.hashCode;
  }
}
