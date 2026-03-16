import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import '../services/event_storage.dart';
import '../widgets/global_app_bar.dart';

class ReportsScreen extends StatefulWidget {
  const ReportsScreen({super.key});

  @override
  State<ReportsScreen> createState() => _ReportsScreenState();
}

class _ReportsScreenState extends State<ReportsScreen> {

  DateTime today = DateTime.now();

  @override
  Widget build(BuildContext context) {

    EventStorage.updateAppointments();

    final selectedEvents = EventStorage.getEventsForDay(today);

    return Scaffold(

      appBar: const GlobalAppBar(
        title:"Reports & Appointments",
      ),

      body: Column(
        children: [

          TableCalendar(
            firstDay: DateTime.utc(2020, 1, 1),
            lastDay: DateTime.utc(2030, 12, 31),
            focusedDay: today,

            selectedDayPredicate: (day) => isSameDay(day, today),

            onDaySelected: (selectedDay, focusedDay) {
              setState(() {
                today = selectedDay;
              });
            },

            calendarBuilders: CalendarBuilders(

              markerBuilder: (context, date, events) {

                final dayEvents = EventStorage.getEventsForDay(date);

                if (dayEvents.isEmpty) return null;

                bool hasReport =
                    dayEvents.any((e) => e["type"] == "report");

                bool hasUpcoming =
                    dayEvents.any((e) =>
                        e["type"] == "appointment" &&
                        e["status"] == "upcoming");

                bool hasCompleted =
                    dayEvents.any((e) =>
                        e["type"] == "appointment" &&
                        e["status"] == "completed");

                return Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [

                    if (hasReport)
                      Container(
                        width: 6,
                        height: 6,
                        decoration: const BoxDecoration(
                          color: Colors.blue,
                          shape: BoxShape.circle,
                        ),
                      ),

                    if (hasUpcoming)
                      Container(
                        width: 6,
                        height: 6,
                        margin: const EdgeInsets.only(left: 2),
                        decoration: const BoxDecoration(
                          color: Colors.red,
                          shape: BoxShape.circle,
                        ),
                      ),

                    if (hasCompleted)
                      Container(
                        width: 6,
                        height: 6,
                        margin: const EdgeInsets.only(left: 2),
                        decoration: const BoxDecoration(
                          color: Colors.green,
                          shape: BoxShape.circle,
                        ),
                      ),

                  ],
                );

              },

            ),

          ),

          const SizedBox(height: 10),

          Expanded(
            child: ListView.builder(
              itemCount: selectedEvents.length,
              itemBuilder: (context, index) {

                final event = selectedEvents[index];

                return Card(
                  child: ListTile(

                    leading: Icon(
                      event["type"] == "report"
                          ? Icons.description
                          : Icons.alarm,
                    ),

                    title: Text(event["title"]),

                    subtitle: Text(
                      event["type"] == "report"
                          ? "Medical Report"
                          : event["status"] == "completed"
                              ? "Completed Appointment"
                              : "Upcoming Appointment",
                    ),

                  ),
                );

              },
            ),
          )

        ],
      ),
    );
  }
}