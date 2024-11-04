import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';

class UploadPhotoPage extends StatefulWidget {
  @override
  _UploadPhotoPageState createState() => _UploadPhotoPageState();
}

class _UploadPhotoPageState extends State<UploadPhotoPage> {
  final ImagePicker _picker = ImagePicker();
  XFile? _image;

  Future<void> _uploadPhoto() async {
    if (_image == null) return;

    final bytes = await _image!.readAsBytes();
    final base64Image = base64Encode(bytes);

    final response = await http.post(
      Uri.parse('https://graph.facebook.com/v11.0/me/photos'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer YOUR_ACCESS_TOKEN',
      },
      body: jsonEncode({
        'source': base64Image,
        'caption': 'Uploaded via Flutter!',
      }),
    );

    if (response.statusCode == 200) {
      print('Photo uploaded successfully!');
    } else {
      print('Failed to upload photo: ${response.body}');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Upload Photo to Facebook'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _image == null
                ? Text('No image selected.')
                : Image.file(File(_image!.path)),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
                setState(() {
                  _image = pickedFile;
                });
              },
              child: Text('Pick an Image'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _uploadPhoto,
              child: Text('Upload to Facebook'),
            ),
          ],
        ),
      ),
    );
  }
}

void main() {
  runApp(MaterialApp(
    home: UploadPhotoPage(),
  ));
}
