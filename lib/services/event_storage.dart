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
      "status": "upcoming"
    });

  }

  // Get events for a specific date
  static List<Map<String, dynamic>> getEventsForDay(DateTime day) {

    return events.where((event) {

      DateTime eventDate = event["date"];

      return eventDate.year == day.year &&
             eventDate.month == day.month &&
             eventDate.day == day.day;

    }).toList();

  }

  // Update appointments that have passed
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

}