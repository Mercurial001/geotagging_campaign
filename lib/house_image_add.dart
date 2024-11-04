import 'package:flutter/material.dart';
import 'package:geotagging_campaign/house_image.dart';
import 'package:geotagging_campaign/house_image_database.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:geotagging_campaign/barangay_database.dart';
import 'package:geotagging_campaign/barangay.dart';
import 'package:path_provider/path_provider.dart';
import 'package:geolocator/geolocator.dart';

class HouseImageAddPage extends StatefulWidget {
  const HouseImageAddPage({
    super.key
  });

  @override
  _HouseImageAddPage createState() => _HouseImageAddPage(); 
}

class _HouseImageAddPage extends State<HouseImageAddPage> {
  XFile? pickedImage;
  File? _image;
  List<Barangay> barangays = [];
  final _picker = ImagePicker();
  String? selectedBarangay;
  double? latitude;
  double? longitude;

  @override
  void initState() {
    super.initState();
    retrieveAllBarangays();
  }

  Future<void> retrieveAllBarangays() async {
    try {
      final retrievedBarangaysFromDatabase = await BarangayDatabase.objects.readAllBarangays();

      setState(() {
        barangays = retrievedBarangaysFromDatabase.toList();
      });
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('An error occured while retrieving barangays from database.'),
        ),
      );
    }
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
    final imagesDirectory = Directory('${directory.path}/houseImages');
    if (!await imagesDirectory.exists()) {
      await imagesDirectory.create(recursive: true);
    }
    final String permanentPath = '${imagesDirectory.path}/${DateTime.now().millisecondsSinceEpoch}.jpg';
    final File permanentImage = await File(tempPath).copy(permanentPath);
    setState(() {
      _image = permanentImage;
    });
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

  @override
  Widget build(BuildContext houseImageContext) {
    TextEditingController sitioInput = TextEditingController();
    TextEditingController residenceInput = TextEditingController();

    return Scaffold(
      appBar: AppBar(
        title: Row(
          children:[
          const Text("Add House Photo"),
            ElevatedButton(
              onPressed: () {
                _cameraImagePicker();
                getLocation();
              },  
              child: const Icon(Icons.camera),
            ),
          ]
        ),
        backgroundColor: const Color.fromARGB(255, 10, 40, 40),
        foregroundColor: const Color.fromARGB(255, 220, 220, 220),
      ),
      body: SingleChildScrollView(
        child: Column(
            children: [
              Container(
                alignment: Alignment.center,
                width: double.infinity,
                height: 300,
                color: Colors.grey[300],
                child: _image != null
                ? Image.file(_image!, fit: BoxFit.cover)
                : const Text('Image Block'),
              ),    
              DropdownButton<String>(
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
              SizedBox(
                  width: 300.0,
                  child: Padding(
                      padding: const EdgeInsets.all(10),
                      child:TextField(
                          controller: sitioInput,
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
                          controller: residenceInput,
                          decoration: const InputDecoration(
                              hintText: "Resident Name"
                          ),
                      ),
                  )
              ),
              ElevatedButton(
                onPressed: () async {
                  final houseImage = HouseImage(
                    imagePath: _image!.path, 
                    residence: residenceInput.text,
                    brgy: selectedBarangay,
                    sitio: sitioInput.text,
                    latitude: latitude!,
                    longitude: longitude!,
                  );
        
                  await HouseImageDatabase.objects.create(houseImage);
                  _moveImageToPermanentDirectory(pickedImage!.path);
                  setState(() {
                    ScaffoldMessenger.of(houseImageContext).showSnackBar(
                      const SnackBar(
                        content: Text('House Image Successfully Added!'),
                      ),
                    );
                  });
                },
                child: const Text("Add House Image")
              )
            ],
          ),
      )
    );
  }
}