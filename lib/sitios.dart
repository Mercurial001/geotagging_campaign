// ignore_for_file: public_member_api_docs, sort_constructors_first
const String sitioTable = 'sitio';

class SitioFields {
  static final List<String> values = [
    id, name, population, brgy, lat, long
  ];

  static const String id = 'id';
  static const String name = 'name';
  static const String population = 'population';
  static const String brgy = 'brgy';
  static const String lat = 'lat';
  static const String long = 'long';
}

class Sitio {
  int? id;
  String name;
  String brgy;
  int? population;
  double? lat;
  double? long;
  Sitio({
    this.id,
    required this.name,
    required this.brgy,
    this.population,
    this.lat,
    this.long,
  });


  Sitio copyWith({
    int? id,
    String? name,
    String? brgy,
    int? population,
    double? lat,
    double? long,
  }) {
    return Sitio(
      id: id ?? this.id,
      name: name ?? this.name,
      brgy: brgy ?? this.brgy,
      population: population ?? this.population,
      lat: lat ?? this.lat,
      long: long ?? this.long,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'name': name,
      'brgy': brgy,
      'population': population,
      'lat': lat,
      'long': long,
    };
  }

  factory Sitio.fromMap(Map<String, dynamic> map) {
    return Sitio(
      id: map['id'] != null ? map['id'] as int : null,
      name: map['name'] as String,
      brgy: map['brgy'] as String,
      population: map['population'] != null ? map['population'] as int : null,
      lat: map['lat'] != null ? map['lat'] as double : null,
      long: map['long'] != null ? map['long'] as double : null,
    );
  }

  // String toJson() => json.encode(toMap());
  Map<String, Object?> toJson() => {
    SitioFields.id: id,
    SitioFields.name: name,
    SitioFields.brgy: brgy,
    SitioFields.population: population,
    SitioFields.lat: lat,
    SitioFields.long: long,
  };

  // factory Sitio.fromJson(String source) => Sitio.fromMap(json.decode(source) as Map<String, dynamic>);
  static Sitio fromJson(Map<String, Object?> json) => Sitio(
    id: json[SitioFields.id] as int?,
    name: json[SitioFields.name] as String,
    population: json[SitioFields.population] as int?,
    brgy: json[SitioFields.brgy] as String,
    lat: json[SitioFields.lat] as double?,
    long: json[SitioFields.long] as double?
  );


  @override
  String toString() {
    return 'Sitio(id: $id, name: $name, brgy: $brgy, population: $population, lat: $lat, long: $long)';
  }

  @override
  bool operator ==(covariant Sitio other) {
    if (identical(this, other)) return true;
  
    return 
      other.id == id &&
      other.name == name &&
      other.brgy == brgy &&
      other.population == population &&
      other.lat == lat &&
      other.long == long;
  }

  @override
  int get hashCode {
    return id.hashCode ^
      name.hashCode ^
      brgy.hashCode ^
      population.hashCode ^
      lat.hashCode ^
      long.hashCode;
  }
}
