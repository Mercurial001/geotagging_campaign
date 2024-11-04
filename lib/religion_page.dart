import 'package:flutter/material.dart';
import 'package:geotagging_campaign/religion.dart';
import 'package:geotagging_campaign/religion_database.dart';
import 'package:geotagging_campaign/religion_add.dart';

class ReligionPage extends StatefulWidget {
  const ReligionPage({
    super.key
  });

  @override
  _ReligionPageState createState() => _ReligionPageState();
}

class _ReligionPageState extends State<ReligionPage> {

  @override
  void initState() {
    super.initState();
    retrieveReligions();
  }

  List<Religion> religions = [];

  Future<void> retrieveReligions() async {
    try {
      List<Religion> retrivedReligions = await ReligionDatabase.instance.readAllReligion();

      setState( () {
        religions = retrivedReligions.toList();
        debugPrint('Religion Retrieved');
      });
    } catch (error) {
      debugPrint('Cannot retrieve religion from database');
    }
  }

  Future<void> deleteReligion(int id) async{
    await ReligionDatabase.instance.deleteReligion(id);
    retrieveReligions();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(children: [
          const Text('Religions'),
            Container(
              margin: const EdgeInsets.fromLTRB(110, 0, 0, 0),
              child: 
                ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(builder: (context) => const ReligionAddPage())
                    );
                  }, 
                  child: const Text('Add Religion')
                )
            ),
        ],),
        backgroundColor: const Color.fromARGB(255, 10, 40, 40),
        foregroundColor: const Color.fromARGB(255, 220, 220, 220),

      ),
      body: RefreshIndicator(
        onRefresh: () async {
          retrieveReligions();
        },
        child: ListView.builder(
          itemCount: religions.length,
          itemBuilder: (BuildContext context, int index) {
            return ListTile(
              title: Text( religions[index].name),
              trailing: IconButton(
                icon: const Icon(Icons.delete),
                onPressed: () {
                  deleteReligion(religions[index].id!);
                },
              ),
            );
          }
          
        ),
      )
    );
  }
}