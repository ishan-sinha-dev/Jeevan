import 'package:flutter/material.dart';
import '../services/event_storage.dart';

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

    DateTime selectedDate = DateTime.now();
    TimeOfDay selectedTime = TimeOfDay.now();

    showDialog(
      context: context,
      builder: (context) {

        return AlertDialog(

          title: const Text("Add Appointment"),

          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [

              TextField(
                controller: titleController,
                decoration: const InputDecoration(
                  labelText: "Appointment Title",
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
                    "type": "Appointment",
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
                      "type": "Medicine",
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

  @override
  Widget build(BuildContext context) {

    return Scaffold(

      appBar: AppBar(
        title: const Text("Daily Reminders"),
      ),

      body: ListView.builder(
        itemCount: reminders.length,
        itemBuilder: (context, index) {

          final reminder = reminders[index];

          return Card(
            child: ListTile(

              leading: Icon(
                reminder["type"] == "medicine"
                    ? Icons.medication
                    : Icons.calendar_today,
              ),

              title: Text(reminder["title"]),

              subtitle: Text(
                reminder["date"].toString(),
              ),

            ),
          );

        },
      ),

      floatingActionButton: FloatingActionButton(
        onPressed: chooseReminderType,
        child: const Icon(Icons.add),
      ),

    );
  }
}