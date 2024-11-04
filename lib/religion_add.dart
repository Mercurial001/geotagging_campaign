import 'package:flutter/material.dart';
import 'package:geotagging_campaign/religion.dart';
import 'package:geotagging_campaign/religion_database.dart';

class ReligionAddPage extends StatefulWidget {
  const ReligionAddPage({
    super.key
  });

  @override
  _ReligionAddPageState createState() => _ReligionAddPageState();
}

class _ReligionAddPageState extends State<ReligionAddPage> {
  @override
  void initState() {
    super.initState();

  }



  @override 
  Widget build(BuildContext addReligionContext) {
    TextEditingController addNewReligionInputField = TextEditingController();
    return Scaffold(
      appBar: AppBar(
        title: const Text("Add New Religion"),
        backgroundColor: const Color.fromARGB(255, 10, 40, 40),
        foregroundColor: const Color.fromARGB(255, 220, 220, 220),
      ),
      body: Column(
        children: [
          TextField(
            controller: addNewReligionInputField
          ),
          ElevatedButton(
            onPressed: () {
              final newReligion = Religion(
                name: addNewReligionInputField.text,
                id: null,
              ); 
              ReligionDatabase.instance.createReligion(newReligion);
              Navigator.pop(addReligionContext);
            },
            child: const Text('Add New Religion'))
        ],
      ),
    );
  }
}