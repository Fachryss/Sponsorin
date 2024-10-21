import 'package:flutter/material.dart';
import 'package:sponsorin/page%20EO/Page%20deskripsi%20usaha/deskripsi-usaha.dart';
import 'package:sponsorin/page%20EO/Page%20deskripsi%20usaha/review.dart';
import 'package:sponsorin/page%20EO/Page%20deskripsi%20usaha/title.dart';
import 'package:sponsorin/page%20EO/page%20home/homepage.dart';
import 'package:sponsorin/style/textstyle.dart';

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

Widget _getContent(String selectedCategory, String description) {
  if (selectedCategory == "overview") {
    return buildDescriptionCard(description);
  } else if (selectedCategory == "reviews") {
    return ReviewUsaha();
  }
  return Container(); // Fallback for any other category
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
    onTap: () {
      Navigator.pop(context);
      if (label == "AI Generate") {
        // Aksi AI Generate
      } else if (label == "Google Drive") {
      } else if (label == "Upload") {}
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
              color: Colors.black54,
              width: 2.0,
            ),
          ),
          child: ClipOval(
            child: Image.network(
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

class _InformasiUsahaState extends State<InformasiUsaha> {
  @override
  Widget build(BuildContext context) {
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
                _getContent(selectedCategory, widget.description),
              ],
            ),
          ),
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
            selectedCategory == "overview"
                ? _showAddTaskOptions(context)
                : print("Beri review");
          },
          child: Text(
            selectedCategory == "overview"
                ? "Ajukan kerja sama"
                : "Beri review",
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
