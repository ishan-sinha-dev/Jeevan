import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:file_picker/file_picker.dart';
import 'dart:io';
import 'package:flutter/foundation.dart';

class ScanScreen extends StatefulWidget {
  const ScanScreen({super.key});

  @override
  State<ScanScreen> createState() => _ScanScreenState();
}

class _ScanScreenState extends State<ScanScreen> {

  File? image;
  final ImagePicker picker = ImagePicker();

  Future pickImage() async {

    if (kIsWeb || Platform.isWindows) {

      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.image,
      );

      if (result != null) {
        setState(() {
          image = File(result.files.single.path!);
        });
      }

    } else {

      final pickedFile = await picker.pickImage(
        source: ImageSource.camera,
      );

      if (pickedFile == null) return;

      setState(() {
        image = File(pickedFile.path);
      });

    }

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      appBar: AppBar(
        title: const Text("Scan Report"),
      ),

      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [

            image != null
                ? Image.file(image!, height: 300)
                : const Text("No report selected"),

            const SizedBox(height: 20),

            ElevatedButton(
              onPressed: pickImage,
              child: const Text("Upload Medical Report"),
            ),

          ],
        ),
      ),
    );
  }
}