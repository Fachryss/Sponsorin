import 'package:flutter/material.dart';
import 'package:sponsorin/main.dart';
import 'package:sponsorin/page%20EO/add%20event/add-event.dart';

class ProsesAddEvent extends StatefulWidget {
  const ProsesAddEvent({super.key});

  @override
  State<ProsesAddEvent> createState() => _ProsesAddEventState();
}

class _ProsesAddEventState extends State<ProsesAddEvent> {
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      Future.delayed(const Duration(seconds: 5), () {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => HomePage(role: 'EO')),
        );
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Color(0xFF1EAAFD),
        child: Center(
          child: Container(
            alignment: Alignment.center,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(24, 20, 24, 25),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset('image/event_available.png'),
                  SizedBox(
                    height: 25,
                  ),
                  Text(
                    "Event anda berhasil di tambahkan, tunggu sponsor dari usaha. ",
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                    ),
                    textAlign: TextAlign.center, // Center-align the text
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
