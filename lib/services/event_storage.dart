import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class EventStorage {

  static List<Map<String, dynamic>> events = [];

  // Add scanned report
  static void addReport(String title, DateTime date) {

    events.add({
      "title": title,
      "date": date,
      "type": "report"
    });

  }

  // Add appointment reminder
  static void addAppointment(String title, DateTime date) {

    events.add({
      "title": title,
      "date": date,
      "type": "appointment",
      "time": "${date.hour}:${date.minute.toString().padLeft(2, '0')}",
      "status": "upcoming"
    });

  }

 
  static List<Map<String, dynamic>> getEventsForDay(DateTime day) {

    return events.where((event) {

      DateTime eventDate = event["date"];

      return eventDate.year == day.year &&
             eventDate.month == day.month &&
             eventDate.day == day.day;

    }).toList();

  }

  static void updateAppointments() {

    DateTime today = DateTime.now();

    for (var event in events) {

      if (event["type"] == "appointment") {

        DateTime eventDate = event["date"];

        if (eventDate.isBefore(today)) {

          event["status"] = "completed";

        }

      }

    }

  }

  static Future loadReportsFromFirebase() async {

    final user = FirebaseAuth.instance.currentUser;

    if (user == null) return;

    final snapshot = await FirebaseFirestore.instance
        .collection("reports")
        .where("userId", isEqualTo: user.uid)
        .get();

    for (var doc in snapshot.docs) {

      final data = doc.data();

      DateTime reportDate =
          (data["reportDate"] as Timestamp).toDate();

      events.add({
        "title": data["title"] ?? "Medical Report",
        "date": reportDate,
        "type": "report"
      });

    }

  }

}