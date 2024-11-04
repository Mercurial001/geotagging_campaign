import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:geotagging_campaign/barangay.dart';
import 'package:geotagging_campaign/barangay_database.dart';
import 'dart:convert';

String mainUrl = 'https://genesisa.pythonanywhere.com/api/brgys-all/';

class BarangayPage extends StatefulWidget{
  const BarangayPage({
    super.key
  });

  @override
  _BarangayPageState createState() => _BarangayPageState();
}

class _BarangayPageState extends State<BarangayPage> {
  var client = http.Client();
  List<Barangay> barangaysFromAPIList = [];
  List<Barangay> barangayFromDatabase = [];

  @override
  void initState() {
    super.initState();
    // _retrieveBaragays();
    retrieveBarangaysFromDatabase();
    // deleteAllBarangayObjects();
  }

  _retrieveBaragays() async {
    try {
      List responseFromAPI = json.decode(
        (await client.get(Uri.parse(mainUrl))).body
      );

      // responseFromAPI.forEach((object) async {
      //   barangaysFromAPIList.add(Barangay.fromJson(object));
      // });

      for (var object in responseFromAPI) {
        barangaysFromAPIList.add(Barangay.fromJson(object));

        final barangay = Barangay(
          id: null,
          brgy_name: object['brgy_name'],
          brgy_voter_population: object['brgy_voter_population'] ?? null,
          lat: object['lat'] ?? null,
          long: object['long'] ?? null
        );
        debugPrint(object['brgy_name']);
        await BarangayDatabase.objects.createBarangay(barangay);
      }

      setState(() {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('${barangaysFromAPIList.length} Successfully Retrieved'),
          ),
        );
      });
    } catch (error) {
      setState(() {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('An error has occured during retrieval of barangays $error'),
          ),
        );
      });
    }

    barangaysFromAPIList = [];


  }

  Future<void> retrieveBarangaysFromDatabase() async {
    try{
      List<Barangay> retrievedBarangaysFromDatabase = await BarangayDatabase.objects.readAllBarangays();

      setState(() {
        barangayFromDatabase = retrievedBarangaysFromDatabase.toList();
        debugPrint("Barangays From Database");

      });
    } catch (error) {
      debugPrint(" ERROR FETCHING BARANGAYS FROM DATABASE $error");
    }
  }

  // Future<void> deleteAllBarangayObjects() async {
  //   await BarangayDatabase.objects.deleteAllBarangayObjects();
  // }

  @override
  Widget build(BuildContext barangayContext) {
    return Scaffold(
      appBar: AppBar(
        title: Row(children: [
          const Text("Baragays"),
          if (barangayFromDatabase.isEmpty)
            ElevatedButton(
              onPressed: () {
                _retrieveBaragays();
              }, 
              child: const Text("Retrieve Barangays")
            ),
        ]),
        foregroundColor: const Color.fromARGB(255, 220, 220, 220),
        backgroundColor: const Color.fromARGB(255, 10, 40, 40),
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          retrieveBarangaysFromDatabase();
        },
        child: ListView.builder(
          itemCount: barangayFromDatabase.length,
          itemBuilder: (BuildContext barangayContext, int index) {
            return ListTile(
              title: Text(barangayFromDatabase[index].brgy_name),
              onTap: () {

              },
            );
          },
        )
        // child: ListView.builder( 
        //   itemCount: barangaysFromAPIList.length,
        //   itemBuilder: (BuildContext barangayContext, int index) {
        //     return ListTile(
        //       title: Text('${barangaysFromAPIList[index].brgy_name} '),
        //     );
        //   }
        // ),
      )
    );
  }
}