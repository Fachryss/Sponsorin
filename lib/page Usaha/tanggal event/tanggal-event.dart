import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';

class TanggalEvent extends StatefulWidget {
  const TanggalEvent({Key? key}) : super(key: key);

  @override
  State<TanggalEvent> createState() => _TanggalEventState();
}

class _TanggalEventState extends State<TanggalEvent> {
  CalendarFormat _calendarFormat = CalendarFormat.month;
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;

  final Map<DateTime, List<Map<String, String>>> _events = {
    DateTime(2024, 10, 30): [
      {
        "image": "image/google.png",
        "title": "Google I/O Extended",
        "subtitle": "Sebuah seminar yang memperkenalkan teknologi."
      },
    ],
    DateTime(2024, 11, 14): [
      {
        "image": "image/google.png",
        "title": "Event Lainnya",
        "subtitle": "Diskusi mengenai perkembangan teknologi terbaru."
      },
    ],
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromRGBO(244, 244, 244, 100),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 20),
            child: Container(
              width: 50,
              height: 50,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white,
              ),
              child: const Icon(
                Icons.notifications_none_outlined,
                size: 30,
                color: Colors.black,
              ),
            ),
          ),
        ],
        leading: Padding(
          padding: const EdgeInsets.only(left: 20),
          child: const Icon(
            Icons.account_circle_outlined,
            size: 40,
            color: Colors.black54,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(24, 20, 24, 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Tanggal Event Anda',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),

            // Widget Kalender
            Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.3),
                    spreadRadius: 3,
                    blurRadius: 5,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: TableCalendar(
                firstDay: DateTime.utc(2022, 1, 1),
                lastDay: DateTime.utc(2030, 12, 31),
                focusedDay: _focusedDay,
                calendarFormat: _calendarFormat,
                selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
                onDaySelected: (selectedDay, focusedDay) {
                  setState(() {
                    _selectedDay = selectedDay;
                    _focusedDay = focusedDay;
                  });
                },
                onFormatChanged: (format) {
                  setState(() {
                    _calendarFormat = format;
                  });
                },
                onPageChanged: (focusedDay) {
                  _focusedDay = focusedDay;
                },
                calendarStyle: CalendarStyle(
                  todayDecoration: BoxDecoration(
                    color: Colors.blue,
                    shape: BoxShape.circle,
                  ),
                  selectedDecoration: BoxDecoration(
                    color: Colors.orange,
                    shape: BoxShape.circle,
                  ),
                ),
                daysOfWeekHeight: 30,
                daysOfWeekStyle: DaysOfWeekStyle(
                  weekdayStyle: TextStyle(
                    fontSize: 16,
                    color: Colors.black87,
                    fontWeight: FontWeight.bold,
                  ),
                  weekendStyle: TextStyle(
                    fontSize: 16,
                    color: Colors.black87, // Set color sama dengan weekday
                    fontWeight: FontWeight.bold,
                  ),
                ),
                headerStyle: HeaderStyle(
                  formatButtonVisible: true,
                  titleCentered: true,
                ),
                calendarBuilders: CalendarBuilders(
                  markerBuilder: (context, date, events) {
                    if (_events.keys
                        .any((eventDate) => isSameDay(eventDate, date))) {
                      return Positioned(
                        top: 10,
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.black,
                            shape: BoxShape.circle,
                          ),
                          width: 6,
                          height: 6,
                        ),
                      );
                    }
                    return const SizedBox();
                  },
                ),
              ),
            ),
            const SizedBox(height: 12.0),

            // Menampilkan event pada tanggal yang dipilih
            if (_selectedDay != null)
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Events pada ${_selectedDay!.day}-${_selectedDay!.month}-${_selectedDay!.year}:',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8.0),

                    // Menampilkan event dari _events hanya jika _selectedDay cocok
                    if (_events.containsKey(DateTime(_selectedDay!.year,
                        _selectedDay!.month, _selectedDay!.day)))
                      Expanded(
                        child: ListView(
                          children: _events[DateTime(
                            _selectedDay!.year,
                            _selectedDay!.month,
                            _selectedDay!.day,
                          )]!
                              .map((event) => Padding(
                                    padding: const EdgeInsets.only(bottom: 15),
                                    child: BuildContainerPanjang(
                                      event["image"]!,
                                      event["title"]!,
                                      event["subtitle"]!,
                                    ),
                                  ))
                              .toList(),
                        ),
                      )
                    else
                      const Center(
                        child: Text(
                          'Tidak ada event pada tanggal ini.',
                          style: TextStyle(fontSize: 16),
                        ),
                      ),
                  ],
                ),
              )
            else
              const Center(
                child: Text(
                  'Pilih tanggal untuk melihat event',
                  style: TextStyle(fontSize: 16),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

// Kelas BuildContainerPanjang
class BuildContainerPanjang extends StatelessWidget {
  final String imagePath;
  final String title;
  final String subtitle;

  const BuildContainerPanjang(this.imagePath, this.title, this.subtitle,
      {Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.0),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.3),
            spreadRadius: 3,
            blurRadius: 5,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        children: [
          Image.asset(
            imagePath,
            width: 50,
            height: 50,
            fit: BoxFit.cover,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[600],
                  ),
                  overflow: TextOverflow.ellipsis,
                  maxLines: 2,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
