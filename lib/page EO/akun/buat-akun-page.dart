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
    // Detect if keyboard is visible
    final bool isKeyboardVisible =
        MediaQuery.of(context).viewInsets.bottom != 0;

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: Padding(
          padding: const EdgeInsets.only(
            left: 24.0,
          ), // Adjust the left padding as needed
          child: IconButton(
            icon: Icon(Icons.arrow_back_ios_new_rounded,
                color: Colors.white, size: 30),
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
              padding: const EdgeInsets.fromLTRB(24, 120, 24, 0),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Center(
                      child: Column(
                        children: [
                          const Text(
                            "Selamat Datang",
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 32,
                                fontWeight: FontWeight.w600),
                          ),
                          const SizedBox(
                            height: 8,
                          ),
                          const Text(
                            "Silakan membuat profile anda",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.w100,
                            ),
                          ),
                          const SizedBox(
                            height: 60,
                          ),
                          buildTextField("Nama"),
                          const SizedBox(
                            height: 22,
                          ),
                          buildTextField("Email"),
                          const SizedBox(
                            height: 22,
                          ),
                          buildTextField("Nomor Telepon"),
                          const SizedBox(
                            height: 22,
                          ),
                          buildTextField("Alamat Kantor"),
                          const SizedBox(
                            height: 22,
                          ),
                          buildUploadField(_fileName, pickFile),
                          const SizedBox(
                            height: 22,
                          ),
                          PasswordField(),
                          const SizedBox(
                            height: 78,
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
          if (!isKeyboardVisible) // Only show button if keyboard is not visible
            buildCustomButton(
              buttonText: "Buat Akun",
              belowText: "Sudah punya akun?",
              navigateTo: HomePage(),
              navigateToStatus:
                  loginPageEO(), // Replace with your actual login page
              context: context, status: 'Login',
            ),
        ],
      ),
    );
  }
}
