import 'package:flutter/material.dart';
import 'package:sponsorin/page/api_service.dart';
import 'package:sponsorin/style/textstyle.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:path_provider/path_provider.dart';
import 'dart:io';

class AIGenerate extends StatefulWidget {
  const AIGenerate({super.key});

  @override
  State<AIGenerate> createState() => _AIGenerateState();
}

class _AIGenerateState extends State<AIGenerate> {
  // Controller untuk mengatur teks yang diinput
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _infoController = TextEditingController();
  final TextEditingController _mediaController = TextEditingController();
  final TextEditingController _demografisController = TextEditingController();
  final TextEditingController _impactController = TextEditingController();
  final TextEditingController _purposeController = TextEditingController();
  final TextEditingController _howController = TextEditingController();
  final TextEditingController _detailController = TextEditingController();
  final TextEditingController _subscibtionController = TextEditingController();

  Future<void> _validateAndGenerate() async {
    bool isValid = true;
    String errorMessage = '';

    // Validate each field
    // if (_nameController.text.split(' ').length < 2) {
    //   isValid = false;
    //   errorMessage +=
    //       'Nama dan tagline acara harus memiliki minimal 12 kata.\n';
    // }
    // if (_descriptionController.text.split(' ').length < 10) {
    //   isValid = false;
    //   errorMessage += 'Deskripsi acara harus memiliki minimal 100 kata.\n';
    // }
    // if (_infoController.text.split(' ').length < 5) {
    //   isValid = false;
    //   errorMessage +=
    //       'Informasi mengenai audiens harus memiliki minimal 50 kata.\n';
    // }
    // if (_mediaController.text.split(' ').length < 5) {
    //   isValid = false;
    //   errorMessage += 'Daftar media promosi harus memiliki minimal 50 kata.\n';
    // }
    // if (_demografisController.text.split(' ').length < 5) {
    //   isValid = false;
    //   errorMessage +=
    //       'Data demografi audiens harus memiliki minimal 50 kata.\n';
    // }
    // if (_impactController.text.split(' ').length < 10) {
    //   isValid = false;
    //   errorMessage +=
    //       'Dampak acara kepada brand harus memiliki minimal 100 kata.\n';
    // }
    // if (_purposeController.text.split(' ').length < 5) {
    //   isValid = false;
    //   errorMessage +=
    //       'Deskripsi tujuan bisnis sponsor harus memiliki minimal 50 kata.\n';
    // }
    // if (_howController.text.split(' ').length < 5) {
    //   isValid = false;
    //   errorMessage +=
    //       'Penjelasan bagaimana acara membantu sponsor harus memiliki minimal 50 kata.\n';
    // }
    // if (_detailController.text.split(' ').length < 10) {
    //   isValid = false;
    //   errorMessage +=
    //       'Rincian struktur proposal harus memiliki minimal 100 kata.\n';
    // }
    // if (_subscibtionController.text.split(' ').length < 5) {
    //   isValid = false;
    //   errorMessage +=
    //       'Paket sponsorship dan manfaatnya harus memiliki minimal 50 kata.\n';
    // }

    if (isValid) {
      // Call API or process data
      print('All fields are valid');
      String generatedProposal = await ApiService.generateProposal(
        eventName: _nameController.text,
        eventDescription: _descriptionController.text,
        audienceInfo: _infoController.text,
        mediaList: _mediaController.text,
        demographics: _demografisController.text,
        brandImpact: _impactController.text,
        sponsorPurpose: _purposeController.text,
        eventHow: _howController.text,
        proposalDetail: _detailController.text,
        subscriptionPackage: _subscibtionController.text,
      );
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('Generated Proposal'),
          content: SingleChildScrollView(child: Text(generatedProposal)),
          actions: [
            TextButton(
              child: Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('Save as PDF'),
              onPressed: () async {
                Navigator.of(context).pop();
                await _generatePDF(generatedProposal);
              },
            ),
          ],
        ),
      );
    } else {
      // Show error message
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('Validation Error'),
          content: Text(errorMessage),
          actions: [
            TextButton(
              child: Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        ),
      );
    }
  }

  Future<void> _generatePDF(String content) async {
    final pdf = pw.Document();

    pdf.addPage(
      pw.Page(
        build: (pw.Context context) => pw.Center(
          child: pw.Text(content, style: pw.TextStyle(fontSize: 12)),
        ),
      ),
    );

    try {
      final directory = await getApplicationDocumentsDirectory();
      final file = File('${directory.path}/proposal.pdf');
      await file.writeAsBytes(await pdf.save());
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Proposal berhasil disimpan di: ${file.path}')),
      );
    } catch (e) {
      print(e);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Gagal membuat PDF')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final width = size.width;
    final height = size.height;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          "AI Generate",
          style: CustomTextStyles.appBar, // Gaya teks appbar
        ),
        elevation: 0,
        centerTitle: true,
        backgroundColor: Color.fromARGB(255, 244, 244, 244),
        leading: IconButton(
          iconSize: 20,
          icon: Icon(Icons.arrow_back_ios, color: Colors.black),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
          color: Color.fromARGB(255, 244, 244, 244),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(24, 20, 24, 0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Harap Diisi dengan Data yang Akurat dan Benar",
                  style: CustomTextStyles.header,
                ),
                const SizedBox(
                  height: 30,
                ),
                CustomTextArea(
                    hintText: 'Nama dan tagline acara',
                    controller: _nameController,
                    maxlines: 1,
                    minWords: 12),
                const SizedBox(
                  height: 12,
                ),
                CustomTextArea(
                  hintText:
                      "Deskripsi acara (tema, tujuan, kegiatan utama, dll)",
                  maxlines: 5,
                  minWords: 100,
                  controller: _descriptionController,
                ),
                const SizedBox(height: 12),
                CustomTextArea(
                    hintText:
                        "Informasi mengenai audiens (usia, jenis, kelamin, latar belakang pendidikan dan ukuran audiens)",
                    controller: _infoController,
                    maxlines: 5,
                    minWords: 50),
                const SizedBox(height: 12),
                CustomTextArea(
                    hintText:
                        'Daftar media yang digunakan untuk promosi (TV, radio, media sosial, dan situs web) dan perkiraan jangkauan',
                    controller: _mediaController,
                    maxlines: 5,
                    minWords: 50),
                const SizedBox(height: 12),
                CustomTextArea(
                    hintText: 'Data demografi audiens',
                    controller: _demografisController,
                    maxlines: 5,
                    minWords: 50),
                const SizedBox(height: 12),
                CustomTextArea(
                    hintText: 'Dampak acara kepada brand',
                    controller: _impactController,
                    maxlines: 5,
                    minWords: 100),
                const SizedBox(height: 12),
                CustomTextArea(
                    hintText: 'Deskripsi tujuan bisnis sponsor',
                    controller: _purposeController,
                    maxlines: 5,
                    minWords: 50),
                const SizedBox(height: 12),
                CustomTextArea(
                    hintText:
                        'Penjelasan bagaimana acara ini membantu sponsor mencapai tujuan bisnis',
                    controller: _howController,
                    maxlines: 5,
                    minWords: 50),
                const SizedBox(height: 12),
                CustomTextArea(
                    hintText:
                        'Rincian mengenai struktur proposal (pengantar, detail acara, profil penyelenggara, opsi sponsorship, anggaran, dan call to action)',
                    controller: _detailController,
                    maxlines: 5,
                    minWords: 100),
                const SizedBox(height: 12),
                CustomTextArea(
                    hintText: 'Paket sponsorship dan manfaatnya',
                    controller: _subscibtionController,
                    maxlines: 5,
                    minWords: 50),
                const SizedBox(height: 72),
                Center(
                    child: ElevatedButton(
                  onPressed: _validateAndGenerate,
                  child: Text(
                    "Generate",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    primary: Colors.blue,
                    padding: EdgeInsets.symmetric(
                        horizontal: width / 4, vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                )),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// Komponen Text Input: Text Area

class CustomTextArea extends StatelessWidget {
  final String hintText;
  final TextEditingController controller;
  final int maxlines;
  final int minWords;

  const CustomTextArea({
    required this.hintText,
    required this.controller,
    required this.maxlines,
    required this.minWords,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        TextField(
          controller: controller,
          maxLines: maxlines,
          decoration: InputDecoration(
            hintText: hintText,
            hintStyle: CustomTextStyles.hint,
            contentPadding: const EdgeInsets.all(16),
            filled: true,
            fillColor: Color.fromARGB(255, 244, 244, 244),
            border: const OutlineInputBorder(
              borderRadius: BorderRadius.zero,
              borderSide: BorderSide.none,
            ),
            enabledBorder: const OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(4)),
              borderSide: BorderSide(
                color: Color.fromARGB(89, 89, 89, 100),
                width: 0.5,
              ),
            ),
            focusedBorder: const OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(4)),
              borderSide: BorderSide(
                color: Color.fromARGB(255, 85, 85, 85),
                width: 0.5,
              ),
            ),
          ),
        ),
        Positioned(
          right: 16,
          bottom: 8,
          child: Text(
            '*Minimal $minWords kata',
            style: TextStyle(
              fontSize: 10,
              color: Color.fromRGBO(89, 89, 89, 100),
            ),
          ),
        ),
      ],
    );
  }
}
