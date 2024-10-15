import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:flutter/material.dart';
import 'package:sponsorin/auth/auth.dart';
import 'package:sponsorin/auth/pemilihan-posisi.dart';
import 'package:sponsorin/page%20EO/Search/search-page.dart';
import 'package:sponsorin/page%20EO/add%20event/add-event.dart';
import 'package:sponsorin/page%20EO/akun/buat-akun-page.dart';
import 'package:sponsorin/page%20EO/page%20home/homepage.dart';
import 'package:sponsorin/page%20EO/Page%20deskripsi%20usaha/informasi-usaha.dart';
import 'package:sponsorin/style/textstyle.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final Color primaryColor = Color.fromRGBO(30, 170, 253, 100);

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
      home: auth(),
    );
  }
}

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;

  final List<Widget> _pages = [Homepage(), SearchPage(), AddEvent()];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _selectedIndex,
        children: _pages,
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Color.fromRGBO(244, 244, 244, 100),
        type: BottomNavigationBarType.fixed, // Menonaktifkan animasi
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: _buildNavItem(0, Icons.home_outlined),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: _buildNavItem(1, Icons.search),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: _buildNavItem(2, Icons.add),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: _buildNavItem(3, Icons.person_outline),
            label: '',
          ),
        ],
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
      ),
    );
  }

  Widget _businessCard(String businessName, String category, Color color) {
    return Card(
      elevation: 3,
      child: ListTile(
        leading: Icon(Icons.store, color: color),
        title:
            Text(businessName, style: TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text(category),
        trailing: ElevatedButton(
          onPressed: () {},
          child: Text('Ajukan kerja sama'),
        ),
      ),
    );
  }

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
            decoration:
                BoxDecoration(shape: BoxShape.circle, color: Color(0xFF2C3E50)),
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
