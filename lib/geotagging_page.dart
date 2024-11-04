import 'package:flutter/material.dart';
import 'package:geotagging_campaign/barangay.dart';
import 'package:geotagging_campaign/barangay_database.dart';
import 'package:geotagging_campaign/individual_page.dart';
import 'package:image_picker/image_picker.dart';
import 'package:geolocator/geolocator.dart';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:geotagging_campaign/individual_database.dart';
import 'package:geotagging_campaign/individual.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;
// import 'package:intl/intl.dart';

class GeotaggingPage extends StatefulWidget {
    const GeotaggingPage({
        super.key
    });

    @override
    _GeotaggingPageState createState() => _GeotaggingPageState();
}

class _GeotaggingPageState extends State<GeotaggingPage> {
  TextEditingController controllerFirstNameField = TextEditingController();
  TextEditingController controllerMiddleNameField = TextEditingController();
  TextEditingController controllerLastNameField = TextEditingController();
  TextEditingController controllerSuffixField = TextEditingController();
  TextEditingController controllerSitioField = TextEditingController();
  TextEditingController controllerReligionField = TextEditingController();
  TextEditingController controllerOccupationField = TextEditingController();
  TextEditingController controllerEducationalField = TextEditingController();
  TextEditingController controllerMobileNoField = TextEditingController();
  TextEditingController controllerBirthdayField = TextEditingController();
  TextEditingController controllerChurchNameField = TextEditingController();
  // TextEditingController controllerLeaderField = TextEditingController();
  // TextEditingController controllerOOTField = TextEditingController();
  TextEditingController controllerFamilyRole = TextEditingController();

