import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:pdf/pdf.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:printing/printing.dart';
import 'package:readmore/readmore.dart';
import 'package:sponsorin/page%20EO/ai/api_service.dart';
import 'package:sponsorin/page/api_service.dart';
import 'package:sponsorin/style/textstyle.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:markdown/markdown.dart' as md;
import 'package:loading_animation_widget/loading_animation_widget.dart';

class AIGenerate extends StatefulWidget {
  final Function(File) onProposalGenerated;

  const AIGenerate({super.key, required this.onProposalGenerated});

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
        String Varlama = _nameController.text;
        String filenameUpload =
            Varlama.replaceAll(RegExp(r'[<>:"/\\|?*]+'), '_')
                .replaceAll(' ', '_');

        // Truncate the filename if it's too long
        String truncatedFilename = filenameUpload.length > 1
            ? filenameUpload.substring(0, 50)
            : filenameUpload;

        final directory = await getApplicationDocumentsDirectory();
        final file = File('${directory.path}/$truncatedFilename.txt');
        await file.writeAsString(generatedProposal);

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
                  Navigator.of(context).pop(file);
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
  }

  String sanitizeFileName(String fileName) {
    // Ganti karakter yang tidak valid dengan underscore
    return fileName
        .replaceAll(RegExp(r'[<>:"/\\|?*]+'), '_')
        .replaceAll(' ', '_');
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
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(
          "AI Generate",
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
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Container(
              // color: Color.fromARGB(255, 244, 244, 244),
              child: Padding(
                padding: const EdgeInsets.fromLTRB(24, 20, 24, 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Harap Diisi dengan Data yang Akurat dan Benar",
                      style: CustomTextStyles.header,
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    CustomTextArea(
                        hintText: 'Nama dan tagline acara',
                        controller: _nameController,
                        maxlines: 1,
                        minWords: 12),
                    CustomTextArea(
                      hintText:
                          "Deskripsi acara (tema, tujuan, kegiatan utama, dll)",
                      maxlines: 5,
                      minWords: 100,
                      controller: _descriptionController,
                    ),
                    CustomTextArea(
                        hintText:
                            "Informasi mengenai audiens (usia, jenis kelamin, latar belakang pendidikan, dan ukuran audiens)",
                        controller: _infoController,
                        maxlines: 5,
                        minWords: 50),
                    CustomTextArea(
                        hintText:
                            'Daftar media yang digunakan untuk promosi (TV, radio, media sosial, dan situs web) dan perkiraan jangkauan',
                        controller: _mediaController,
                        maxlines: 5,
                        minWords: 50),
                    CustomTextArea(
                        hintText: 'Data demografi audiens',
                        controller: _demografisController,
                        maxlines: 5,
                        minWords: 50),
                    CustomTextArea(
                        hintText: 'Dampak acara kepada brand',
                        controller: _impactController,
                        maxlines: 5,
                        minWords: 100),
                    CustomTextArea(
                        hintText: 'Deskripsi tujuan bisnis sponsor',
                        controller: _purposeController,
                        maxlines: 5,
                        minWords: 50),
                    CustomTextArea(
                        hintText:
                            'Penjelasan bagaimana acara ini membantu sponsor mencapai tujuan bisnis',
                        controller: _howController,
                        maxlines: 5,
                        minWords: 50),
                    CustomTextArea(
                        hintText:
                            'Rincian mengenai struktur proposal (pengantar, detail acara, profil penyelenggara, opsi sponsorship, anggaran, dan call to action)',
                        controller: _detailController,
                        maxlines: 5,
                        minWords: 100),
                    CustomTextArea(
                        hintText: 'Paket sponsorship dan manfaatnya',
                        controller: _subscibtionController,
                        maxlines: 5,
                        minWords: 50),
                    Center(
                      child: TextButton(
                        onPressed:
                            _fillSimulationData, // Memanggil fungsi simulasi
                        child: Text(
                          'Isi dengan Data Simulasi',
                          style: TextStyle(color: Colors.blue, fontSize: 14),
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
              onPressed: _validateAndGenerate,
              child: Text(
                "Generate",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                ),
              ),
            ),
          ],
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
    return Container(
        margin: const EdgeInsets.only(bottom: 25.0),
        child: Stack(
          children: [
            TextField(
              controller: controller,
              maxLines: maxlines,
              decoration: InputDecoration(
                hintText: hintText,
                hintStyle: TextStyle(
                  color: Colors.black45,
                  fontSize: 15,
                ),
                contentPadding: const EdgeInsets.all(16),
                filled: true,
                fillColor: Colors.transparent,
                border: const OutlineInputBorder(
                  borderRadius: BorderRadius.zero,
                  borderSide:
                      BorderSide(color: Color.fromRGBO(89, 89, 89, 100)),
                ),
                enabledBorder: const OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(6)),
                  borderSide:
                      BorderSide(color: Color.fromRGBO(89, 89, 89, 100)),
                ),
                focusedBorder: const OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(6)),
                  borderSide: BorderSide(color: Colors.black87),
                ),
              ),
            ),
          ],
        ));
  }
}
