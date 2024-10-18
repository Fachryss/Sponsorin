import 'package:flutter/material.dart';
import 'dart:async';
import 'package:file_picker/file_picker.dart';
import 'package:sponsorin/auth/pemilihan-posisi.dart';
import 'package:sponsorin/main.dart';
import 'package:sponsorin/page%20EO/akun/components.dart';
import 'package:sponsorin/page%20EO/akun/login-page.dart';
import 'package:sponsorin/page%20EO/page%20home/homepage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:random_avatar/random_avatar.dart';
import 'dart:typed_data';
import 'package:flutter/rendering.dart';
import 'dart:ui' as ui;

class BuatAkunEO extends StatefulWidget {
  const BuatAkunEO({Key? key}) : super(key: key);

  @override
  State<BuatAkunEO> createState() => _BuatAkunEOState();
}

class _BuatAkunEOState extends State<BuatAkunEO> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;
  
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  
  bool _isPasswordVisible = false;
  bool _isLoading = false;

  GlobalKey _avatarKey = GlobalKey();
  String _randomAvatarSeed = DateTime.now().toIso8601String();

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

  @override
  void dispose() {
    _timer?.cancel();
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _addressController.dispose();
    _passwordController.dispose();
    super.dispose();
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

  Future<Uint8List?> _capturePng() async {
    try {
      RenderRepaintBoundary boundary = _avatarKey.currentContext!.findRenderObject() as RenderRepaintBoundary;
      ui.Image image = await boundary.toImage(pixelRatio: 3.0);
      ByteData? byteData = await image.toByteData(format: ui.ImageByteFormat.png);
      print("Avatar captured successfully");
      return byteData?.buffer.asUint8List();
    } catch (e) {
      print("Error capturing avatar: $e");
      return null;
    }
  }

  Future<String?> _uploadAvatarToStorage(Uint8List imageData, String userId) async {
    try {
      Reference ref = _storage.ref().child('user_avatars').child('$userId.png');
      UploadTask uploadTask = ref.putData(imageData);
      TaskSnapshot snapshot = await uploadTask;
      String downloadUrl = await snapshot.ref.getDownloadURL();
      print("Avatar uploaded successfully: $downloadUrl");
      return downloadUrl;
    } catch (e) {
      print('Error uploading avatar: $e');
      return null;
    }
  }

  Future<void> _createAccount() async {
    setState(() {
      _isLoading = true;
    });

    try {
      UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
        email: _emailController.text,
        password: _passwordController.text,
      );

      if (userCredential.user != null) {
        Uint8List? imageData = await _capturePng();
        String? avatarUrl;
        
        if (imageData != null) {
          avatarUrl = await _uploadAvatarToStorage(imageData, userCredential.user!.uid);
          if (avatarUrl == null) {
            print("Failed to upload avatar");
          }
        } else {
          print("Failed to capture avatar");
        }

        await _firestore.collection('users').doc(userCredential.user!.uid).set({
          'name': _nameController.text,
          'email': _emailController.text,
          'phone': _phoneController.text,
          'address': _addressController.text,
          'documentName': _fileName,
          'userType': 'EO',
          'avatarUrl': avatarUrl,
        });

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => HomePage()),
        );
      }
    } on FirebaseAuthException catch (e) {
      String errorMessage = 'An error occurred. Please try again.';
      if (e.code == 'weak-password') {
        errorMessage = 'The password provided is too weak.';
      } else if (e.code == 'email-already-in-use') {
        errorMessage = 'The account already exists for that email.';
      }
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(errorMessage)),
      );
    } catch (e) {
      print("Error in _createAccount: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('An error occurred. Please try again.')),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Widget _buildTextField(String input, TextEditingController controller, {bool isPassword = false}) {
    return Opacity(opacity: 0.85, child: 
    Container(
      width: 350,
      height: 52,
      // margin: EdgeInsets.symmetric(vertical: 10),
      child: TextField(
        controller: controller,
        obscureText: isPassword && !_isPasswordVisible,
        style:TextStyle(color: Colors.white, fontSize: 16),
        decoration: InputDecoration(
          filled: true,
          fillColor: Color.fromRGBO(78, 75, 76, 65),
          hintText: input,
          hintStyle: TextStyle(
            color: Colors.white70,
            fontSize: 14,
            fontWeight: FontWeight.w100,
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(6)
          ),
          contentPadding: EdgeInsets.fromLTRB(23, 0, 0, 0)
        ),
      ),
      // child: TextField(
      //   controller: controller,
      //   obscureText: isPassword && !_isPasswordVisible,
      //   style: TextStyle(color: Colors.white),
      //   decoration: InputDecoration(
      //     labelText: label,
      //     labelStyle: TextStyle(color: Colors.white70),
      //     enabledBorder: OutlineInputBorder(
      //       borderSide: BorderSide(color: Colors.white70),
      //       borderRadius: BorderRadius.circular(10),
      //     ),
      //     focusedBorder: OutlineInputBorder(
      //       borderSide: BorderSide(color: Colors.white),
      //       borderRadius: BorderRadius.circular(10),
      //     ),
      //     suffixIcon: isPassword
      //         ? IconButton(
      //             icon: Icon(
      //               _isPasswordVisible ? Icons.visibility : Icons.visibility_off,
      //               color: Colors.white70,
      //             ),
      //             onPressed: _togglePasswordVisibility,
      //           )
      //         : null,
      //   ),
      ),
    );
    
  }

  Widget _buildUploadField() {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          primary: Colors.white24,
          onPrimary: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        onPressed: pickFile,
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 15),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.upload_file),
              SizedBox(width: 10),
              Text(_fileName ?? 'Upload Dokumen'),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final bool isKeyboardVisible = MediaQuery.of(context).viewInsets.bottom != 0;

    // Conditionally apply bottom padding
    final double bottomPadding = screenHeight > 600 ? 120 : screenHeight * 0.1;

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: Padding(
          padding: const EdgeInsets.only(left: 24.0),
          child: IconButton(
            icon: Icon(Icons.arrow_back_ios_new_rounded, color: Colors.white, size: 30),
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
            child: SafeArea(
              child: SingleChildScrollView(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: screenSize.width * 0.05),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SizedBox(height: screenSize.height * 0.05),
                      Text(
                        "Selamat Datang",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: screenSize.width * 0.08,
                          fontWeight: FontWeight.w600
                        ),
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
                      // SizedBox(height: screenSize.height * 0.05),
                      // RepaintBoundary(
                      //   key: _avatarKey,
                      //   child: RandomAvatar(_randomAvatarSeed, height: screenSize.width * 0.25, width: screenSize.width * 0.25),
                      // ),
                      SizedBox(height: screenSize.height * 0.03),
                      _buildTextField("Nama", _nameController),
                      _buildTextField("Email", _emailController),
                      _buildTextField("Nomor Telepon", _phoneController),
                      _buildTextField("Alamat Kantor", _addressController),
                      _buildTextField("Password", _passwordController, isPassword: true),
                      _buildUploadField(),
                      SizedBox(height: screenSize.height * 0.05),
                      if (!isKeyboardVisible)
                        // Visibility(
                        //   visible: !isKeyboardVisible,
                        //   child: buildCustomButton(
                        //     buttonText: "Buat Akun",
                        //     belowText: "Belum punya akun?",
                        //     navigateTo: HomePage(),
                        //     navigateToStatus: BuatAkunEO(),
                        //     context: context,
                        //     status: 'Sign Up',
                        //     onPressed: _signIn,
                        //     isLoading: _isLoading,
                        //   ),
                        // ),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            primary: Colors.blue,
                            onPrimary: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            padding: EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                          ),
                          onPressed: _isLoading ? null : _createAccount,
                          child: _isLoading
                              ? CircularProgressIndicator(color: Colors.white)
                              : Text("Buat Akun", style: TextStyle(fontSize: 18)),
                        ),
                      SizedBox(height: screenSize.height * 0.02),
                      TextButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => loginPageEO()),
                          );
                        },
                        child: Text(
                          "Sudah punya akun? Login",
                          style: TextStyle(color: Colors.white, fontSize: 16),
                        ),
                      ),
                      SizedBox(height: screenSize.height * 0.05),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// Update the buildTextField and PasswordField widgets in components.dart if not already updated
