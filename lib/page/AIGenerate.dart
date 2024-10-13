import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:pdf/pdf.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:printing/printing.dart';
import 'package:sponsorin/page/api_service.dart';
import 'package:sponsorin/style/textstyle.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:markdown/markdown.dart' as md;
import 'package:loading_animation_widget/loading_animation_widget.dart';

class AIGenerate extends StatefulWidget {
  const AIGenerate({super.key});

  @override
  State<AIGenerate> createState() => _AIGenerateState();
}

class _AIGenerateState extends State<AIGenerate> {
  bool _isLoading = false;
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

  // Fungsi untuk mengisi semua input dengan data simulasi
  void _fillSimulationData() {
    _nameController.text =
        '32nd Anniversary Moklet: Go Global, Achieve Excellence';
    _descriptionController.text =
        '32nd Anniversary of Moklet adalah perayaan tahunan yang diselenggarakan oleh SMK Telkom Malang untuk memperingati ulang tahun sekolah. Acara ini bertujuan untuk mempromosikan keunggulan dalam pendidikan teknologi dan informatika serta mendukung siswa dalam mengembangkan kreativitas di bidang akademik dan non-akademik.';
    _infoController.text =
        'Audiens terdiri dari siswa, alumni, guru, dan masyarakat umum dengan usia antara 15-50 tahun. Mayoritas audiens memiliki latar belakang pendidikan di bidang teknologi dan informatika.';
    _mediaController.text =
        'Promosi dilakukan melalui media sosial (Instagram, YouTube, Facebook), serta melalui situs web resmi sekolah.';
    _demografisController.text =
        'Usia: 15-50 tahun, Jenis Kelamin: Laki-laki dan Perempuan, Pendidikan: SMA/SMK hingga Sarjana.';
    _impactController.text =
        'Acara ini memberikan dampak yang positif kepada brand sponsor melalui eksposur media sosial dan liputan langsung di situs web sekolah.';
    _purposeController.text =
        'Meningkatkan citra brand sponsor di kalangan generasi muda dan mendorong partisipasi aktif dalam acara teknologi.';
    _howController.text =
        'Acara ini membantu sponsor dengan menargetkan audiens yang sesuai dengan demografi yang diinginkan sponsor, serta mempromosikan produk secara langsung.';
    _detailController.text =
        'Proposal ini berisi pengantar tentang acara, rincian struktur acara, profil penyelenggara, opsi sponsorship, anggaran, dan call to action.';
    _subscibtionController.text =
        'Paket Platinum: Rp 50.000.000, Paket Gold: Rp 25.000.000, Paket Silver: Rp 10.000.000.';
  }

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
      setState(() {
        _isLoading = true;
      });

