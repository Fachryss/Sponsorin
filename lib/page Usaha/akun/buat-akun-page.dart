import 'dart:async';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:sponsorin/auth/pemilihan-posisi.dart';
import 'package:sponsorin/page%20Usaha/akun/login-page.dart';

class BuatAkunUsaha extends StatefulWidget {
  const BuatAkunUsaha({super.key});

  @override
  State<BuatAkunUsaha> createState() => _BuatAkunUsahaState();
}

class _BuatAkunUsahaState extends State<BuatAkunUsaha> {
  bool _isPasswordVisible = false;
  bool _isLoading = false;
  final TextEditingController _tagController = TextEditingController();
  final List<String> _tags = [];

  final List<String> _suggestions = [
    "Retail",
    "Makanan",
    "Jasa",
    "Kesehatan",
    "Pendidikan",
    "Hiburan"
  ];

  String? _fileName;
  List<String> images = [
    'image/background_picture1.png',
    'image/background_picture2.png',
  ];

  int _currentImageIndex = 0;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _startImageLoop();
  }

  void _startImageLoop() {
    _timer = Timer.periodic(const Duration(seconds: 5), (Timer timer) {
      setState(() {
        _currentImageIndex = (_currentImageIndex + 1) % images.length;
      });
    });
  }

  void _togglePasswordVisibility() {
    setState(() {
      _isPasswordVisible = !_isPasswordVisible;
    });
  }

  Future<void> pickFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles();

    if (result != null) {
      setState(() {
        _fileName = result.files.single.name;
      });
    } else {
      setState(() {
        _fileName = null;
      });
    }
  }

  Widget _buildTextField(String input,
      // TextEditingController controller,
      {bool isPassword = false}) {
    return Opacity(
      opacity: 0.85,
      child: Container(
        margin: const EdgeInsets.fromLTRB(0, 0, 0, 22),
        width: 350,
        height: 52,
        // margin: EdgeInsets.symmetric(vertical: 10),
        child: TextField(
          // controller: controller,
          obscureText: isPassword && !_isPasswordVisible,
          style: const TextStyle(color: Colors.white, fontSize: 16),
          decoration: InputDecoration(
            filled: true,
            fillColor: const Color.fromRGBO(78, 75, 76, 65),
            hintText: input,
            hintStyle: TextStyle(
              color: Colors.white,
              fontSize: 14,
              fontWeight: FontWeight.w100,
            ),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(6)),
            contentPadding: const EdgeInsets.fromLTRB(23, 0, 0, 0),
            suffixIcon: isPassword
                ? IconButton(
                    icon: Icon(
                      _isPasswordVisible
                          ? Icons.visibility
                          : Icons.visibility_off,
                      color: Colors.white,
                    ),
                    onPressed: _togglePasswordVisibility,
                  )
                : null,
          ),
        ),
      ),
    );
  }

  Widget _buildUploadField() {
    return Opacity(
      opacity: 0.85,
      child: SizedBox(
        width: 350,
        height: 52,
        child: TextField(
          onTap: pickFile,
          readOnly: true,
          style: TextStyle(
            color: Colors.white,
            fontSize: 18,
          ),
          decoration: InputDecoration(
            filled: true,
            fillColor: Color.fromRGBO(78, 75, 76, 65),
            hintText: _fileName ?? 'Surat Izin Usaha Perdagangan',
            hintStyle: TextStyle(
              color: Colors.white,
              fontSize: 14,
              fontWeight: FontWeight.w100,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(6),
            ),
            contentPadding: const EdgeInsets.fromLTRB(23, 0, 0, 0),
            suffixIcon: const Icon(
              Icons.file_upload_outlined,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;

    final bool isKeyboardVisible =
        MediaQuery.of(context).viewInsets.bottom != 0;
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: Padding(
          padding: const EdgeInsets.only(left: 24.0),
          child: IconButton(
            icon: Icon(Icons.arrow_back_ios_new_rounded,
                color: Colors.white, size: 30),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => pemilihanPosisi(),
                ),
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
            child: SafeArea(
              child: SingleChildScrollView(
                child: Padding(
                  padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        SizedBox(height: screenSize.height * 0.05),
                        Text(
                          "Selamat Datang",
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: screenSize.width * 0.08,
                              fontWeight: FontWeight.w600),
                        ),
                        SizedBox(height: screenSize.height * 0.01),
                        Text(
                          "Silakan membuat profile anda",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: screenSize.width * 0.04,
                            fontWeight: FontWeight.w300,
                          ),
                        ),
                        Container(
                          height: 470,
                          // color: Colors.red,
                          // padding: EdgeInsets.fromLTRB(
                          //     0, screenSize.height * 0.05, 0, 0),
                          // color: Colors.red,
                          child: SingleChildScrollView(
                            child: Column(
                              children: [
                                SizedBox(height: screenSize.height * 0.05),
                                // RepaintBoundary(
                                //   key: _avatarKey,
                                //   child: RandomAvatar(_randomAvatarSeed, height: screenSize.width * 0.25, width: screenSize.width * 0.25),
                                // ),
                                // SizedBox(height: screenSize.height * 0.05),
                                _buildTextField(
                                  "Nama Usaha",
                                  // _nameController
                                ),
                                Opacity(
                                  opacity: 0.85,
                                  child: Container(
                                    margin:
                                        const EdgeInsets.fromLTRB(0, 0, 0, 22),
                                    width: 350,
                                    height: 52,
                                    child: TextField(
                                      maxLines: null,
                                      keyboardType: TextInputType.multiline,
                                      style: const TextStyle(
                                          color: Colors.white, fontSize: 16),
                                      decoration: InputDecoration(
                                        filled: true,
                                        fillColor: const Color.fromRGBO(
                                            78, 75, 76, 65),
                                        hintText: "Deskripsi Usaha",
                                        hintStyle: TextStyle(
                                          color: Colors.white,
                                          fontSize: 14,
                                          fontWeight: FontWeight.w100,
                                        ),
                                        border: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(6)),
                                        contentPadding:
                                            const EdgeInsets.fromLTRB(
                                                23, 0, 0, 0),
                                      ),
                                    ),
                                  ),
                                ),
                                Opacity(
                                  opacity: 0.85,
                                  child: Container(
                                    margin:
                                        const EdgeInsets.fromLTRB(0, 0, 0, 22),
                                    width: 350,
                                    height: 52,
                                    child: TextField(
                                      controller: _tagController,
                                      onChanged: (text) {
                                        setState(() {});
                                      },
                                      style: const TextStyle(
                                          color: Colors.white, fontSize: 16),
                                      decoration: InputDecoration(
                                        filled: true,
                                        fillColor: const Color.fromRGBO(
                                            78, 75, 76, 65),
                                        hintText: _tags.isEmpty
                                            ? "Kategori Usaha"
                                            : _tags.join(', '),
                                        suffixIcon: _tags.isNotEmpty
                                            ? IconButton(
                                                icon: Icon(
                                                  Icons.clear,
                                                  color: Colors.white,
                                                ),
                                                onPressed: () {
                                                  setState(() {
                                                    _tags.clear();
                                                  });
                                                },
                                              )
                                            : null,
                                        hintStyle: TextStyle(
                                          color: Colors.white,
                                          fontSize: 14,
                                          fontWeight: FontWeight.w100,
                                        ),
                                        border: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(6)),
                                        contentPadding:
                                            const EdgeInsets.fromLTRB(
                                                23, 0, 0, 0),
                                      ),
                                    ),
                                  ),
                                ),
                                if (_tagController.text.isNotEmpty)
                                  Opacity(
                                    opacity: 0.85,
                                    child: Wrap(
                                      spacing: 8.0,
                                      children: _suggestions
                                          .where((tag) => tag
                                              .toLowerCase()
                                              .contains(_tagController.text
                                                  .toLowerCase()))
                                          .map((tag) => GestureDetector(
                                                onTap: () {
                                                  setState(() {
                                                    if (!_tags.contains(tag))
                                                      _tags.add(tag);
                                                    _tagController.clear();
                                                  });
                                                },
                                                child: Chip(
                                                  label: Text(tag),
                                                  labelStyle: TextStyle(
                                                      color: Colors.white),
                                                  backgroundColor:
                                                      const Color.fromRGBO(
                                                          78, 75, 76, 65),
                                                  deleteIcon: Icon(
                                                    Icons
                                                        .remove_circle_outline_sharp,
                                                    color: Colors.white,
                                                    size: 20,
                                                  ),
                                                  shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            18),
                                                  ),
                                                ),
                                              ))
                                          .toList(),
                                    ),
                                  ),
                                _buildTextField(
                                  "Email",
                                  // _emailController
                                ),
                                _buildTextField(
                                  "Nomor Telepon",
                                  // _phoneController
                                ),
                                _buildTextField(
                                  "Alamat Usaha",
                                  // _addressController
                                ),
                                _buildUploadField(),
                                SizedBox(
                                  height: 22,
                                ),
                                _buildTextField("Password",
                                    // _passwordController,
                                    isPassword: true),
                              ],
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
          if (!isKeyboardVisible)
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Container(
                padding: EdgeInsets.fromLTRB(24, 20, 24, 50),
                color: Colors.transparent,
                child: Column(
                  children: [
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        padding: EdgeInsets.fromLTRB(20, 10, 20, 10),
                        backgroundColor: Color.fromARGB(255, 255, 255, 255),
                        minimumSize: Size(300, 50),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      onPressed: () {},
                      //_isLoading ? null : _createAccount,
                      child: _isLoading
                          ? CircularProgressIndicator(color: Colors.white)
                          : Text(
                              "Buat Akun",
                              style: TextStyle(
                                  fontSize: 24,
                                  color: Colors.black,
                                  fontWeight: FontWeight.w600),
                            ),
                    ),
                    TextButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => loginPageUsaha()),
                          );
                        },
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "Sudah punya akun?",
                              style:
                                  TextStyle(color: Colors.white, fontSize: 16),
                            ),
                            SizedBox(
                              width: 5,
                            ),
                            Text(
                              "Login",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                decoration: TextDecoration.underline,
                                decorationColor: Colors.white,
                              ),
                            ),
                          ],
                        )),
                  ],
                ),
              ),
            )
        ],
      ),
    );
  }
}