  List<Barangay> barangays = [];
  double? latitude;
  double? longitude;
  String? selectedBarangay;
  String? selectedGender;
  String? leaderStatus;
  String? ootStatus;
  File? _image;
  DateTime? timezoneNow;
  XFile? pickedImage;
  final _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    getCurrentTimezoneNow();
    retrieveAllBarangays();
  }

  Future<void> _selectDate(BuildContext context) async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (pickedDate != null) {
      setState(() {
        controllerBirthdayField.text = "${pickedDate.toLocal()}".split(' ')[0];
        debugPrint(controllerBirthdayField.text);
      });
    }
  }

  void getLocation() async {
    await Geolocator.checkPermission();
    await Geolocator.requestPermission();

    Position position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high
    );

    setState(() {
      latitude = position.latitude;
      longitude = position.longitude;
      // debugPrint('${latitude} ${longitude}');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Coordinates Obtained, $latitude, $longitude'),
        ),
      );
    });
  }

  void getCurrentTimezoneNow() {
    tz.initializeTimeZones(); // Initialize timezone database

    tz.setLocalLocation(tz.getLocation('Asia/Manila')); // Set desired timezone

    DateTime philippinesTime = tz.TZDateTime.now(tz.local);
    timezoneNow = philippinesTime;
    // print("Current time in New York: ${DateFormat('yyyy-MM-dd – kk:mm').format(nyTime)}");
  }

  Future<void> _cameraImagePicker() async {
    // final XFile? pickedImage = await _picker.pickImage(source: ImageSource.camera);
    pickedImage = await _picker.pickImage(source: ImageSource.camera);
    if (pickedImage != null) {
      debugPrint(_image?.path ?? "No image path available");
      setState(() {
        _image = File(pickedImage!.path);
      });
      // await _moveImageToPermanentDirectory(pickedImage.path);
    }
    debugPrint(_image!.path);
  }

  Future<void> _moveImageToPermanentDirectory(String tempPath) async {
    final directory = await getApplicationDocumentsDirectory();
    final imagesDirectory = Directory('${directory.path}/images');
    if (!await imagesDirectory.exists()) {
      await imagesDirectory.create(recursive: true);
    }
    final String permanentPath = '${imagesDirectory.path}/${DateTime.now().millisecondsSinceEpoch}.jpg';
    final File permanentImage = await File(tempPath).copy(permanentPath);
    setState(() {
      _image = permanentImage;
    });
  }

  Future<void> retrieveAllBarangays() async {
    try {
      final retrievedBarangayFromDatabase = await BarangayDatabase.objects.readAllBarangays();

      setState(() {
        barangays = retrievedBarangayFromDatabase.toList();
      });
    } catch (error) {
      debugPrint('Could not retrieve Barangays from Database');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            backgroundColor: const Color.fromARGB(255, 50, 50, 100),
            title: Row(children:[
              const Text("Geotagging Campaign"),
              ElevatedButton(
                onPressed: () {
                  _cameraImagePicker();
                  getLocation();
                },  
                child: const Icon(Icons.camera),
              ),
            ]),
            foregroundColor: const Color.fromARGB(255, 220, 220, 220),
        ),
        body: Center(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  SizedBox(
                      width: 300.0,
                      child: Padding(
                          padding: const EdgeInsets.all(10),
                          child:TextField(
                              controller: controllerFirstNameField,
                              decoration: const InputDecoration(
                                  hintText: "First Name"
                              ),
                          ),
                      )
                  ),
                  SizedBox(
                      width: 300.0,
                      child: Padding(
                          padding: const EdgeInsets.all(10),
                          child:TextField(
                              controller: controllerMiddleNameField,
                              decoration: const InputDecoration(
                                  hintText: "Middle Name"
                              ),
                          ),
                      )
                  ),
                  SizedBox(
                      width: 300.0,
                      child: Padding(
                          padding: const EdgeInsets.all(10),
                          child:TextField(
                              controller: controllerLastNameField,
                              decoration: const InputDecoration(
                                  hintText: "Last Name"
                              ),
                          ),
                      )
                  ),
                  DropdownButton<String>(
                    hint: const Text('Select Gender'),
                    value: selectedGender,
                    items: <String>['Male', 'Female'].map((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                    onChanged: (String? newValue) {
                      setState(() {
                        selectedGender = newValue;
                      });
                    },
                  ),
                  SizedBox(
                    width: 300.0,
                    child: Padding(
                      padding: const EdgeInsets.all(10),
                      child: TextField(
                        controller: controllerBirthdayField,
                        decoration: const InputDecoration(
                          labelText: "Select Date",
                          suffixIcon: Icon(Icons.calendar_today),
                        ),
                        readOnly: true,
                        onTap: () => _selectDate(context),
                      ),
                    )
                  ),
                  SizedBox(
                      width: 300.0,
                      child: Padding(
                          padding: const EdgeInsets.all(10),
                          child:TextField(
                              controller: controllerSuffixField,
                              decoration: const InputDecoration(
                                  hintText: "Suffix"
                              ),
                          ),
                      )
                  ),
                  SizedBox(
                    width:300.0, 
                    child: DropdownButton<String>(
                      value: selectedBarangay,
                      hint: const Text("Select Barangay"),
                      onChanged: (String? newValue) {
                        setState(() {
                          selectedBarangay = newValue;
                        });
                      },
                      items: barangays.map<DropdownMenuItem<String>>((Barangay barangay) {
                        return DropdownMenuItem<String>(
                          value: barangay.brgy_name,
                          child: Text(barangay.brgy_name),
                        );
                      }).toList(),
                    ),
                  ),
                  SizedBox(
                      width: 300.0,
                      child: Padding(
                          padding: const EdgeInsets.all(10),
                          child:TextField(
                              controller: controllerSitioField,
                              decoration: const InputDecoration(
                                  hintText: "Sitio"
                              ),
                          ),
                      )
                  ),
                  SizedBox(
                      width: 300.0,
                      child: Padding(
                          padding: const EdgeInsets.all(10),
                          child:TextField(
                              controller: controllerReligionField,
                              decoration: const InputDecoration(
                                  hintText: "Religion"
                              ),
                          ),
                      )
                  ),
                  SizedBox(
                      width: 300.0,
                      child: Padding(
                          padding: const EdgeInsets.all(10),
                          child:TextField(
                              controller: controllerChurchNameField,
                              decoration: const InputDecoration(
                                  hintText: "Church Name"
                              ),
                          ),
                      )
                  ),
                  SizedBox(
                      width: 300.0,
                      child: Padding(
                          padding: const EdgeInsets.all(10),
                          child:TextField(
                              controller: controllerOccupationField,
                              decoration: const InputDecoration(
                                  hintText: "Occupation"
                              ),
                          ),
                      )
                  ),
                  SizedBox(
                      width: 300.0,
                      child: Padding(
                          padding: const EdgeInsets.all(10),
                          child:TextField(
                              controller: controllerEducationalField,
                              decoration: const InputDecoration(
                                  hintText: "Educational Attainment"
                              ),
                          ),
                      )
                  ),
                  SizedBox(
                    width: 300.0,
                    child: Padding(
                        padding: const EdgeInsets.all(10),
                        child:TextField(
                            controller: controllerFamilyRole,
                            decoration: const InputDecoration(
                                hintText: "Family Role"
                            ),
                        ),
                    )
                  ),
                  SizedBox(
                    width: 300.0,
                    child: Padding(
                      padding: const EdgeInsets.all(10),
                      child:TextField(
                        controller: controllerMobileNoField,
                        keyboardType: const TextInputType.numberWithOptions(decimal: false),
                        decoration: const InputDecoration(
                          labelText: 'Mobile Number',
                        ),
                      ),
                    )
                  ),
                  DropdownButton<String>(
                    hint: const Text('Leader Status'),
                    value: leaderStatus,
                    items: <String>['Yes', 'No'].map((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                    onChanged: (String? newValue) {
                      setState(() {
                        leaderStatus = newValue;
                      });
                    },
                  ),
                  DropdownButton<String>(
                    hint: const Text('Out-of-Town (OOT)'),
                    value: ootStatus,
                    items: <String>['Yes', 'No'].map((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                    onChanged: (String? newValue) {
                      setState(() {
                        ootStatus = newValue;
                      });
                    },
                  ),
                  if (latitude != null && longitude != null)
                    Text('Latitude: $latitude, Longitude: $longitude'),
                    const SizedBox(height: 20),
                  Container(
                    alignment: Alignment.center,
                    width: double.infinity,
                    height: 300,
                    color: Colors.grey[300],
                    child: _image != null
                    ? Image.file(_image!, fit: BoxFit.cover)
                    : const Text('Image Block'),
                  ),    
                  ElevatedButton(
                    onPressed: () async {
                      // String birthdayString = controllerBirthdayField.text; // Already in 'yyyy-MM-dd' format
                      // String surveyDateString = timezoneNow!.toIso8601String();
                      final individual = Individual(
                        id: null,
                        firstname: controllerFirstNameField.text, 
                        middlename: controllerMiddleNameField.text, 
                        lastname: controllerLastNameField.text,
                        suffix: controllerSuffixField.text, 
                        gender: selectedGender.toString(), 
                        brgy: selectedBarangay.toString(), 
                        sitio: controllerSitioField.text,
                        image: _image!.path,
                        religion: controllerReligionField.text, 
                        occupation: controllerOccupationField.text, 
                        mobileNumber: controllerMobileNoField.text, 
                        latitude: latitude,
                        longitude: longitude,
                        birthday: DateTime.tryParse(controllerBirthdayField.text) ?? DateTime.now(),
                        isLeader: leaderStatus!, 
                        isOOT: ootStatus!, 
                        familyRole: controllerFamilyRole.text, 
                        surveyDate: timezoneNow!,
                      );
                      // if (_image == null) {
                      //   ScaffoldMessenger.of(context).showSnackBar(
                      //     const SnackBar(content: Text("Please pick an image before proceeding.")),
                      //   ); // Exit the function if no image is selected
                      // } else if (timezoneNow == null) {
                      //   getCurrentTimezoneNow();
                      // }
                      await IndividualDatabase.objects.createIndividual(individual);
                      _moveImageToPermanentDirectory(pickedImage!.path);
                      setState(() {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Individual Successfully Created!'),
                          ),
                        );
                      });
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => const IndividualPage()
                        )
                      );
                    },
                    child: const Text("Add Individual")
                  )
                ],
              ),
            ),
        )
    );
  }
}
