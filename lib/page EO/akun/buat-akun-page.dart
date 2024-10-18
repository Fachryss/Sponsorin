import 'package:flutter/material.dart';
import 'dart:async';
import 'package:file_picker/file_picker.dart';
import 'package:sponsorin/auth/pemilihan-posisi.dart';
import 'package:sponsorin/main.dart';
import 'package:sponsorin/page%20EO/akun/components.dart';
import 'package:sponsorin/page%20EO/akun/login-page.dart';
import 'package:sponsorin/page%20EO/page%20home/homepage.dart';

class BuatAkunEO extends StatefulWidget {
  const BuatAkunEO({super.key});

  @override
  State<BuatAkunEO> createState() => _BuatAkunEOState();
}

class _BuatAkunEOState extends State<BuatAkunEO> {
  bool _isPasswordVisible = false;

  void _togglePasswordVisibility() {
    setState(() {
      _isPasswordVisible = !_isPasswordVisible;
    });
  }

  String? _fileName;
  Future<void> pickFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles();

    if (result != null) {
      setState(() {
        _fileName = result.files.single.name;
      });
    } else {
      // User canceled the picker
      setState(() {
        _fileName = null;
      });
    }
  }

  final List<String> images = [
    'image/background_picture1.png',
    'image/background_picture2.png',
  ];

  int _currentImageIndex = 0;
  Timer? _timer;

  void _startImageLoop() {
    _timer = Timer.periodic(const Duration(seconds: 5), (Timer timer) {
      setState(() {
        _currentImageIndex = (_currentImageIndex + 1) % images.length;
      });
    });
  }

  @override
  void initState() {
    super.initState();
    _startImageLoop();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final Size screenSize = MediaQuery.of(context).size;
    final double screenHeight = screenSize.height;
    final double screenWidth = screenSize.width;

    // Detect if keyboard is visible
    final bool isKeyboardVisible =
        MediaQuery.of(context).viewInsets.bottom != 0;

    // Conditionally apply bottom padding
    final double bottomPadding = screenHeight > 600 ? 120 : screenHeight * 0.1;

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: Padding(
          padding: EdgeInsets.only(
            left: screenWidth * 0.05, // Adjust padding relative to screen width
          ),
          child: IconButton(
            icon: Icon(Icons.arrow_back_ios_new_rounded,
                color: Colors.white, size: screenHeight * 0.03),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => pemilihanPosisi()),
              );
            },
          ),
        ),
      ),
      body: Stack(
        children: [
          AnimatedSwitcher(
            duration: const Duration(seconds: 1),
            transitionBuilder: (Widget child, Animation<double> animation) {
              return FadeTransition(opacity: animation, child: child);
            },
            child: Container(
              key: ValueKey<int>(_currentImageIndex),
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage(images[_currentImageIndex]),
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
          Container(
            height: double.infinity,
            width: double.infinity,
            color: Colors.black.withOpacity(0.68),
            child: Padding(
              padding: EdgeInsets.fromLTRB(
                screenWidth *
                    0.06, // Horizontal padding relative to screen size
                screenHeight * 0.15, // Top padding
                screenWidth * 0.06, // Bottom padding
                bottomPadding, // Conditional bottom padding
              ),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Center(
                      child: Column(
                        children: [
                          Text(
                            "Selamat Datang",
                            style: TextStyle(
                                color: Colors.white,
                                fontSize:
                                    screenHeight * 0.04, // Responsive font size
                                fontWeight: FontWeight.w600),
                          ),
                          SizedBox(
                            height: screenHeight * 0.02,
                          ),
                          Text(
                            "Silakan membuat profile anda",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: screenHeight * 0.025,
                              fontWeight: FontWeight.w100,
                            ),
                          ),
                          SizedBox(
                            height: screenHeight * 0.05,
                          ),
                          buildTextField("Nama"),
                          SizedBox(
                            height: screenHeight * 0.03,
                          ),
                          buildTextField("Email"),
                          SizedBox(
                            height: screenHeight * 0.03,
                          ),
                          buildTextField("Nomor Telepon"),
                          SizedBox(
                            height: screenHeight * 0.03,
                          ),
                          buildTextField("Alamat Kantor"),
                          SizedBox(
                            height: screenHeight * 0.03,
                          ),
                          buildUploadField(_fileName, pickFile),
                          SizedBox(
                            height: screenHeight * 0.03,
                          ),
                          PasswordField(),
                          SizedBox(
                            height: screenHeight * 0.08,
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
          if (!isKeyboardVisible)
            buildCustomButton(
              buttonText: "Buat Akun",
              belowText: "Sudah punya akun?",
              navigateTo: HomePage(),
              navigateToStatus: loginPageEO(),
              context: context,
              status: 'Login',
            ),
        ],
      ),
    );
  }
}
