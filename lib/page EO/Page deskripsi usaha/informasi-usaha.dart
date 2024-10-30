import 'dart:io';
import 'dart:math';

import 'package:enhanced_url_launcher/enhanced_url_launcher.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:http/src/client.dart';
import 'package:open_file/open_file.dart';
import 'package:sponsorin/page%20EO/Page%20deskripsi%20usaha/deskripsi-usaha.dart';
import 'package:sponsorin/page%20EO/Page%20deskripsi%20usaha/review.dart';
import 'package:sponsorin/page%20EO/Page%20deskripsi%20usaha/titleusaha.dart';
import 'package:sponsorin/page%20EO/ai/AIGenerate.dart';

import 'package:sponsorin/page%20EO/page%20home/homepage.dart';
import 'package:sponsorin/style/textstyle.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:googleapis/drive/v3.dart' as drive;
import 'package:googleapis_auth/auth_io.dart';
import 'dart:io' as io;
import 'package:path_provider/path_provider.dart';
import 'package:googledrivehandler/googledrivehandler.dart';

class InformasiUsaha extends StatefulWidget {
  final String businessName;
  final String category;
  final String address;
  final String description;
  final String imagePath;

  const InformasiUsaha({
    Key? key,
    required this.businessName,
    required this.category,
    required this.address,
    required this.description,
    required this.imagePath,
  }) : super(key: key);

  @override
  State<InformasiUsaha> createState() => _InformasiUsahaState();
}

final String myApiKey = "AIzaSyC0M9R-lb_0LS7XtiEoC9JveslZAusI5rQ";

Widget _categoryButton(String text, bool isSelected, VoidCallback onPressed) {
  return GestureDetector(
    onTap: onPressed,
    child: Text(
      text,
      style: TextStyle(
        color: isSelected ? Color(0xFF1EAAFD) : Colors.black54,
        fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
        fontSize: 18,
      ),
    ),
  );
}

Widget _getContent(String selectedCategory, String description, String title) {
  if (selectedCategory == "overview") {
    return buildDescriptionCard(description, title);
  } else if (selectedCategory == "reviews") {
    return buildReviewPage();
  }
  return Container(); // Fallback for any other category
}

class _InformasiUsahaState extends State<InformasiUsaha> {
  final GoogleSignIn _googleSignIn = GoogleSignIn(
    scopes: [drive.DriveApi.driveFileScope],
  );

  String fileName = '';
  File? file_proposal;

  void _updateFile(File? file) {
    setState(() {
      file_proposal = file;
      fileName = file != null ? file.path.split('/').last : '';
    });
  }

  void _showError(String error) {
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $error')),
      );
    }
  }

  String selectedCategory = "overview";
  void _showAddTaskOptions(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Container(
          padding: EdgeInsets.all(16),
          height: 150,
          child: GridView.count(
            crossAxisCount: 3, // Menampilkan dalam 3 kolom
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
            children: [
              _buildOption(context, 'image/AI-gen.png', "AI Generate"),
              _buildOption(context, 'image/drive.png', "Google Drive"),
              _buildOption(context, 'image/upload.png', "Upload"),
            ],
          ),
        );
      },
    );
  }

  Widget _buildOption(
    BuildContext context,
    String imagePath,
    String label,
  ) {
    return GestureDetector(
      onTap: () async {
        Navigator.pop(context);
        if (label == "AI Generate") {
          // Navigate to the AI Generate Screen and get the result
          File? generatedFile = await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => AIGenerate(
                onProposalGenerated: (File) {},
              ),
            ),
          );
          if (generatedFile != null) {
            _updateFile(generatedFile);
          }
        } else if (label == "Google Drive") {
          try {
            File? myFile = await GoogleDriveHandler()
                .getFileFromGoogleDrive(context: context);
            if (myFile != null) {
              _updateFile(myFile);
              OpenFile.open(myFile.path);
              print("Selected file from Google Drive: ${myFile.path}");
            } else {
              print("No file selected from Google Drive");
            }
          } catch (e) {
            if (mounted) {
              _showError(e.toString());
            }
          }
        } else if (label == "Upload") {
          FilePickerResult? result = await FilePicker.platform.pickFiles();
          if (result != null) {
            File file = File(result.files.single.path!);
            _updateFile(file);
            print("Uploaded file from device: ${file.path}");
          } else {
            print("No file uploaded");
          }
        }
      },
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 65,
            height: 65,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: Colors.black54, // Border color
                width: 2.0, // Border width
              ),
            ),
            child: ClipOval(
              child: Image.asset(
                imagePath,
                errorBuilder: (BuildContext context, Object exception,
                    StackTrace? stackTrace) {
                  return Text('Failed to load image');
                },
              ),
            ),
          ),
          SizedBox(height: 10),
          Text(
            label,
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    GoogleDriveHandler().setAPIKey(
      apiKey: myApiKey,
    );
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(
          "Details",
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: Colors.black87,
          ),
        ),
        centerTitle: true,
        leading: Padding(
          padding: const EdgeInsets.only(left: 20),
          child: Container(
            width: 50,
            height: 50,
            child: IconButton(
              icon: Icon(
                Icons.arrow_back_ios,
                size: 20,
                color: Colors.black54,
              ),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
          child: Padding(
            padding: EdgeInsets.fromLTRB(24, 20, 24, 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  width: 360,
                  height: 396,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(20.0),
                    // bukan ini
                    child: Image.network(
                      widget.imagePath,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                SizedBox(height: 20),
                Row(
                  children: [
                    _categoryButton(
                      "overview",
                      selectedCategory == "overview",
                      () {
                        setState(() {
                          selectedCategory = "overview";
                        });
                      },
                    ),
                    SizedBox(width: 10),
                    Text(
                      "|",
                      style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: Colors.black54),
                    ),
                    SizedBox(width: 10),
                    _categoryButton(
                      "reviews",
                      selectedCategory == "reviews",
                      () {
                        setState(() {
                          selectedCategory = "reviews";
                        });
                      },
                    ),
                  ],
                ),
                SizedBox(height: 25),
                title(
                  widget.businessName,
                  widget.category,
                  widget.address,
                ),
                SizedBox(height: 25),
                _getContent(
                    selectedCategory, widget.description, 'Deskripsi Usaha'),
                SizedBox(height: 25),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: Container(
        margin: EdgeInsets.fromLTRB(24, 15, 24, 15),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (fileName.isNotEmpty)
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: Colors.grey[300]!),
                ),
                padding: EdgeInsets.fromLTRB(15, 0, 15, 0),
                // color: Colors.grey[200],
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Flexible(
                      child: Text(
                        fileName.length > 200
                            ? '${fileName.substring(0, 17)}...'
                            : fileName,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    IconButton(
                      icon: Icon(Icons.cancel, color: Colors.red),
                      onPressed: () {
                        _updateFile(null);
                      },
                    ),
                  ],
                ),
              ),
            SizedBox(
              height: 15,
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.fromLTRB(24, 15, 24, 15),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                backgroundColor: Color(0xFF1EAAFD),
                minimumSize: Size(800, 50),
              ),
              onPressed: () async {
                file_proposal != null
                    ? print("Kirim")
                    : selectedCategory == "overview"
                        ? _showAddTaskOptions(context)
                        : print("Beri review");
              },
              child: Text(
                file_proposal != null
                    ? "Kirim"
                    : selectedCategory == "overview"
                        ? "Ajukan kerja sama"
                        : "Beri review",
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                  fontSize: 18,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
