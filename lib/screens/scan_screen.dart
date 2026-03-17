import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:file_picker/file_picker.dart';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ScanScreen extends StatefulWidget {
  const ScanScreen({super.key});

  @override
  State<ScanScreen> createState() => _ScanScreenState();
}

class _ScanScreenState extends State<ScanScreen> {

  File? image;
  String extractedText = "";
  bool isLoading = false;

  final ImagePicker picker = ImagePicker();

  List<Map<String, dynamic>> savedReports = [];

  // CAMERA
  Future pickFromCamera() async {

    final pickedFile = await picker.pickImage(
      source: ImageSource.camera,
    );

    if (pickedFile == null) return;

    setState(() {
      image = File(pickedFile.path);
    });

  }

  // GALLERY
  Future pickFromGallery() async {

    final pickedFile = await picker.pickImage(
      source: ImageSource.gallery,
    );

    if (pickedFile == null) return;

    setState(() {
      image = File(pickedFile.path);
    });

  }

  // MULTIPLE FILE PICKER
  Future pickFromFiles() async {

    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.image,
      allowMultiple: true,
    );

    if (result != null) {

      for (var file in result.files) {

        File selectedFile = File(file.path!);

        setState(() {
          image = selectedFile;
        });

        await sendToOCR();

        setState(() {
          savedReports.add({
            "image": selectedFile,
            "text": extractedText,
            "date": DateTime.now().toString()
          });
        });

      }

      setState(() {
        image = null;
        extractedText = "";
      });

    }

  }

  // OCR API
  Future sendToOCR() async {

    if (image == null) return;

    setState(() {
      isLoading = true;
    });

    var request = http.MultipartRequest(
      'POST',
      Uri.parse("http://192.168.31.43:8000/upload-report/"),
    );

    request.files.add(
      await http.MultipartFile.fromPath('file', image!.path),
    );

    request.fields['date'] = "2026-03-17";
    request.fields['title'] = "Medical Report";
    request.fields['description'] = "Uploaded from app";

    var response = await request.send();

    var responseData = await response.stream.bytesToString();

    var decoded = jsonDecode(responseData);

    setState(() {
      extractedText = decoded["extracted_text"] ?? "";
      isLoading = false;
    });

  }

  // SAVE SINGLE REPORT
  void saveReport() {

    if (image == null || extractedText.isEmpty) return;

    setState(() {

      savedReports.add({
        "image": image,
        "text": extractedText,
        "date": DateTime.now().toString()
      });

      image = null;
      extractedText = "";

    });

  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(

      appBar: AppBar(
        title: const Text("Scan Report"),
      ),

      body: SingleChildScrollView(

        child: Column(

          children: [

            const SizedBox(height: 20),

            image != null
                ? Image.file(image!, height: 300)
                : const Text("No report selected"),

            const SizedBox(height: 20),

            const Text("Upload Report"),

            const SizedBox(height: 10),

            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [

                ElevatedButton(
                  onPressed: pickFromCamera,
                  child: const Text("Camera"),
                ),

                const SizedBox(width: 10),

                ElevatedButton(
                  onPressed: pickFromGallery,
                  child: const Text("Gallery"),
                ),

                const SizedBox(width: 10),

                if (kIsWeb || Platform.isWindows)
                  ElevatedButton(
                    onPressed: pickFromFiles,
                    child: const Text("Files"),
                  ),

              ],
            ),

            const SizedBox(height: 20),

            ElevatedButton(
              onPressed: sendToOCR,
              child: const Text("Analyze Report"),
            ),

            const SizedBox(height: 20),

            if (!isLoading && extractedText.isNotEmpty)
              ElevatedButton(
                onPressed: saveReport,
                child: const Text("Save Report"),
              ),

            const SizedBox(height: 20),

            if (isLoading)
              const CircularProgressIndicator(),

            if (!isLoading && extractedText.isNotEmpty)
              Container(
                margin: const EdgeInsets.all(20),
                padding: const EdgeInsets.all(15),
                height: 200,
                decoration: BoxDecoration(
                  color: Colors.grey.shade200,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: SingleChildScrollView(
                  child: Text(
                    extractedText,
                    style: const TextStyle(
                      fontSize: 16,
                      height: 1.6,
                    ),
                  ),
                ),
              ),

            const SizedBox(height: 20),

            const Text(
              "Saved Reports",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 10),

            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: savedReports.length,
              itemBuilder: (context, index) {

                var report = savedReports[index];

                return Card(

                  margin: const EdgeInsets.all(10),

                  child: ListTile(

                    leading: Image.file(
                      report["image"],
                      width: 50,
                      height: 50,
                      fit: BoxFit.cover,
                    ),

                    title: Text("Report ${index + 1}"),

                    subtitle: Text(
                      report["text"].toString().substring(
                        0,
                        report["text"].length > 50
                            ? 50
                            : report["text"].length,
                      ),
                    ),

                  ),
                );
              },
            )

          ],

        ),

      ),

    );

  }

}