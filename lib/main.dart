import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:geotagging_campaign/geotagging_page.dart';
import 'package:geotagging_campaign/religion_page.dart';
import 'package:geotagging_campaign/barangay_page.dart';
import 'package:geotagging_campaign/occupation_page.dart';
import 'package:geotagging_campaign/sitio_page.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geotagging_campaign/individual_page.dart';
import 'package:geotagging_campaign/house_images_page.dart';
import 'dart:io';
import 'package:device_info_plus/device_info_plus.dart';
import 'device.dart';
import 'device_database.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Geolocator.isLocationServiceEnabled(); // Test initialization
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color.fromARGB(255, 15, 96, 104)),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class BlockedScreen extends StatelessWidget {
  const BlockedScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Text('This device is blocked. Please contact support.'),
      ),
    );
  }
}


class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  Future<bool> checkInternetConnection() async {
    try {
      final result = await InternetAddress.lookup('agvinture.pythonanywhere.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        return true;
      }
    } on SocketException catch (_) {
      return false;
    }
    return false;
  }

  Future<void> getDeviceDetails() async {
    DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();

    try {
      if (Platform.isAndroid) {
        AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
        final device = Device(
          name: androidInfo.model,
          uuid: androidInfo.id,
        );
        await DeviceDatabase.instance.createOrUpdate(device);
      } else if (Platform.isIOS) {
        IosDeviceInfo iosInfo = await deviceInfo.iosInfo;
        final device = Device(
          name: iosInfo.utsname.machine,
          uuid: iosInfo.identifierForVendor ?? "Unknown UUID",
        );
        await DeviceDatabase.instance.createOrUpdate(device);
      } else {
        throw UnsupportedError("Unsupported platform");
      }
    } catch (e) {
      debugPrint("Error retrieving device details: $e");
    }
  }

  Future<void> registerDevice() async {
    DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
    AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
    final url = Uri.parse('$mainUrl/register-device/');

    final device = await DeviceDatabase.instance.get(
      name: androidInfo.model,
      uuid: androidInfo.id
    );

    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
      },
      body: json.encode(device.toJson()),
    );

    if (response.statusCode == 201) {
      print('Device registered successfully');
    } else if (response.statusCode == 200) {
      // Update device status from the response
      final responseData = json.decode(response.body);
      device.isBlocked = responseData['is_blocked'] ?? false;
      print('Device already registered');
    } else {
      throw Exception('Failed to register device: ${response.body}');
    }
  }

  Future<void> registerDeviceOnStart() async {
    try {
      // Check for internet connection
      bool isConnected = await checkInternetConnection();

      if (!isConnected) {
        print('No internet connection. Device registration skipped.');
        // Optionally, notify the user about the lack of internet connection
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Running Offline. Device Validation Skipped.'),
          ),
        );
        return; // Exit the function if no internet connection
      }

      // Proceed with device registration if there is an internet connection
      // final device = await getDeviceDetails();
      // // await registerDevice(device);
    } catch (e) {
      debugPrint('Failed to register device: $e');
      // Handle the exception and update the state accordingly
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to register device: $e'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text("Geotagging Campaign"),
      ),
      drawer:  Drawer(
        backgroundColor: const Color.fromARGB(220, 66, 223, 237),
        child: ListView(
          children: [
            ListTile(
              title: const Text("Religion"),
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => const ReligionPage()
                  )
                );
              },
            ),
            ListTile(
              title: const Text("Barangays"),
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => const BarangayPage())
                );
              },
            ),
            ListTile(
              title: const Text("Sitios"),
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => const SitioPage())
                );
              },
            ),
            ListTile(
              title: const Text("Occupation"),
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => const OccupationPage())
                );
              },
            ),
            ListTile(
              title: const Text("Individuals"),
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => const IndividualPage())
                );
              },
            ),
            ListTile(
              title: const Text("House Images"),
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => const HouseImagesPage()
                  )
                );
              },
            )
          ],
        )
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            Navigator.of(context).push(
              MaterialPageRoute(builder: (context) => const GeotaggingPage())
            );
          }, 
          child: const Text('Start Geotagging'))
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
