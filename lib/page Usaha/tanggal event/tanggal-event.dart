import 'package:flutter/material.dart';
import 'package:sponsorin/style/textstyle.dart';
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
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          Padding(
            padding: const EdgeInsets.only(
              right: 20,
            ), // Set the same right padding
            child: Container(
              // color: Colors.yellow,
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white,
              ),
              child: Icon(
                Icons.notifications_none_outlined,
                size: 30,
                color: Colors.black54,
              ),
            ),
          ),
        ],
        leading: Padding(
          padding: const EdgeInsets.only(left: 20), // Set the same left padding
          child: Container(
            width: 50,
            height: 50,
            child: Icon(
              Icons.account_circle_outlined,
              size: 40,
              color: Colors.black54,
            ),
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(24, 25, 24, 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const CustomText(
                text: 'Tanggal Event Anda', style: CustomTextStyles.title),
            const SizedBox(height: 20),

            // Widget Kalender
            SizedBox(
              height: 15,
            ),
            Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                // boxShadow: [
                //   BoxShadow(
                //     color: Colors.grey.withOpacity(0.1),
                //     spreadRadius: 1,
                //     blurRadius: 1,
                //     offset: const Offset(0, 3),
                //   ),
                // ],
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
                    fontSize: 14,
                    color: Colors.black45,
                    fontWeight: FontWeight.bold,
                  ),
                  weekendStyle: TextStyle(
                    fontSize: 14,
                    color: Colors.black45, // Set color sama dengan weekday
                    fontWeight: FontWeight.bold,
                  ),
                ),
                headerStyle: HeaderStyle(
                  titleTextStyle: TextStyle(
                    fontSize: 16,
                    fontWeight:
                        FontWeight.bold, // Ganti dengan warna yang diinginkan
                  ),
                  formatButtonTextStyle: TextStyle(
                    color: Colors.white,
                    fontSize: 13,
                  ),
                  formatButtonDecoration: BoxDecoration(
                    color: Colors.blue,
                    borderRadius: BorderRadius.circular(16.0),
                  ),
                  leftChevronIcon: Icon(
                    Icons.chevron_left,
                    color: Colors.blue, // Ganti dengan warna yang diinginkan
                    size: 30, // Ganti dengan ukuran yang diinginkan
                  ),
                  rightChevronIcon: Icon(
                    Icons.chevron_right,
                    color: Colors.blue, // Ganti dengan warna yang diinginkan
                    size: 30, // Ganti dengan ukuran yang diinginkan
                  ),
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
            const SizedBox(height: 25.0),

            // Menampilkan event pada tanggal yang dipilih
            if (_selectedDay != null)
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Events pada ${_selectedDay!.day}-${_selectedDay!.month}-${_selectedDay!.year}:',
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                        color: Color.fromRGBO(0, 0, 0, 70),
                      ),
                    ),
                    const SizedBox(height: 25.0),

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
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.all(Radius.circular(15)),
      ),
      child: Row(
        children: [
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.all(
                Radius.circular(8),
              ),
            ),
            width: 120,
            height: 80,
            margin: EdgeInsets.all(7),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(8.0),
              child: Image.asset(
                imagePath,
                fit: BoxFit.cover,
              ),
            ),
          ),
          SizedBox(width: 15),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    color: Color.fromRGBO(0, 0, 0, 70),
                    fontFamily: 'Poppins',
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                Text(
                  subtitle,
                  style: TextStyle(
                    color: Color.fromRGBO(0, 0, 0, 70),
                    fontFamily: 'Poppins',
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          SizedBox(width: 15),
          Icon(
            Icons.arrow_forward_ios,
            color: Color.fromRGBO(30, 170, 253, 100),
            size: 20,
          ),
        ],
      ),
    );
    // return Container(
    //   margin: EdgeInsets.all(7),
    //   // padding:  EdgeInsets.all(16.0),
    //   decoration: BoxDecoration(
    //     color: Colors.white,
    //     borderRadius: BorderRadius.all(
    //       Radius.circular(8),
    //     ),
    //     // boxShadow: [
    //     //   BoxShadow(
    //     //     color: Colors.grey.withOpacity(0.3),
    //     //     spreadRadius: 3,
    //     //     blurRadius: 5,
    //     //     offset: const Offset(0, 3),
    //     //   ),
    //     // ],
    //   ),
    //   width: 120,
    //   height: 80,
    //   child: Row(
    //     children: [
    //       Container(
    //         decoration: BoxDecoration(
    //           borderRadius: BorderRadius.all(
    //             Radius.circular(8),
    //           ),
    //         ),
    //         width: 120,
    //         height: 80,
    //         margin: EdgeInsets.all(7),
    //         child: ClipRRect(
    //           borderRadius: BorderRadius.circular(8.0),
    //           child: Image.asset(
    //             imagePath,
    //             fit: BoxFit.cover,
    //           ),
    //         ),
    //       ),
    //       SizedBox(width: 15),
    //       Expanded(
    //         child: Column(
    //           crossAxisAlignment: CrossAxisAlignment.start,
    //           children: [
    //             Text(
    //               title,
    //               style: TextStyle(
    //                 color: Color.fromRGBO(0, 0, 0, 70),
    //                 fontFamily: 'Poppins',
    //                 fontSize: 15,
    //                 fontWeight: FontWeight.w700,
    //               ),
    //               overflow: TextOverflow.ellipsis,
    //             ),
    //             Text(
    //               subtitle,
    //               style: TextStyle(
    //                 color: Color.fromRGBO(0, 0, 0, 70),
    //                 fontFamily: 'Poppins',
    //                 fontSize: 12,
    //                 fontWeight: FontWeight.w600,
    //               ),
    //               overflow: TextOverflow.ellipsis,
    //               maxLines: 2,
    //             ),
    //           ],
    //         ),
    //       ),
    //     ],
    //   ),
    // );
  }
}
