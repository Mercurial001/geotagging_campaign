import 'package:flutter/material.dart';
import 'dart:io';

class HouseImagesPagesSpecific extends StatefulWidget {
  final String residence;
  final String? brgy;
  final String? sitio;
  final String imagePath;
  final double latitude;
  final double longitude;

  const HouseImagesPagesSpecific({
    super.key,
    required this.residence,
    this.brgy,
    this.sitio,
    required this.imagePath,
    required this.latitude,
    required this.longitude,
  });

  @override
  _HouseImagesPagesSpecificState createState() => _HouseImagesPagesSpecificState();
}

class _HouseImagesPagesSpecificState extends State<HouseImagesPagesSpecific> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext houseImageContext) {
    return Scaffold(
      appBar: AppBar(
        title: Text('${widget.residence} '),
        backgroundColor: const Color.fromARGB(255, 10, 40, 40),
        foregroundColor: const Color.fromARGB(255, 220, 220, 220),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            if (widget.imagePath.isNotEmpty)
              Image.file(
                File(widget.imagePath),
                width: double.infinity,
                height: 300,
                fit: BoxFit.cover,
              )
            else
              const Text('No image available'),
            Text("${widget.residence} "),
            Text("Barangay: ${widget.brgy} Sitio: ${widget.sitio}"),
            Text('${widget.latitude} ${widget.longitude}'),
          ], 
        ),
      )
    );
  }
}