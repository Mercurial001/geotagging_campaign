import 'package:flutter/material.dart';
import 'package:geotagging_campaign/barangay_database.dart';
import 'package:geotagging_campaign/barangay.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geotagging_campaign/sitio_database.dart';
import 'package:geotagging_campaign/sitios.dart';

class SitioAddPage extends StatefulWidget {
  const SitioAddPage({
    super.key
  });

  @override
  _SitioAddPageState createState() => _SitioAddPageState();
}

class _SitioAddPageState extends State<SitioAddPage> {
  List<Barangay> barangays = [];
  String? selectedBarangay;
  double? latitude;
  double? longitude;
  TextEditingController sitioNameInput = TextEditingController();
  TextEditingController sitioPopulationInput = TextEditingController();

  @override
  void initState() {
    super.initState();
    retrieveAllBarangaysFromDatabase();
    // Add a listener to sitioNameInput to update the UI when the text changes
    sitioNameInput.addListener(() {
      setState(() {}); // Trigger rebuild when text changes
    });
  }
  
  @override
  void dispose() {
    sitioNameInput.dispose(); // Clean up the controller when the widget is disposed
    super.dispose();
  }

  Future<void> retrieveCoordinates() async {
    bool servicesEnabled = await Geolocator.isLocationServiceEnabled();
    if (!servicesEnabled) {
      return Future.error('Location services are disabled');
    }

    LocationPermission permission = await Geolocator.checkPermission();

    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return Future.error(
        'Location permission are permanently denied'
      );
    }

    Position position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high
    );

    setState(() {
      latitude = position.latitude;
      longitude = position.longitude;
    });

    debugPrint('$latitude $longitude');
  }

  Future<void> retrieveAllBarangaysFromDatabase() async {
    final retrievedBarangaysFromDatabase = await BarangayDatabase.objects.readAllBarangays();

    setState(() {
      barangays = retrievedBarangaysFromDatabase.toList();
    });
  }

  @override
  Widget build(BuildContext sitioContext) {
  
    return Scaffold(
      appBar: AppBar(
        title: const Text("Add Sitio"),
        backgroundColor: const Color.fromARGB(255, 10, 40, 40),
        foregroundColor: const Color.fromARGB(255, 220, 220, 220),
      ),
      body: Center(
        child: Column(
          children: [
            TextField(
              controller: sitioNameInput,
            ),
            TextField(
              controller: sitioPopulationInput,
              keyboardType: const TextInputType.numberWithOptions(decimal: false),
              decoration: const InputDecoration(
                labelText: 'Sitio Population',
              ),
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
            if (latitude != null && longitude != null)
              Text('Latitude: $latitude, Longitude: $longitude'),
              const SizedBox(height: 20),
            ElevatedButton(
              onPressed: retrieveCoordinates,
              child: const Text("Get Current Location"),
            ),
            if (latitude != null && longitude != null && selectedBarangay != null && sitioNameInput.text.isNotEmpty)
              ElevatedButton(
                onPressed: () async {
                  final sitio = Sitio(
                    name: sitioNameInput.text,
                    population: int.tryParse(sitioPopulationInput.text) ?? 0,
                    brgy: selectedBarangay.toString(),
                    lat: latitude,
                    long: longitude,
                  );

                  await SitioDatabase.objects.createSitio(sitio);
                  Navigator.pop(sitioContext);
                }, 
                child: const Text("Create Sitio")
              )
          ],
        ),
      )
    );
  }
}
