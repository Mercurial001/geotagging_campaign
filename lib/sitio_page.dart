import 'package:flutter/material.dart';
import 'package:geotagging_campaign/sitio_add_page.dart';
import 'package:geotagging_campaign/sitio_database.dart';
import 'package:geotagging_campaign/sitios.dart';

class SitioPage extends StatefulWidget {
  const SitioPage({
    super.key
  });

  @override
  _SitioPageState createState() => _SitioPageState();
}

class _SitioPageState extends State<SitioPage> {
  List<Sitio> sitios = [];

  @override
  void initState() {
    super.initState();
    retrieveSitiosFromDatabase();
  }

  Future<void> retrieveSitiosFromDatabase() async {
    try{
      final retrievedSitios = await SitioDatabase.objects.allSitios();
      setState(() {
        sitios = retrievedSitios.toList();
      });

    } catch (error){
      SnackBar(content: Text("$error"),);
    }
  }

  @override
  Widget build(BuildContext sitioContext) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            const Text("Sitio"),
            ElevatedButton(
              onPressed: () {
                Navigator.of(sitioContext).push(
                  MaterialPageRoute(builder: (sitioContext) => const SitioAddPage())
                );
              }, 
              child: const Text("Add Sitio")
            )
          ],
        ),
        backgroundColor: const Color.fromARGB(255, 10, 40, 40),
        foregroundColor: const Color.fromARGB(255, 220, 220, 220),
      ),
      body: RefreshIndicator(
        onRefresh: retrieveSitiosFromDatabase,
        child: ListView.builder(
          itemCount: sitios.length,
          itemBuilder: (BuildContext context, int index) {
            return ListTile(
              title: Text("${sitios[index].name} ${sitios[index].brgy}"),
              subtitle: Text('${sitios[index].lat.toString()} ${sitios[index].long.toString()}'),
            );
          }
        ),
      )
    );
  }
}
