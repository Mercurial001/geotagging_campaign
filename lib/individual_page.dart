import 'package:flutter/material.dart';
import 'package:geotagging_campaign/individual.dart';
import 'package:geotagging_campaign/individual_database.dart';
import 'package:geotagging_campaign/individual_specific_page.dart';

class IndividualPage extends StatefulWidget {
  const IndividualPage({
    super.key
  });

  @override
  _IndividualPageState createState()=> _IndividualPageState();
}

class _IndividualPageState extends State<IndividualPage> {
  List<Individual> individuals = [];

  @override
  void initState() {
    super.initState();
    retrieveIndividualsFromDatabase();
  }

  Future<void> retrieveIndividualsFromDatabase() async {
    try {
      final retrievedIndividualsFromDatabase = await IndividualDatabase.objects.all();

      setState(() {
        individuals = retrievedIndividualsFromDatabase.toList();
      });
    } catch (error) {
      debugPrint("An error has occured: $error");
    }
  }

  @override
  Widget build(BuildContext individualPageContext) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Individual Page"),
        backgroundColor: const Color.fromARGB(255, 10, 40, 40),
        foregroundColor: const Color.fromARGB(255, 220, 220, 220),
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          await retrieveIndividualsFromDatabase();
        },
        child: Column(
          children: [
            Expanded(
              child: ListView.builder(
                itemCount: individuals.length,
                itemBuilder: (BuildContext individualPageContext, int index) {
                  return ListTile(
                    title: Text('${individuals[index].firstname} ${individuals[index].middlename} ${individuals[index].lastname} ${individuals[index].suffix}'),
                    subtitle: Text('${individuals[index].brgy} ${individuals[index].sitio}'),
                    onTap: () {
                      Navigator.of(individualPageContext).push(
                        MaterialPageRoute(
                          builder: (individualPageContext) => IndividualSpecificPage(
                            id: individuals[index].id!,
                            firstname: individuals[index].firstname,
                            middlename: individuals[index].middlename,
                            lastname: individuals[index].lastname,
                            suffix: individuals[index].suffix,
                            gender: individuals[index].gender,
                            brgy: individuals[index].brgy,
                            sitio: individuals[index].sitio,
                            image: individuals[index].image!,
                            houseImage: individuals[index].houseImage,
                            religion: individuals[index].religion,
                            churchName: individuals[index].churchName,
                            educationalAttainment: individuals[index].educationalAttainment,
                            occupation: individuals[index].occupation,
                            mobileNumber: individuals[index].mobileNumber,
                            latitude: individuals[index].latitude,
                            longitude: individuals[index].longitude,
                            birthday: individuals[index].birthday,
                            familyRole: individuals[index].familyRole,
                            isLeader: individuals[index].isLeader,
                            isOOT: individuals[index].isOOT,
                          )
                        )
                      );
                    },
                  );
                }
              ),
            ),
          ],
        ),
      ),
    );
  }
}
