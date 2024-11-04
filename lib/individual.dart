const String individualTable = 'individual';

class IndividualFields {
  static final List<String> values = [
    id, firstname, middlename, lastname, suffix, gender, brgy, sitio,
    image, houseImage, religion, occupation, mobileNumber, latitude, longitude,
    birthday, isLeader, isOOT, familyRole, surveyDate, educationalAttainment,
    churchName
  ];

  static const String id = '_id';
  static const String firstname = '_firstname';
  static const String middlename = '_middlename';
  static const String lastname = '_lastname';
  static const String suffix = '_suffix';
  static const String gender = '_gender';
  static const String brgy = '_brgy';
  static const String sitio = '_sitio';
  static const String image = '_image';
  static const String houseImage = '_houseImage';
  static const String religion = '_religion';
  static const String churchName = '_churchName';
  static const String educationalAttainment = '_educationalAttainment'; 
  static const String occupation = '_occupation';
  static const String mobileNumber = '_mobileNumber';
  static const String latitude = '_latitude';
  static const String longitude = '_longitude';
  static const String birthday = '_birthday';
  static const String isLeader = '_isLeader';
  static const String isOOT = '_OOT';
  static const String familyRole = '_familyRole';
  static const String surveyDate = '_surveyDate';
}

class Individual {
  int? id;
  String firstname;
  String middlename;
  String lastname;
  String? suffix;
  String gender;
  String brgy;
  String sitio;
  String? image;
  String? houseImage;
  String? religion;
  String? churchName;
  String? educationalAttainment;
  String? occupation;
  String? mobileNumber;
  double? latitude;
  double? longitude;
  DateTime birthday;
  String isLeader;
  String isOOT;
  String familyRole;
  DateTime surveyDate;
  Individual({
    this.id,
    required this.firstname,
    required this.middlename,
    required this.lastname,
    this.suffix,
    required this.gender,
    required this.brgy,
    required this.sitio,
    this.image,
    this.houseImage,
    required this.religion,
    this.churchName,
    this.educationalAttainment,
    required this.occupation,
    required this.mobileNumber,
    this.latitude,
    this.longitude,
    required this.birthday,
    required this.isLeader,
    required this.isOOT,
    required this.familyRole,
    required this.surveyDate,
  });

  Individual copyWith({
    int? id,
    String? firstname,
    String? middlename,
    String? lastname,
    String? suffix,
    String? gender,
    String? brgy,
    String? sitio,
    String? image,
    String? houseImage,
    String? religion,
    String? churchName,
    String? educationalAttainment,
    String? occupation,
    String? mobileNumber,
    double? latitude,
    double? longitude,
    DateTime? birthday,
    String? isLeader,
    String? isOOT,
    String? familyRole,
    DateTime? surveyDate,
  }) {
    return Individual(
      id: id ?? this.id,
      firstname: firstname ?? this.firstname,
      middlename: middlename ?? this.middlename,
      lastname: lastname ?? this.lastname,
      suffix: suffix ?? this.suffix,
      gender: gender ?? this.gender,
      brgy: brgy ?? this.brgy,
      sitio: sitio ?? this.sitio,
      image: image ?? this.image,
      houseImage: houseImage ?? this.houseImage,
      religion: religion ?? this.religion,
      churchName: churchName ?? this.churchName,
      educationalAttainment: educationalAttainment ?? this.educationalAttainment,
      occupation: occupation ?? this.occupation,
      mobileNumber: mobileNumber ?? this.mobileNumber,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      birthday: birthday ?? this.birthday,
      isLeader: isLeader ?? this.isLeader,
      isOOT: isOOT ?? this.isOOT,
      familyRole: familyRole ?? this.familyRole,
      surveyDate: surveyDate ?? this.surveyDate,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'firstname': firstname,
      'middlename': middlename,
      'lastname': lastname,
      'suffix': suffix,
      'gender': gender,
      'brgy': brgy,
      'sitio': sitio,
      'image': image,
      'houseImage': houseImage,
      'religion': religion,
      'churchName': churchName,
      'educationalAttainment': educationalAttainment,
      'occupation': occupation,
      'mobileNumber': mobileNumber,
      'latitude': latitude,
      'longitude': longitude,
      'birthday': birthday.toIso8601String(), // Updated Line
      'isLeader': isLeader,
      'isOOT': isOOT,
      'familyRole': familyRole,
      'surveyDate': surveyDate.toIso8601String(), // Updated Line
    };
  }

  factory Individual.fromMap(Map<String, dynamic> map) {
    return Individual(
      id: map['id'] != null ? map['id'] as int : null,
      firstname: map['firstname'] as String,
      middlename: map['middlename'] as String,
      lastname: map['lastname'] as String,
      suffix: map['suffix'] != null ? map['suffix'] as String : null,
      gender: map['gender'] as String,
      brgy: map['brgy'] as String,
      sitio: map['sitio'] as String,
      image: map['image'] != null ? map['image'] as String : null,
      houseImage: map['houseImage'] != null ? map['houseImage'] as String : null,
      religion: map['religion'] != null ? map['religion'] as String : null,
      churchName: map['churchName'] != null ? map['churchName'] as String : null,
      educationalAttainment: map['educationalAttainment'] != null ? map['educationalAttainment'] as String : null,
      occupation: map['occupation'] != null ? map['occupation' ]as String: null,
      mobileNumber: map['mobileNumber'] !=null ? map['mobileNumber'] as String : null ,
      latitude: map['latitude'] != null ? map['latitude'] as double : null,
      longitude: map['longitude'] != null ? map['longitude'] as double : null,
      birthday: DateTime.parse(map['birthday'] as String), // Updated Line
      isLeader: map['isLeader'] as String,
      isOOT: map['isOOT'] as String,
      familyRole: map['familyRole'] as String,
      surveyDate: DateTime.parse(map['surveyDate']), // Updated Line
    );
  }

