import 'package:firebase_core/firebase_core.dart';
import 'package:sponsorin/auth/auth.dart';
import 'package:sponsorin/page%20EO/Page%20deskripsi%20usaha/informasi-usaha.dart';
import 'package:sponsorin/page%20EO/Search/search-page.dart';
import 'package:sponsorin/page%20EO/add%20event/add-event.dart';
import 'package:sponsorin/page%20EO/add%20event/form-detail-event.dart';
import 'package:sponsorin/page%20EO/akun/buat-akun-page.dart';
import 'package:sponsorin/page%20EO/akun/login-page.dart';
import 'package:sponsorin/page%20EO/page%20home/homepage.dart';
import 'package:sponsorin/page%20EO/profile/profile.dart';
import 'package:sponsorin/page%20Usaha/akun/buat-akun-page.dart';
import 'package:sponsorin/page%20Usaha/page%20deskripsi%20event/informasi-event.dart';
import 'package:sponsorin/page%20Usaha/page%20home/homepage.dart';
import 'package:sponsorin/page%20Usaha/profile/profile.dart';
import 'package:sponsorin/page%20Usaha/search/search-page.dart';
import 'firebase_options.dart';
import 'package:flutter/material.dart';
import 'package:sponsorin/style/textstyle.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final Color primaryColor = Color(0xFF1EAAFD);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Business App',
      theme: ThemeData(
        primaryColor: primaryColor,
        fontFamily: 'Poppins',
        textTheme: const TextTheme(),
      ),
      home: ProfileUsaha(),
    );
  }
}

class HomePage extends StatefulWidget {
  final String role;
  HomePage({required this.role});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;

  final List<Widget> _EOPages = [
    Homepage(),
    SearchPage(),
    AddEvent(), // Add your other pages here
    ProfileEO(), // Example: Placeholder, you can add actual pages
  ];

  final List<Widget> _UsahaPages = [
    HomepageUsaha(),
    SearchPageUsaha(),
    ProfileUsaha()
  ];
  List<BottomNavigationBarItem> _buildNavBarItems() {
    return widget.role == 'EO'
        ? [
            BottomNavigationBarItem(
                icon: _buildNavItem(0, Icons.home_outlined), label: ''),
            BottomNavigationBarItem(
                icon: _buildNavItem(1, Icons.search_rounded), label: ''),
            BottomNavigationBarItem(
                icon: _buildNavItem(2, Icons.add_rounded), label: ''),
            BottomNavigationBarItem(
                icon: _buildNavItem(3, Icons.person_outline_rounded),
                label: ''),
          ]
        : [
            BottomNavigationBarItem(
                icon: _buildNavItem(0, Icons.home_outlined), label: ''),
            BottomNavigationBarItem(
                icon: _buildNavItem(1, Icons.search_rounded), label: ''),
            BottomNavigationBarItem(
                icon: _buildNavItem(2, Icons.date_range_rounded), label: ''),
            BottomNavigationBarItem(
                icon: _buildNavItem(3, Icons.person_outline_rounded),
                label: ''),
          ];
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final pages = widget.role == 'EO' ? _EOPages : _UsahaPages;

    return Scaffold(
      body: pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Color.fromRGBO(244, 244, 244, 100),
        type: BottomNavigationBarType.fixed, // Disable animation
        items: _buildNavBarItems(),
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
      ),
    );
  }

  // Business Card Widget (Unrelated to Navigation Logic)
  Widget _businessCard(String businessName, String category, Color color) {
    return Card(
      elevation: 3,
      child: ListTile(
        leading: Icon(Icons.store, color: color),
        title: Text(
          businessName,
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Text(category),
        trailing: ElevatedButton(
          onPressed: () {},
          child: Text('Ajukan kerja sama'),
        ),
      ),
    );
  }

  // Bottom Navigation Item UI
  Widget _buildNavItem(int index, IconData icon) {
    return Stack(
      alignment: Alignment.center,
      children: [
        if (_selectedIndex != index)
          Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: const Color.fromARGB(0, 255, 255, 255),
            ),
          ),
        if (_selectedIndex == index)
          Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Color(0xFF2C3E50),
            ),
          ),
        Icon(
          icon,
          size: 32,
          color: _selectedIndex == index
              ? Colors.white
              : Color.fromRGBO(72, 76, 82, 100),
        ),
      ],
    );
  }
}
