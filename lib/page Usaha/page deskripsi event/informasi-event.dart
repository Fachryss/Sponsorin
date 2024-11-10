import 'package:flutter/material.dart';
import 'package:sponsorin/page%20EO/Page%20deskripsi%20usaha/review.dart';
import 'package:sponsorin/page%20Usaha/page%20deskripsi%20event/proposal-page.dart';
import 'package:sponsorin/page%20EO/page%20proses/proses-kerja-sama.dart';

class InfromasiEvent extends StatefulWidget {
  final Map<String, dynamic> eventData;

  const InfromasiEvent({
    Key? key,
    required this.eventData,
  }) : super(key: key);

  @override
  State<InfromasiEvent> createState() => _InfromasiEventState();
}

class _InfromasiEventState extends State<InfromasiEvent> {
  String selectedCategory = "overview";

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

  Widget titleEvent(String title, String category, String address, String phone) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 8),
        Text(
          category,
          style: TextStyle(
            fontSize: 16,
            color: Colors.black54,
          ),
        ),
        SizedBox(height: 8),
        Row(
          children: [
            Icon(Icons.location_on_outlined, color: Colors.black54),
            SizedBox(width: 8),
            Expanded(
              child: Text(
                address,
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.black54,
                ),
              ),
            ),
          ],
        ),
        SizedBox(height: 8),
        Row(
          children: [
            Icon(Icons.phone_outlined, color: Colors.black54),
            SizedBox(width: 8),
            Text(
              phone,
              style: TextStyle(
                fontSize: 16,
                color: Colors.black54,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget buildDescriptionCardEvent(
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
    ImageProvider imageOne,
    ImageProvider imageTwo,
    ImageProvider imageThree,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Deskripsi Event Section
        Text(
          title,
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 10),
        Text(
          descriptionOne,
          style: TextStyle(fontSize: 16, color: Colors.black87),
        ),
        SizedBox(height: 25),

        // Dokumentasi Section
        Text(
          titleTwo,
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 10),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Image(image: imageOne, width: 200, height: 150, fit: BoxFit.cover),
              ),
              SizedBox(width: 10),
              ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Image(image: imageTwo, width: 200, height: 150, fit: BoxFit.cover),
              ),
              SizedBox(width: 10),
              ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Image(image: imageThree, width: 200, height: 150, fit: BoxFit.cover),
              ),
            ],
          ),
        ),
        SizedBox(height: 25),

        // Kegiatan Events Section
        Text(
          titleThree,
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 10),
        Text(
          descriptionTwo,
          style: TextStyle(fontSize: 16, color: Colors.black87),
        ),
        SizedBox(height: 25),

        // Target Audiens Section
        Text(
          titleFour,
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 10),
        Text(
          descriptionThree,
          style: TextStyle(fontSize: 16, color: Colors.black87),
        ),
        SizedBox(height: 25),

        // Paket Sponsorship Section
        Text(
          titleFive,
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 10),
        Text(
          descriptionFour,
          style: TextStyle(fontSize: 16, color: Colors.black87),
        ),
        SizedBox(height: 25),

        // Demografi Section
        Text(
          titleSix,
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 10),
        Text(
          descriptionFive,
          style: TextStyle(fontSize: 16, color: Colors.black87),
        ),
      ],
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
        ImagePathThree,
      );
    } else if (selectedCategory == "reviews") {
      return buildReviewPage();
    } else if (selectedCategory == "Proposal") {
      return buildProposalCard();
    }
    return Container();
  }

  void _showParticipat(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Container(
          padding: EdgeInsets.fromLTRB(24, 15, 24, 15),
          height: 215,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(height: 10),
              Text(
                "Anda yakin ingin berpartisipasi menjadi sponsor untuk acara ini?",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 19,
                  fontWeight: FontWeight.w700,
                ),
              ),
              SizedBox(height: 25),
              Container(
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
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ProsesKerjaSama(),
                          ),
                        );
                      },
                      child: Text(
                        "Saya Yakin",
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
            ],
          ),
        );
      },
    );
  }

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
          color: const Color.fromRGBO(244, 244, 244, 100),
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
                      widget.eventData['imagePath'],
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
                        color: Colors.black54,
                      ),
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
                        color: Colors.black54,
                      ),
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
                  widget.eventData['title'],
                  widget.eventData['category'],
                  widget.eventData['address'],
                  widget.eventData['phoneNumber'],
                ),
                SizedBox(height: 25),
                _getContent(
                  selectedCategory,
                  widget.eventData['description'],
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
                  AssetImage(widget.eventData['dokumentasi'][0]),
                  AssetImage(widget.eventData['dokumentasi'][1]),
                  AssetImage(widget.eventData['dokumentasi'][2]),
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
              onPressed: () {
                _showParticipat(context);
              },
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