  // String toJson() => json.encode(toMap());
  Map<String, dynamic> toJson() => {
    IndividualFields.id: id,
    IndividualFields.firstname: firstname,
    IndividualFields.middlename: middlename,
    IndividualFields.lastname: lastname,
    IndividualFields.suffix: suffix,
    IndividualFields.gender: gender,
    IndividualFields.brgy: brgy,
    IndividualFields.sitio: sitio,
    IndividualFields.image: image,
    IndividualFields.houseImage: houseImage,
    IndividualFields.religion: religion,
    IndividualFields.churchName: churchName,
    IndividualFields.educationalAttainment: educationalAttainment,
    IndividualFields.occupation: occupation,
    IndividualFields.mobileNumber: mobileNumber,
    IndividualFields.latitude: latitude,
    IndividualFields.longitude: longitude,
    IndividualFields.birthday: birthday.toIso8601String(),
    IndividualFields.isLeader: isLeader,
    IndividualFields.isOOT: isOOT,
    IndividualFields.familyRole: familyRole,
    IndividualFields.surveyDate: surveyDate.toIso8601String(),
  };

  // factory Individual.fromJson(String source) => Individual.fromMap(json.decode(source) as Map<String, dynamic>);
  static Individual fromJson(Map<String, Object?> json) => Individual(
    id: json[IndividualFields.id] as int?,
    firstname: json[IndividualFields.firstname] as String,
    middlename: json[IndividualFields.middlename] as String, 
    lastname: json[IndividualFields.lastname] as String,
    suffix: json[IndividualFields.suffix] as String?,
    gender: json[IndividualFields.gender] as String, 
    brgy: json[IndividualFields.brgy] as String, 
    sitio: json[IndividualFields.sitio] as String, 
    image: json[IndividualFields.image] as String?,
    houseImage: json[IndividualFields.houseImage] as String?,
    religion: json[IndividualFields.religion] as String?, 
    churchName: json[IndividualFields.churchName] as String?,
    educationalAttainment: json[IndividualFields.educationalAttainment] as String?,
    occupation: json[IndividualFields.occupation] as String?, 
    mobileNumber: json[IndividualFields.mobileNumber] as String?, 
    latitude: json[IndividualFields.latitude] as double?,
    longitude: json[IndividualFields.longitude] as double?,
    birthday: DateTime.parse(json[IndividualFields.birthday] as String), // DateTime
    isLeader: json[IndividualFields.isLeader] as String, 
    isOOT: json[IndividualFields.isOOT] as String, 
    familyRole: json[IndividualFields.familyRole] as String, 
    surveyDate: DateTime.parse(json[IndividualFields.surveyDate] as String), // Datetime
  );

  @override
  String toString() {
    return 'Individual(id: $id, firstname: $firstname, middlename: $middlename, lastname: $lastname, suffix: $suffix, gender: $gender, brgy: $brgy, sitio: $sitio, image: $image, houseImage: $houseImage, religion: $religion, churchName: $churchName, educationalAttainment: $educationalAttainment, occupation: $occupation, mobileNumber: $mobileNumber, latitude: $latitude, longitude: $longitude, birthday: $birthday, isLeader: $isLeader, isOOT: $isOOT, familyRole: $familyRole, surveyDate: $surveyDate)';
  }

  @override
  bool operator ==(covariant Individual other) {
    if (identical(this, other)) return true;
  
    return 
      other.id == id &&
      other.firstname == firstname &&
      other.middlename == middlename &&
      other.lastname == lastname &&
      other.suffix == suffix &&
      other.gender == gender &&
      other.brgy == brgy &&
      other.sitio == sitio &&
      other.image == image &&
      other.houseImage == houseImage &&
      other.religion == religion &&
      other.churchName == churchName &&
      other.educationalAttainment == educationalAttainment &&
      other.occupation == occupation &&
      other.mobileNumber == mobileNumber &&
      other.latitude == latitude &&
      other.longitude == longitude &&
      other.birthday == birthday &&
      other.isLeader == isLeader &&
      other.isOOT == isOOT &&
      other.familyRole == familyRole &&
      other.surveyDate == surveyDate;
  }

  @override
  int get hashCode {
    return id.hashCode ^
      firstname.hashCode ^
      middlename.hashCode ^
      lastname.hashCode ^
      suffix.hashCode ^
      gender.hashCode ^
      brgy.hashCode ^
      sitio.hashCode ^
      image.hashCode ^
      houseImage.hashCode ^
      religion.hashCode ^
      churchName.hashCode ^
      educationalAttainment.hashCode ^
      occupation.hashCode ^
      mobileNumber.hashCode ^
      latitude.hashCode ^
      longitude.hashCode ^
      birthday.hashCode ^
      isLeader.hashCode ^
      isOOT.hashCode ^
      familyRole.hashCode ^
      surveyDate.hashCode;
  }
}
