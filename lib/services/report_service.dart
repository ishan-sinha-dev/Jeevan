import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ReportService {

  final FirebaseAuth auth = FirebaseAuth.instance;
  final FirebaseStorage storage = FirebaseStorage.instance;
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  Future<void> saveReport({
    required File image,
    required String extractedText,
    required DateTime reportDate,
    required String title,
    required String description,
  }) async {

    final user = auth.currentUser;

    if (user == null) {
      throw Exception("User not logged in");
    }

    // upload image
final storageRef = FirebaseStorage.instance
    .ref()
    .child("reports")
    .child(user.uid)
    .child("${DateTime.now().millisecondsSinceEpoch}.jpg");

UploadTask uploadTask = storageRef.putFile(image);

TaskSnapshot snapshot = await uploadTask;

String imageUrl = await snapshot.ref.getDownloadURL();

    // save report document
    await firestore.collection("reports").add({
      "userId": user.uid,
      "title": title,
      "description": description,
      "reportDate": reportDate,
      "imageUrl": imageUrl,
      "ocrText": extractedText,
      "createdAt": Timestamp.now(),
    });

  }
}