      try {
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

        setState(() {
          _isLoading = false;
        });

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
      } catch (e) {
        setState(() {
          _isLoading = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error generating proposal: $e')),
        );
      }
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

  Future<void> _debugGenerate() async {
    String debugProposal = '''
      # Debug Proposal

      ## Event Details
      **Name:** ${_nameController.text}
      **Description:** ${_descriptionController.text}

      ## Audience Information
      ${_infoController.text}

      ## Media and Promotion
      ${_mediaController.text}

      ## Demographics
      ${_demografisController.text}

      ## Impact on Brand
      ${_impactController.text}

      ## Sponsor's Business Objectives
      ${_purposeController.text}

      ## How the Event Helps Sponsors
      ${_howController.text}

      ## Proposal Structure
      ${_detailController.text}

      ## Sponsorship Packages
      ${_subscibtionController.text}

      ---
      This is a debug proposal generated for testing purposes.
          ''';

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Generated Proposal'),
        content: SingleChildScrollView(child: Text(debugProposal)),
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
              await _generatePDF(debugProposal);
            },
          ),
        ],
      ),
    );
  }

  String sanitizeFileName(String fileName) {
    // Ganti karakter yang tidak valid dengan underscore
    return fileName
        .replaceAll(RegExp(r'[<>:"/\\|?*]+'), '_')
        .replaceAll(' ', '_');
  }

  Future<void> _generatePDF(String content) async {
    try {
      // Meminta izin penyimpanan secara runtime
      var status = await Permission.storage.request();
      if (status.isDenied || status.isPermanentlyDenied) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Storage permission is required to save PDF')),
        );
        return;
      }

      // Buat dokumen PDF
      final pdf = pw.Document();

      final astNodes = md.Document().parse(content);

      pdf.addPage(
        pw.MultiPage(
          build: (pw.Context context) => _buildPdfWidgets(astNodes),
        ),
      );

      await Printing.layoutPdf(
        onLayout: (PdfPageFormat format) async => pdf.save(),
      );

      // Ambil nama dari _nameController dan sanitasi
      String eventName = _nameController.text.isNotEmpty
          ? sanitizeFileName(_nameController.text)
          : "event";

      // Tambahkan 3 digit angka acak
      String randomNumber = Random()
          .nextInt(900)
          .toString()
          .padLeft(3, '0'); // 3 digit angka acak
      String fileName = '${eventName}_$randomNumber.pdf';

      // Simpan file ke folder Documents
      if (Platform.isAndroid) {
        // Mendapatkan direktori Documents untuk Android
        Directory? directory = Directory('/storage/emulated/0/Documents');

        // Buat direktori jika belum ada
        if (!await directory.exists()) {
          await directory.create(recursive: true);
          print('Directory created: ${directory.path}'); // Debug log
        }

        String path = '${directory.path}/$fileName';
        final File file = File(path);
        await file.writeAsBytes(await pdf.save());

        // Log debug
        print('PDF saved to: $path'); // Debug log
        print('File name: $fileName'); // Debug log

        // Menampilkan pesan bahwa file sudah tersimpan
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('PDF saved to $path')),
        );
      } else {
        // Penanganan untuk iOS
        final directory = await getApplicationDocumentsDirectory();
        String path = '${directory.path}/$fileName';
        final File file = File(path);
        await file.writeAsBytes(await pdf.save());

        // Log debug
        print('PDF saved to: $path'); // Debug log
        print('File name: $fileName'); // Debug log

        // Menampilkan pesan bahwa file sudah tersimpan
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('PDF saved to $path')),
        );
      }
    } catch (e) {
      print('Error saving PDF: $e'); // Log error
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error saving PDF: $e')),
      );
    }

    // // Mendapatkan direktori dokumen pengguna
    // Directory? documentDirectory = await getExternalStorageDirectory();
    // String eventName =
    //     _nameController.text.isNotEmpty ? _nameController.text : "event";
    // String randomNumber = Random().nextInt(100000).toString();
    // String path =
    //     '${documentDirectory?.path}/Documents/sponsorin/${eventName}_${randomNumber}.pdf';

    // final pdf = pw.Document();

    // pdf.addPage(
    //   pw.Page(
    //     build: (pw.Context context) => pw.Center(
    //       child: pw.Text(content),
    //     ),
    //   ),
    // );

    // // Membuat direktori sponsorin jika belum ada
    // Directory sponsorinDirectory =
    //     Directory('${documentDirectory?.path}/Documents/sponsorin');
    // if (!await sponsorinDirectory.exists()) {
    //   await sponsorinDirectory.create(recursive: true);
    // }

    // // Menyimpan PDF
    // final File file = File(path);
    // await file.writeAsBytes(await pdf.save());

    // // Memberi tahu pengguna bahwa file telah disimpan
    // ScaffoldMessenger.of(context).showSnackBar(
    //   SnackBar(content: Text('PDF disimpan di $path')),
    // );
  }

  pw.Widget _convertMarkdownToPDF(String markdownData) {
    final List<String> lines = markdownData.split('\n');
    List<pw.Widget> pdfWidgets = [];

    for (var line in lines) {
      if (line.startsWith('# ')) {
        // H1
        pdfWidgets.add(
          pw.Header(level: 1, text: line.replaceFirst('# ', '')),
        );
      } else if (line.startsWith('## ')) {
        // H2
        pdfWidgets.add(
          pw.Header(level: 2, text: line.replaceFirst('## ', '')),
        );
      } else if (line.startsWith('**')) {
        // Bold text
        pdfWidgets.add(
          pw.Text(line.replaceAll('**', ''),
              style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
        );
      } else if (line.isNotEmpty) {
        // Normal paragraph
        pdfWidgets.add(
          pw.Paragraph(text: line),
        );
      }
    }

    return pw.Column(children: pdfWidgets);
  }

  List<pw.Widget> _buildPdfWidgets(List<md.Node> nodes) {
    List<pw.Widget> widgets = [];
    for (var node in nodes) {
      if (node is md.Element) {
        switch (node.tag) {
          case 'h1':
            widgets.add(pw.Header(
              level: 0,
              child: pw.Text(node.textContent,
                  style: pw.TextStyle(
                      fontSize: 24, fontWeight: pw.FontWeight.bold)),
            ));
            break;
          case 'h2':
            widgets.add(pw.Header(
              level: 1,
              child: pw.Text(node.textContent,
                  style: pw.TextStyle(
                      fontSize: 20, fontWeight: pw.FontWeight.bold)),
            ));
            break;
          case 'h3':
            widgets.add(pw.Header(
              level: 2,
              child: pw.Text(node.textContent,
                  style: pw.TextStyle(
                      fontSize: 18, fontWeight: pw.FontWeight.bold)),
            ));
            break;
          case 'p':
            widgets.add(pw.Paragraph(text: node.textContent));
            break;
          case 'ul':
            widgets.add(pw.ListView(
              children: node.children
                      ?.map((child) =>
                          pw.Bullet(text: (child as md.Element).textContent))
                      .toList() ??
                  [],
            ));
            break;
          case 'ol':
            int index = 1;
            widgets.add(pw.ListView(
              children: node.children
                      ?.map((child) => pw.Paragraph(
                          text:
                              "${index++}. ${(child as md.Element).textContent}"))
                      .toList() ??
                  [],
            ));
            break;
          case 'blockquote':
            widgets.add(pw.Container(
              color: PdfColors.grey200,
              padding: pw.EdgeInsets.all(10),
              child: pw.Text(node.textContent,
                  style: pw.TextStyle(fontStyle: pw.FontStyle.italic)),
            ));
            break;
          case 'code':
            widgets.add(pw.Container(
              color: PdfColors.grey200,
              padding: pw.EdgeInsets.all(5),
              child: pw.Text(node.textContent,
                  style: pw.TextStyle(font: pw.Font.courier())),
            ));
            break;
          case 'hr':
            widgets.add(pw.Divider());
            break;
          default:
            widgets.add(pw.Paragraph(text: node.textContent));
        }
      } else if (node is md.Text) {
        widgets.add(pw.Paragraph(text: node.text));
      }
    }
    return widgets;
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
      body: Stack(
        children: [
          SingleChildScrollView(
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
                            "Informasi mengenai audiens (usia, jenis kelamin, latar belakang pendidikan, dan ukuran audiens)",
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
                    const SizedBox(height: 16),
                    Center(
                      child: TextButton(
                        onPressed: _fillSimulationData, // Memanggil fungsi simulasi
                        child: Text(
                          'Isi dengan Data Simulasi',
                          style: TextStyle(color: Colors.blue, fontSize: 14),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Center(
                      child: ElevatedButton(
                        onPressed: _debugGenerate,
                        child: Text(
                          "Debug Generate",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          if (_isLoading)
            Container(
              color: Colors.black.withOpacity(0.5),
              child: Center(
                child: LoadingAnimationWidget.staggeredDotsWave(
                  color: Colors.white,
                  size: 50,
                ),
              ),
            ),
        ],
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
                color: Colors.black,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