// Widget buildTextField(String input, {required TextEditingController controller}) {
//   return Opacity(
//     opacity: 0.85,
//     child: Container(
//       width: 350,
//       height: 52,
//       child: TextField(
//         controller: controller,
//         style: TextStyle(
//           color: Colors.white,
//           fontSize: 16,
//         ),
//         decoration: InputDecoration(
//           filled: true,
//           fillColor: Color.fromRGBO(78, 75, 76, 65),
//           hintText: input,
//           hintStyle: TextStyle(
//             color: Colors.white70,
//             fontSize: 14,
//             fontWeight: FontWeight.w100,
//           ),
//           border: OutlineInputBorder(
//             borderRadius: BorderRadius.circular(6),
//           ),
//           contentPadding: EdgeInsets.fromLTRB(23, 0, 0, 0),
//         ),
//       ),
//     ),
//   );
// }

// class PasswordField extends StatefulWidget {
//   final TextEditingController controller;

//   const PasswordField({Key? key, required this.controller}) : super(key: key);

//   @override
//   _PasswordFieldState createState() => _PasswordFieldState();
// }

// class _PasswordFieldState extends State<PasswordField> {
//   bool _isPasswordVisible = false;

//   void _togglePasswordVisibility() {
//     setState(() {
//       _isPasswordVisible = !_isPasswordVisible;
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       mainAxisAlignment: MainAxisAlignment.center,
//       children: <Widget>[
//         Opacity(
//           opacity: 0.85,
//           child: SizedBox(
//             width: 350,
//             height: 52,
//             child: TextField(
//               controller: widget.controller,
//               obscureText: !_isPasswordVisible,
//               style: const TextStyle(
//                 color: Colors.white,
//                 fontSize: 18,
//               ),
//               decoration: InputDecoration(
//                 filled: true,
//                 fillColor: const Color.fromRGBO(78, 75, 76, 65),
//                 hintText: "Password",
//                 hintStyle: const TextStyle(
//                   color: Colors.white70,
//                   fontSize: 14,
//                   fontWeight: FontWeight.w100,
//                 ),
//                 border: OutlineInputBorder(
//                   borderRadius: BorderRadius.circular(6),
//                 ),
//                 contentPadding: const EdgeInsets.fromLTRB(23, 0, 0, 0),
//                 suffixIcon: IconButton(
//                   icon: Icon(
//                     _isPasswordVisible ? Icons.visibility : Icons.visibility_off,
//                     color: Colors.white,
//                   ),
//                   onPressed: _togglePasswordVisibility,
//                 ),
//               ),
//             ),
//           ),
//         ),
//       ],
//     );
//   }
// }

