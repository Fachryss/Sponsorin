import 'package:flutter/material.dart';
import 'dart:ui';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // Warna primary color
  final Color primaryColor = Color(0xFF1EAAFD);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Custom Theme Demo',
      theme: ThemeData(
        // Set primary color
        primaryColor: primaryColor,
        // Gunakan font Poppins
        fontFamily: 'Poppins',
        // Definisikan textTheme
        textTheme: const TextTheme(
          // Headline
          headline1: TextStyle(
            fontSize: 24.0,
            fontWeight: FontWeight.w600,
            color: Colors.black,
          ),
          // Title
          headline6: TextStyle(
            fontSize: 20.0,
            fontWeight: FontWeight.w600,
            color: Colors.black,
          ),
          // AppBar
          headline5: TextStyle(
            fontSize: 16.0,
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
          // Subtitle
          subtitle1: TextStyle(
            fontSize: 16.0,
            fontWeight: FontWeight.w600,
            color: Colors.black,
          ),
          // Body
          bodyText1: TextStyle(
            fontSize: 14.0,
            fontWeight: FontWeight.w500,
            color: Color(0xFF595959),
          ),
          // Body2
          bodyText2: TextStyle(
            fontSize: 14.0,
            fontWeight: FontWeight.w400,
            color: Color(0xFF595959),
          ),
        ),
        // Atur AppBar Theme
        appBarTheme: AppBarTheme(
          backgroundColor: primaryColor,
          titleTextStyle: TextStyle(
            fontSize: 16.0,
            fontWeight: FontWeight.w600,
            fontFamily: 'Poppins',
            color: Colors.white,
          ),
          iconTheme: IconThemeData(
            color: Colors.white,
          ),
        ),
      ),
      home: HomePage(),
    );
  }
}

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Menggunakan text style dari theme
    return Scaffold(
      appBar: AppBar(
        title: Text('Home Page'), // Menggunakan style AppBarTheme
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Text(
              'Headline Text',
              style: Theme.of(context).textTheme.headline1,
            ),
            SizedBox(height: 8),
            Text(
              'Title Text',
              style: Theme.of(context).textTheme.headline6,
            ),
            SizedBox(height: 8),
            Text(
              'Subtitle Text',
              style: Theme.of(context).textTheme.subtitle1,
            ),
            SizedBox(height: 8),
            Text(
              'Body Text',
              style: Theme.of(context).textTheme.bodyText1,
            ),
            SizedBox(height: 8),
            Text(
              'Body2 Text',
              style: Theme.of(context).textTheme.bodyText2,
            ),
          ],
        ),
      ),
    );
  }
}
