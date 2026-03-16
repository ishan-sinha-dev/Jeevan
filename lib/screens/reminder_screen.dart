import 'package:flutter/material.dart';
import '../services/event_storage.dart';
import '../widgets/global_app_bar.dart';

class RemindersScreen extends StatefulWidget {
  const RemindersScreen({super.key});

  @override
  State<RemindersScreen> createState() => _RemindersScreenState();
}

class _RemindersScreenState extends State<RemindersScreen> {

  List<Map<String, dynamic>> reminders = [];

  void chooseReminderType() {

    showModalBottomSheet(
      context: context,
      builder: (context) {

        return SizedBox(
          height: 150,
          child: Column(
            children: [

              ListTile(
                leading: const Icon(Icons.calendar_today),
                title: const Text("Appointment"),
                onTap: () {
                  Navigator.pop(context);
                  showAppointmentDialog();
                },
              ),

              ListTile(
                leading: const Icon(Icons.medication),
                title: const Text("Medicine Reminder"),
                onTap: () {
                  Navigator.pop(context);
                  showMedicineDialog();
                },
              ),

            ],
          ),
        );

      },
    );

  }

  void showAppointmentDialog() {

    TextEditingController titleController = TextEditingController();
    TextEditingController purposeController = TextEditingController();

    DateTime selectedDate = DateTime.now();
    TimeOfDay selectedTime = TimeOfDay.now();

    showDialog(
      context: context,
      builder: (context) {

        return AlertDialog(

          title: const Text("Add Appointment"),

          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [

                TextField(
                  controller: titleController,
                  decoration: const InputDecoration(
                    labelText: "Appointment Title",
                  ),
                ),

                const SizedBox(height: 10),

                TextField(
                  controller: purposeController,
                  decoration: const InputDecoration(
                    labelText: "Purpose of Appointment",
                  ),
                ),

                const SizedBox(height: 10),

                ElevatedButton(
                  onPressed: () async {

                    DateTime? picked = await showDatePicker(
                      context: context,
                      initialDate: DateTime.now(),
                      firstDate: DateTime(2024),
                      lastDate: DateTime(2030),
                    );

                    if (picked != null) {
                      selectedDate = picked;
                    }

                  },
                  child: const Text("Select Date"),
                ),

                ElevatedButton(
                  onPressed: () async {

                    TimeOfDay? picked = await showTimePicker(
                      context: context,
                      initialTime: TimeOfDay.now(),
                    );

                    if (picked != null) {
                      selectedTime = picked;
                    }

                  },
                  child: const Text("Select Time"),
                ),

              ],
            ),
          ),

          actions: [

            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text("Cancel"),
            ),

            ElevatedButton(
              onPressed: () {

                DateTime appointmentDateTime = DateTime(
                  selectedDate.year,
                  selectedDate.month,
                  selectedDate.day,
                  selectedTime.hour,
                  selectedTime.minute,
                );

                setState(() {

                  reminders.add({
                    "title": titleController.text,
                    "purpose": purposeController.text,
                    "type": "appointment",
                    "date": appointmentDateTime
                  });

                });

                EventStorage.addAppointment(
                  titleController.text,
                  selectedDate,
                );

                Navigator.pop(context);

              },
              child: const Text("Add"),
            ),

          ],

        );

      },
    );

  }

  void showMedicineDialog() {

    TextEditingController medicineController = TextEditingController();
    TextEditingController doseController = TextEditingController();
    TextEditingController gapController = TextEditingController();
    TextEditingController daysController = TextEditingController();

    TimeOfDay startTime = TimeOfDay.now();

    showDialog(
      context: context,
      builder: (context) {

        return AlertDialog(

          title: const Text("Add Medicine"),

          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [

                TextField(
                  controller: medicineController,
                  decoration: const InputDecoration(
                    labelText: "Medicine Name",
                  ),
                ),

                const SizedBox(height: 10),

                TextField(
                  controller: doseController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    labelText: "Doses Per Day",
                  ),
                ),

                const SizedBox(height: 10),

                TextField(
                  controller: gapController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    labelText: "Gap Between Doses (hours)",
                  ),
                ),

                const SizedBox(height: 10),

                TextField(
                  controller: daysController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    labelText: "How many days",
                  ),
                ),

                const SizedBox(height: 10),

                ElevatedButton(
                  onPressed: () async {

                    TimeOfDay? picked = await showTimePicker(
                      context: context,
                      initialTime: TimeOfDay.now(),
                    );

                    if (picked != null) {
                      startTime = picked;
                    }

                  },
                  child: const Text("Select Start Time"),
                ),

              ],
            ),
          ),

          actions: [

            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text("Cancel"),
            ),

            ElevatedButton(
              onPressed: () {

                int doses = int.parse(doseController.text);
                int gap = int.parse(gapController.text);
                int days = int.parse(daysController.text);

                DateTime now = DateTime.now();

                for (int d = 0; d < days; d++) {

                  for (int i = 0; i < doses; i++) {

                    DateTime reminderTime = DateTime(
                      now.year,
                      now.month,
                      now.day + d,
                      startTime.hour + (gap * i),
                      startTime.minute,
                    );

                    reminders.add({
                      "title": medicineController.text,
                      "type": "medicine",
                      "date": reminderTime
                    });

                  }

                }

                setState(() {});

                Navigator.pop(context);

              },
              child: const Text("Add"),
            ),

          ],

        );

      },
    );

  }

  String formatTime(DateTime date) {

    int hour = date.hour;
    int minute = date.minute;

    String period = hour >= 12 ? "PM" : "AM";

    hour = hour % 12;
    if (hour == 0) hour = 12;

    String minuteStr = minute.toString().padLeft(2, '0');

    return "$hour:$minuteStr $period";
  }

  List<Widget> buildReminderWidgets() {

    Map<String, List<Map<String, dynamic>>> grouped = {};

    for (var reminder in reminders) {

      DateTime date = reminder["date"];
      String key = "${date.year}-${date.month}-${date.day}";

      if (!grouped.containsKey(key)) {
        grouped[key] = [];
      }

      grouped[key]!.add(reminder);
    }

    List<Widget> widgets = [];

    grouped.forEach((dateKey, dayReminders) {

      dayReminders.sort((a, b) => a["date"].compareTo(b["date"]));

      DateTime date = dayReminders.first["date"];

      widgets.add(

        Padding(
          padding: const EdgeInsets.symmetric(vertical: 10),
          child: Text(
            "${date.day}/${date.month}/${date.year}",
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),

      );

      int dose = 1;

      for (var reminder in dayReminders) {

        DateTime time = reminder["date"];

        widgets.add(

          Card(
            elevation: 3,
            margin: const EdgeInsets.symmetric(vertical: 5),
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [

                  if (reminder["type"] == "medicine")
                    Text(
                      "Dose $dose",
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.blue,
                      ),
                    ),

                  const SizedBox(height: 4),

                  Text(
                    reminder["title"],
                    style: const TextStyle(
                      fontSize: 18,
                    ),
                  ),

                  if (reminder["type"] == "appointment")
                    Text(
                      reminder["purpose"] ?? "",
                      style: const TextStyle(
                        color: Colors.grey,
                        fontSize: 14,
                      ),
                    ),

                  const SizedBox(height: 4),

                  Text(
                    formatTime(time),
                    style: const TextStyle(
                      color: Colors.grey,
                    ),
                  ),

                ],
              ),
            ),
          ),

        );

        dose++;

      }

    });

    return widgets;
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(

      appBar: const GlobalAppBar(
        title: "Daily Reminders",
      ),
      
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: buildReminderWidgets(),
      ),

      floatingActionButton: FloatingActionButton(
        onPressed: chooseReminderType,
        child: const Icon(Icons.add),
      ),

    );
  }
}