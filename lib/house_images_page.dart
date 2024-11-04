import 'package:flutter/material.dart';
import 'package:geotagging_campaign/house_image_add.dart';
import 'package:geotagging_campaign/house_image.dart';
import 'package:geotagging_campaign/house_image_database.dart';
import 'package:geotagging_campaign/house_images_pages_specific.dart';

class HouseImagesPage extends StatefulWidget {
  const HouseImagesPage({
    super.key
  });

  @override
  _HouseImagesPageState createState() => _HouseImagesPageState();
}

class _HouseImagesPageState extends State<HouseImagesPage> {
  List<HouseImage> houseImages = [];

  @override 
  void initState() {
    // TODO: implement initState
    super.initState();
    retrieveHouseImagesFromDatabase();
  }

  Future<void> retrieveHouseImagesFromDatabase() async {
    try {
      final retrievedHouseImagesFromDatabase = await HouseImageDatabase.objects.all();

      setState(() {
        houseImages = retrievedHouseImagesFromDatabase.toList();
      });
    } catch (error) {
      debugPrint("AN Error occured while barangays retrieved from database.");
    }
  }

  @override
  Widget build(BuildContext houseImageContext) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            const Text("House Images"),
            ElevatedButton(
              onPressed: () {
                Navigator.of(houseImageContext).push(
                  MaterialPageRoute(
                    builder: (houseImageContext) => const HouseImageAddPage()
                  )
                );
              },
              child: const Text("Add House Photo")
            )
          ],
        ),
        backgroundColor: const Color.fromARGB(255, 10, 40, 40),
        foregroundColor: const Color.fromARGB(255, 220, 220, 220),
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          retrieveHouseImagesFromDatabase();
        },
        child: ListView.builder(
          itemCount: houseImages.length,
          itemBuilder: (BuildContext houseImageContext, int index) {
            return ListTile(
              title: Text(houseImages[index].residence),
              subtitle: Text('${houseImages[index].brgy} ${houseImages[index].sitio}'),
              onTap: () {
                Navigator.of(houseImageContext).push(
                  MaterialPageRoute(builder: (houseImageContext) => HouseImagesPagesSpecific(
                      residence: houseImages[index].residence, 
                      imagePath: houseImages[index].imagePath,
                      brgy: houseImages[index].brgy,
                      sitio: houseImages[index].sitio,
                      latitude: houseImages[index].latitude,
                      longitude: houseImages[index].longitude,
                    )
                  )
                );
              },
            );
          }
        )
      )
    );
  }
}