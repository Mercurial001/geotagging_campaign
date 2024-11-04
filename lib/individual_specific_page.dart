import 'package:flutter/material.dart';
// import 'package:geotagging_campaign/individual.dart';
// import 'package:geotagging_campaign/individual_database.dart';

// import 'package:flutter/material.dart';
// import 'package:geotagging_campaign/barangay.dart';
// import 'package:geotagging_campaign/barangay_database.dart';
// import 'package:image_picker/image_picker.dart';
// import 'package:geolocator/geolocator.dart';
import 'dart:io';
import 'package:geotagging_campaign/select_house_image.dart';
// import 'package:path_provider/path_provider.dart';
// import 'package:geotagging_campaign/individual_database.dart';
// import 'package:geotagging_campaign/individual.dart';
// import 'package:timezone/data/latest.dart' as tz;
// import 'package:timezone/timezone.dart' as tz;

class IndividualSpecificPage extends StatefulWidget {
  final int id;
  final String firstname;
  final String middlename;
  final String lastname;
  final String? suffix;
  final String gender;
  final String brgy;
  final String? sitio;
  final String image;
  final String? houseImage;
  final String? religion;
  final String? churchName;
  final String? educationalAttainment;
  final String? occupation;
  final String? mobileNumber;
  final double? latitude;
  final double? longitude;
  final DateTime birthday;
  final String? isLeader;
  final String? isOOT;
  final String? familyRole;

  const IndividualSpecificPage({
    super.key,
    required this.id,
    required this.firstname,
    required this.middlename,
    required this.lastname,
    this.suffix,
    required this.gender,
    required this.brgy,
    this.sitio,
    required this.image,
    required this.houseImage,
    this.religion,
    this.churchName,
    this.educationalAttainment,
    this.occupation,
    this.mobileNumber,
    this.latitude,
    this.longitude,
    required this.birthday,
    this.familyRole,
    this.isLeader,
    this.isOOT
  });

  @override
  _IndividualSpecificPageState createState() => _IndividualSpecificPageState();
}

class _IndividualSpecificPageState extends State<IndividualSpecificPage> {
  Key pageKey = UniqueKey();
  @override
  void initState() {
    super.initState();
  }

  String toTitleCase(String text) {
    if (text.isEmpty) return text;
    return text.split(' ').map((word) => word[0].toUpperCase() + word.substring(1).toLowerCase()).join(' ');
  }

  void _reloadPage() {
    setState(() {
      pageKey = UniqueKey(); // Changing the key forces a complete reload of the page.
    });
  }


  @override
  Widget build(BuildContext individualContext) {
    return Scaffold(
      appBar: AppBar(
        title: Row(children: [
          const Text("Individual Details"),
          ElevatedButton(
              onPressed: _reloadPage, 
              child: const Text("Reload Page")
            )
          ]
        ),
        backgroundColor: const Color.fromARGB(255, 10, 40, 40),
        foregroundColor: const Color.fromARGB(255, 220, 220, 220),
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          
        },
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (widget.image.isNotEmpty)
                Image.file(
                  File(widget.image),
                  width: double.infinity,
                  height: 300,
                  fit: BoxFit.cover,
                )
              else
                const Text('No image available'),
              Text(
                'Name: ${toTitleCase(widget.firstname)} ${toTitleCase(widget.middlename)} ${toTitleCase(widget.lastname)} ${widget.suffix}',
                style: const TextStyle(
                  fontSize: 18,
                ),
              ),
              Text(
                'Barangay: ${toTitleCase(widget.brgy)}',
                style: const TextStyle(
                  fontSize: 18,
                ),
              ),
              Text(
                'Sitio ${toTitleCase(widget.sitio!)}',
                style: const TextStyle(
                  fontSize: 18,
                ),
              ),
              if (widget.religion!.isEmpty)
                const Text(
                  "Religion: None",
                  style: const TextStyle(
                    fontSize: 18,
                  ),
                )
              else
                Text(
                  'Religion: ${widget.religion ?? "None"}',
                  style: const TextStyle(
                    fontSize: 18,
                  ),
                ),
              Text(
                'Church Name: ${widget.churchName ?? "None"}',
                style: const TextStyle(
                  fontSize: 18,
                ),
              ),
              Text(
                'Educational Attainment: ${widget.educationalAttainment ?? "None"}',
                style: const TextStyle(
                  fontSize: 18,
                ),
              ),
              if (widget.occupation!.isNotEmpty)
                Text(
                  'Occupation: ${widget.occupation ?? "None"}',
                  style: const TextStyle(
                    fontSize: 18,
                  ),
                )
              else
                const Text(
                  "Occupation: None",
                  style: TextStyle(
                    fontSize: 18,
                  ),
                ),
              if (widget.mobileNumber!.isNotEmpty)
                Text(
                  'Mobile Number: ${widget.mobileNumber ?? "None"}',
                  style: const TextStyle(
                    fontSize: 18,
                  ),
                )
              else
                const Text(
                  "Mobile Number: None",
                  style: TextStyle(
                    fontSize: 18,
                  ),
                ),
              Text(
                'Birthday: ${widget.birthday}',
                style: const TextStyle(
                  fontSize: 18,
                ),
              ),
              if (widget.familyRole!.isNotEmpty)
                Text(
                  'Family Role: ${widget.familyRole}',
                  style: const TextStyle(
                    fontSize: 18,
                  ),
                )
              else
                const Text(
                  "Family Role: Not Specified",
                  style: TextStyle(
                    fontSize: 18,
                  ),
                ),
              Text(
                'Is Leader? ${widget.isLeader}',
                style: const TextStyle(
                  fontSize: 18,
                ),
              ),
              Text(
                'Is Out-of-Town (OOT): ${widget.isOOT}',
                style: const TextStyle(
                  fontSize: 18,
                ),
              ),
              Text("${widget.latitude} ${widget.longitude}"),
              if (widget.houseImage == null)
                ElevatedButton(
                  onPressed: () {
                    Navigator.of(individualContext).push(
                      MaterialPageRoute(
                        builder: (individualContext) => SelectHouseImagePage(
                          id: widget.id,
                        )
                      )
                    );
                  },
                  child: const Text("Add House Image"))
              else
                Image?.file(
                  File(widget.houseImage!),
                  width: double.infinity,
                  height: 300,
                  fit: BoxFit.cover,
                ),
            ],
          ),
        ),
      )
    );
  }
}