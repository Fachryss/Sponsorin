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
import 'package:sponsorin/page%20Usaha/page%20deskripsi%20event/deskripsi-event.dart';
import 'package:sponsorin/page%20Usaha/page%20deskripsi%20event/proposal-page.dart';
import 'package:sponsorin/page%20Usaha/page%20deskripsi%20event/titleEvent.dart';
import 'package:sponsorin/style/textstyle.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:googleapis/drive/v3.dart' as drive;
import 'package:googleapis_auth/auth_io.dart';
import 'dart:io' as io;
import 'package:path_provider/path_provider.dart';
import 'package:googledrivehandler/googledrivehandler.dart';

class InfromasiEvent extends StatefulWidget {
  // final String businessName;
  // final String category;
  // final String address;
  // final String description;
  // final String imagePath;

  // const InfromasiEvent({
  //   Key? key,
  //   required this.businessName,
  //   required this.category,
  //   required this.address,
  //   required this.description,
  //   required this.imagePath,
  // }) : super(key: key);

  @override
  State<InfromasiEvent> createState() => _InfromasiEventState();
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

Widget _getContent(
  String selectedCategory,
  String descriptionOne,
  String descriptionTwo,
  String descriptionThree,
  String descriptionFour,
  String title,
  String titleTwo,
  String titleThree,
  String titleFour,
  String titleFive,
  String titleSix,
  String descriptionFive,
  ImageProvider ImagePathOne,
  ImageProvider ImagePathTwo,
  ImageProvider ImagePathThree,
) {
  if (selectedCategory == "overview") {
    return buildDescriptionCardEvent(
        descriptionOne,
        descriptionTwo,
        descriptionThree,
        descriptionFour,
        title,
        titleTwo,
        titleThree,
        titleFour,
        titleFive,
        titleSix,
        descriptionFive,
        ImagePathOne,
        ImagePathTwo,
        ImagePathThree);
  } else if (selectedCategory == "reviews") {
    return buildReviewPage();
  } else if (selectedCategory == "Proposal") {
    return buildProposalCard();
  }
  return Container(); // Fallback for any other category
}

class _InfromasiEventState extends State<InfromasiEvent> {
  String fileName = '';
  File? file_proposal;

  void _showError(String error) {
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $error')),
      );
    }
  }

  String selectedCategory = "overview";

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
                    // bukan ini
                    child: Image.asset('image/google.png'),
                    // child: Image.network(
                    //   widget.imagePath,
                    //   fit: BoxFit.cover,
                    // ),
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
                      "Proposal",
                      selectedCategory == "Proposal",
                      () {
                        setState(() {
                          selectedCategory = "Proposal";
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
                titleEvent(
                    'Disnat',
                    'Seminar, Pendidikan, Tech',
                    'Jalan Raya Bukit Darmo 22-24, Surabaya',
                    '+62 853-3573-3052'
                    // widget.businessName,
                    // widget.category,
                    // widget.address,
                    ),
                SizedBox(height: 25),
                _getContent(
                  selectedCategory,
                  'Google I/O Extended Surabaya 2021 berlangsung pada 29 Juli di Suara Surabaya Center, menghadirkan topik seperti Android, Flutter, Machine Learning, dan Firebases',
                  '- Make the Best Use of Dart \n- Flutter for Web Development \n- Firebase for Mobile Apps',
                  '- Pengembangan perangkat lunak \n- Pengembangan aplikasi \n- Pengembangan web',
                  '- Paket utama (Title Sponsor): \nNama sponsor ditampilkan di materi promosi utama. \nLogo sponsor di website dan materi cetak acara. \nKesempatan untuk berbicara di acara atau menyajikan presentasi.\nBooth eksklusif atau area pameran.\nAkses VIP dan undangan untuk acara khusus.',
                  'Deskripsi Event',
                  'Dokumentasi Acara',
                  'Kegiatan Events',
                  'Target Audiens',
                  'Paket Sponsorship',
                  'Demografi',
                  '- Umur: 15 - 40 Tahun\n- Latar belakang pendidikan di bidang teknik, ilmu komputer, desain, dan bisnis.\n- Tingkat pengalaman: pemula - profesional',
                  AssetImage('image/googleShow.jpg'),
                  AssetImage('image/google.png'),
                  AssetImage('image/google.png'),
                ),
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
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.fromLTRB(24, 15, 24, 15),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                backgroundColor: Color(0xFF1EAAFD),
                minimumSize: Size(800, 50),
              ),
              onPressed: () {},
              child: Text(
                "Ajukan kerja sama",
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