// Update the buildCustomButton in components.dart if not already updated
// Widget buildCustomButton({
//   required String buttonText,
//   required String belowText,
//   required String status,
//   required Widget navigateTo,
//   required Widget navigateToStatus,
//   required BuildContext context,
//   required VoidCallback onPressed,
//   required bool isLoading,
// }) {
//   return Container(
//     child: Padding(
//       padding: EdgeInsets.fromLTRB(24, 20, 24, 50),
//       child: Column(
//         mainAxisAlignment: MainAxisAlignment.end,
//         children: [
//           Center(
//             child: Column(
//               mainAxisAlignment: MainAxisAlignment.center,
//               crossAxisAlignment: CrossAxisAlignment.center,
//               children: [
//                 ElevatedButton(
//                   style: ElevatedButton.styleFrom(
//                     padding: EdgeInsets.fromLTRB(20, 10, 20, 10),
//                     shape: RoundedRectangleBorder(
//                       borderRadius: BorderRadius.circular(12),
//                     ),
//                     backgroundColor: Color.fromARGB(255, 255, 255, 255),
//                     minimumSize: Size(300, 50),
//                   ),
//                   onPressed: isLoading ? null : onPressed,
//                   child: isLoading
//                       ? CircularProgressIndicator()
//                       : Text(
//                           buttonText,
//                           style: TextStyle(
//                             color: Colors.black,
//                             fontWeight: FontWeight.w600,
//                             fontSize: 24,
//                           ),
//                         ),
//                 ),
//                 SizedBox(height: 15),
//                 Row(
//                   crossAxisAlignment: CrossAxisAlignment.center,
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   children: [
//                     Text(
//                       belowText,
//                       style: TextStyle(
//                         fontSize: 14,
//                         fontWeight: FontWeight.w200,
//                         color: Colors.white,
//                       ),
//                     ),
//                     SizedBox(width: 5),
//                     GestureDetector(
//                       onTap: () {
//                         Navigator.push(
//                           context,
//                           MaterialPageRoute(
//                             builder: (context) => navigateToStatus,
//                           ),
//                         );
//                       },
//                       child: RichText(
//                         text: TextSpan(
//                           text: status,
//                           style: TextStyle(
//                             fontSize: 15,
//                             fontWeight: FontWeight.w600,
//                             color: Colors.white,
//                             decoration: TextDecoration.underline,
//                             decorationColor: Colors.white,
//                           ),
//                         ),
//                       ),
//                     )
//                   ],
//                 )
//               ],
//             ),
//           )
//         ],
//       ),
//     ),
//   );
// }