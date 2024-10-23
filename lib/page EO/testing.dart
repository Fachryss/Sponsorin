import 'dart:io';
import 'package:flutter/material.dart';
import 'package:googledrivehandler/googledrivehandler.dart';
import 'package:open_file/open_file.dart';
import 'package:file_picker/file_picker.dart';

void main() {
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    home: FileUploadScreen(),
  ));
}

class FileUploadScreen extends StatefulWidget {
  @override
  _FileUploadScreenState createState() => _FileUploadScreenState();
}

class _FileUploadScreenState extends State<FileUploadScreen> {
  File? file_proposal;
  String fileName = '';

  void _updateFile(File? file) {
    setState(() {
      file_proposal = file;
      fileName = file != null ? file.path.split('/').last : '';
    });
  }

  void _showAddTaskOptions(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Container(
          padding: EdgeInsets.all(16),
          height: 150,
          child: GridView.count(
            crossAxisCount: 3, // Display in 3 columns
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
            children: [
              _buildOption(context, 'assets/image/AI-gen.png', "AI Generate"),
              _buildOption(context, 'assets/image/drive.png', "Google Drive"),
              _buildOption(context, 'assets/image/upload.png', "Upload"),
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
          // Navigate to the AI Generate Screen
          // Navigator.push(
          //   context,
          //   MaterialPageRoute(builder: (context) => AIGenerateScreen()),
          // );
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
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Error: $e')),
            );
            print('Error: $e');
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
    return Scaffold(
      appBar: AppBar(
        title: Text("File Upload"),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () async {
                _showAddTaskOptions(context);
              },
              child: const Text("Show Options"),
            ),
            if (fileName.isNotEmpty)
              Container(
                margin: EdgeInsets.all(16),
                padding: EdgeInsets.all(16),
                color: Colors.grey[200],
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Selected File: $fileName'),
                    IconButton(
                      icon: Icon(Icons.cancel, color: Colors.red),
                      onPressed: () {
                        _updateFile(null);
                      },
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
      bottomNavigationBar: Container(
        margin: EdgeInsets.fromLTRB(24, 15, 24, 15),
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            padding: EdgeInsets.fromLTRB(20, 10, 20, 10),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            backgroundColor: Color(0xFF1EAAFD),
            minimumSize: Size(200, 50),
          ),
          onPressed: () {
            print("Button pressed");
          },
          child: Text(
            "Submit",
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w600,
              fontSize: 18,
            ),
          ),
        ),
      ),
    );
  }
}
