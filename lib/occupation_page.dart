import 'package:geotagging_campaign/occupation.dart';
import 'package:flutter/material.dart';
import 'package:geotagging_campaign/occupation_add.dart';
import 'package:geotagging_campaign/occupation_database.dart';

class OccupationPage extends StatefulWidget {
  const OccupationPage({
    super.key
  });

  @override
  _OccupationPageState createState() => _OccupationPageState();
}


class _OccupationPageState extends State<OccupationPage> {
  @override
  void initState() {
    super.initState();
    retrieveOccupationFromDatabase();
  }

  List<Occupation> occupationList = [];

  Future<void> retrieveOccupationFromDatabase() async {
    try {
      final retrievedOccupationsFromDatabase = await OccupationDatabase.objects.readAllOccupation();
      
      setState(() {
        occupationList = retrievedOccupationsFromDatabase.toList();  
      });
    } catch (error) {
      debugPrint("Error retrievig the occupations from database. $error");
    }

  }

  @override
  Widget build(BuildContext occupationContext) {
    return Scaffold(
      appBar:  AppBar(
        title: Row(
          children: [
            const Text("Occupation"),
            ElevatedButton(
              onPressed: () {
                Navigator.of(occupationContext).push(
                  MaterialPageRoute(builder: (occupationContext) => const OccupationAddPage())
                );
              },
              child: const Text("Add Occupation"))
          ],
        ),
        backgroundColor: const Color.fromARGB(255, 10, 40, 40),
        foregroundColor: const Color.fromARGB(255, 220, 220, 220),
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          retrieveOccupationFromDatabase();
        },
        child: ListView.builder(
          itemCount: occupationList.length,
          itemBuilder: (BuildContext occupationContext, int index) {
            return ListTile(
              title: Text(occupationList[index].name),
              onTap: () {

              },
            );
          }
        ),
      ),
      // body: RefreshIndicator(
      //   onRefresh: () {
          
      //   },
      //   child: ListView.builder(
      //     itemBuilder: 
      //   ),
      // )
    );
  }
}
