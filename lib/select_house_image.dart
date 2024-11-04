import 'package:flutter/material.dart';
import 'package:geotagging_campaign/house_image_database.dart';
import 'package:geotagging_campaign/house_image.dart';
import 'dart:io';

import 'package:geotagging_campaign/individual.dart';
import 'package:geotagging_campaign/individual_database.dart';

class SelectHouseImagePage extends StatefulWidget {
  final int id;
  const SelectHouseImagePage({
    super.key,
    required this.id,
  });

  @override
  _SelectHouseImagePageState createState() => _SelectHouseImagePageState();
}

class _SelectHouseImagePageState extends State<SelectHouseImagePage> {
  List<HouseImage> houseImages = [];
  Individual? individualObj;
  @override
  void initState() {
    super.initState();
    retrieveAllHouseImages();
    retrieveIndividual(widget.id);
  }

  Future<void> retrieveAllHouseImages() async {
    try {
      final retrievedHouseImagesFromDatabase = await HouseImageDatabase.objects.all();

      setState(() {
        houseImages = retrievedHouseImagesFromDatabase.toList();
        
      });
    } catch(error) {
      debugPrint('An error has occured during retrieving house images');
    }
  }

  Future<void> retrieveIndividual(int id) async {
    try{
      final retrievedIndividual = await IndividualDatabase.objects.readIndividual(id);
      setState(() {
        individualObj = retrievedIndividual;
        debugPrint("successfully retrieved individual object from database");
      });
    } catch (error) {
      debugPrint("An error occured while retrieving individual object from database.");
    }
  }

  @override
  Widget build(BuildContext selectImageContext) {
    final screenWidth = MediaQuery.of(selectImageContext).size.width;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Select House Image"),
        backgroundColor: const Color.fromARGB(255, 10, 40, 40),
        foregroundColor: const Color.fromARGB(255, 220, 220, 220),
      ),
      body: RefreshIndicator(
        onRefresh: retrieveAllHouseImages,
        child: SingleChildScrollView( // Makes the content scrollable
          child: Wrap(
            spacing: 8.0,
            runSpacing: 8.0,
            children: List.generate(
              houseImages.length,
              (index) {
                return Card(
                  elevation: 4,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: (screenWidth - 24) / 2, // Width for two items per row
                        height: 180,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(8.0),
                          child: Image.file(
                            File(houseImages[index].imagePath),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "${houseImages[index].residence}",
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                            Text("BRGY: ${houseImages[index].brgy}"),
                            Text("Sitio: ${houseImages[index].sitio}"),
                            const SizedBox(height: 8),
                            ElevatedButton(
                              onPressed: () async {
                                individualObj = individualObj!.copyWith(houseImage: houseImages[index].imagePath);
                                await IndividualDatabase.objects.updateIndividual(individualObj!);

                                setState(() {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text('House image added to the individual.'),
                                    ),
                                  );
                                });

                              },
                              child: const Text("Select Image"),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}