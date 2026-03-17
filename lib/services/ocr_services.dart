import 'dart:io';
import 'package:http/http.dart' as http;

Future<String> uploadReport(
  File image,
  String date,
  String title,
  String description,
) async {

  var request = http.MultipartRequest(
    'POST',
    Uri.parse('http://10.0.2.2:8000/upload-report/'),
  );

  request.files.add(
    await http.MultipartFile.fromPath('file', image.path),
  );

  request.fields['date'] = date;
  request.fields['title'] = title;
  request.fields['description'] = description;

  var response = await request.send();

  var responseData = await response.stream.bytesToString();

  return responseData;
}