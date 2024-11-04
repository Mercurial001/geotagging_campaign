const String houseImageTable = 'houseImage';

class HouseImageFields {
  static final List<String> values = [
    id, imagePath, residence, brgy, sitio, latitude, longitude
  ];

  static const String id = 'id';
  static const String imagePath= 'imagePath';
  static const String residence = 'residence';
  static const String brgy = 'brgy';
  static const String sitio = 'sitio';
  static const String latitude = 'latitude';
  static const String longitude = 'longitude';
}

class HouseImage {
  int? id;
  String imagePath;
  String residence;
  String? brgy;
  String? sitio;
  double latitude;
  double longitude;
  HouseImage({
    this.id,
    required this.imagePath,
    required this.residence,
    this.brgy,
    this.sitio,
    required this.latitude,
    required this.longitude,
  });

  HouseImage copyWith({
    int? id,
    String? imagePath,
    String? residence,
    String? brgy,
    String? sitio,
    double? latitude,
    double? longitude,
  }) {
    return HouseImage(
      id: id ?? this.id,
      imagePath: imagePath ?? this.imagePath,
      residence: residence ?? this.residence,
      brgy: brgy ?? this.brgy,
      sitio: sitio ?? this.sitio,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'imagePath': imagePath,
      'residence': residence,
      'brgy': brgy,
      'sitio': sitio,
      'latitude': latitude,
      'longitude': longitude,
    };
  }

  factory HouseImage.fromMap(Map<String, dynamic> map) {
    return HouseImage(
      id: map['id'] != null ? map['id'] as int : null,
      imagePath: map['imagePath'] as String,
      residence: map['residence'] as String,
      brgy: map['brgy'] != null ? map['brgy'] as String : null,
      sitio: map['sitio'] != null ? map['sitio'] as String : null,
      latitude: map['latitude'] as double,
      longitude: map['longitude'] as double,
    );
  }

  // String toJson() => json.encode(toMap());
  Map<String, Object?> toJson() => {
    HouseImageFields.id: id,
    HouseImageFields.imagePath: imagePath,
    HouseImageFields.residence: residence,
    HouseImageFields.brgy: brgy,
    HouseImageFields.sitio: sitio,
    HouseImageFields.latitude: latitude,
    HouseImageFields.longitude: longitude,
  };

  // factory HouseImage.fromJson(String source) => HouseImage.fromMap(json.decode(source) as Map<String, dynamic>);
  static HouseImage fromJson(Map<String, Object?> json) =>HouseImage(
    id: json[HouseImageFields.id] as int?,
    imagePath: json[HouseImageFields.imagePath] as String,
    residence: json[HouseImageFields.residence] as String,
    brgy: json[HouseImageFields.brgy] as String?,
    sitio: json[HouseImageFields.sitio] as String?,
    latitude: json[HouseImageFields.latitude] as double,
    longitude: json[HouseImageFields.longitude] as double,
  );

  @override
  String toString() {
    return 'HouseImage(id: $id, imagePath: $imagePath, residence: $residence, brgy: $brgy, sitio: $sitio, latitude: $latitude, longitude: $longitude)';
  }

  @override
  bool operator ==(covariant HouseImage other) {
    if (identical(this, other)) return true;
  
    return 
      other.id == id &&
      other.imagePath == imagePath &&
      other.residence == residence &&
      other.brgy == brgy &&
      other.sitio == sitio &&
      other.latitude == latitude &&
      other.longitude == longitude;
  }

  @override
  int get hashCode {
    return id.hashCode ^
      imagePath.hashCode ^
      residence.hashCode ^
      brgy.hashCode ^
      sitio.hashCode ^
      latitude.hashCode ^
      longitude.hashCode;
  }
}
