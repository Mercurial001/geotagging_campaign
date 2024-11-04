import 'package:flutter/material.dart';
import 'package:geotagging_campaign/occupation.dart';
import 'package:geotagging_campaign/occupation_database.dart';

class OccupationAddPage extends StatefulWidget {
  const OccupationAddPage({
    super.key
  });

  @override
  _OccupationAddPageState createState() => _OccupationAddPageState();
}

class _OccupationAddPageState extends State<OccupationAddPage> {
  @override
  void initState() {
    super.initState();
  }

  Future<void> createOccupation(occupation) async {
    await OccupationDatabase.objects.createOccupation(
      occupation
    );
  }

  @override
  Widget build(BuildContext addOccupationContext) {
    TextEditingController occupationFieldInput = TextEditingController();

    return Scaffold(
      appBar: AppBar(
        title: const Text("Add New Occupation"),
        backgroundColor: const Color.fromARGB(255, 10, 40, 40),
        foregroundColor: const Color.fromARGB(255, 220, 220, 220)
      ),
      body: Column(children: [
        SizedBox(
          width: 100.0,
          child: TextField(
            controller: occupationFieldInput,
          ),
        ),
        ElevatedButton(
          child: const Text("Create Occupation"),
          onPressed: () {
            final occupation = Occupation(
              id: null, 
              name: occupationFieldInput.text
            );
            OccupationDatabase.objects.createOccupation(occupation);
            Navigator.pop(addOccupationContext);
            
          },
        )
      ],),
    );
  }
}