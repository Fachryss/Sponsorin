import 'package:flutter/material.dart';
import 'package:sponsorin/page%20EO/page%20home/custom-container-panjang.dart';
import 'package:sponsorin/page%20EO/page%20home/custom-container.dart';
import 'package:sponsorin/style/textstyle.dart';
import 'dart:math';

class Homepage extends StatefulWidget {
  const Homepage({super.key});

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  String selectedCategory = "Retail";

  // Data usaha berdasarkan kategori
  final Map<String, List<Map<String, String>>> businessData = {
    "Retail": [
      {
        "image": "image/ibox.png",
        "title": "iBox",
        "subtitle": "iBox adalah reseller premium Apple terkemuka di Indonesia."
      },
      {
        "image": "image/informa.png",
        "title": "Informa",
        "subtitle": "Retail Informa"
      },
    ],
    "Makanan": [
      {
        "image": "image/warungWareg.png",
        "title": "Warung Wareg",
        "subtitle":
            "Menawarkan makanan tradisional Indonesia dengan harga terjangkau"
      },
      {
        "image": "image/aqua.png",
        "title": "Aqua",
        "subtitle": "Aqua adalah air mineral yang sudah dikenal sejak lama"
      },
    ],
    "Jasa": [
      {
        "image": "image/hisana.jpeg",
        "title": "Hisana",
        "subtitle":
            "Hisana Fried Chicken adalah merek ayam goreng krispi buatan asli anak bangsa yang enaknya disuka di Indonesia."
      },
      {
        "image": "image/kfc-logo.png",
        "title": "KFC",
        "subtitle":
            "KFC (Kentucky Fried Chicken) adalah jaringan restoran cepat saji asal Amerika Serikat yang terkenal dengan ayam gorengnya."
      },
    ],
    // Tambahkan data untuk kategori lainnya
  };

  Widget _categoryButton(String text, bool isSelected, IconData icon) {
    return ElevatedButton(
      onPressed: () {
        setState(() {
          selectedCategory = text; // Update kategori yang dipilih
        });
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: isSelected ? Colors.blue : Colors.white,
        foregroundColor:
            isSelected ? Colors.white : Color.fromARGB(255, 109, 109, 109),
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(6),
        ),
      ),
      child: Row(
        children: [
          Icon(icon, size: 20),
          SizedBox(width: 5),
          Text(text,
              style: TextStyle(
                color: isSelected
                    ? Colors.white
                    : Color.fromARGB(255, 109, 109, 109),
                fontWeight: FontWeight.bold,
              ) // Optional: Customize font style
              ),
        ],
      ),
    );
  }

  List<Map<String, String>> getRandomBusinesses(int count) {
    List<Map<String, String>> allBusinesses = [];
    businessData.forEach((key, value) {
      allBusinesses.addAll(value);
    });
    allBusinesses.shuffle(Random());
    return allBusinesses.take(count).toList();
  }

  @override
  Widget build(BuildContext context) {
    List<Map<String, String>> recommendedBusinesses =
        businessData[selectedCategory] ?? [];
    List<Map<String, String>> otherBusinesses = getRandomBusinesses(6);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          Padding(
            padding: const EdgeInsets.only(
              right: 20,
            ), // Set the same right padding
            child: Container(
              // color: Colors.yellow,
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white,
              ),
              child: Icon(
                Icons.notifications_none_outlined,
                size: 30,
                color: Colors.black54,
              ),
            ),
          ),
        ],
        leading: Padding(
          padding: const EdgeInsets.only(left: 20), // Set the same left padding
          child: Container(
            width: 50,
            height: 50,
            child: Icon(
              Icons.account_circle_outlined,
              size: 40,
              color: Colors.black54,
            ),
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
          color: Color.fromRGBO(244, 244, 244, 100),
          child: Padding(
            padding: EdgeInsets.fromLTRB(24, 20, 24, 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const CustomText(
                  text: "Selamat Pagi Ryo",
                  style: CustomTextStyles.title,
                ),
                SizedBox(height: 5),
                const CustomText(
                    text: 'Ingin membuat event apa hari ini',
                    style: CustomTextStyles.subtitle),
                const SizedBox(height: 25),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      _categoryButton("Retail", selectedCategory == "Retail",
                          Icons.card_travel),
                      SizedBox(width: 15),
                      _categoryButton("Makanan", selectedCategory == "Makanan",
                          Icons.fastfood_outlined),
                      SizedBox(width: 15),
                      _categoryButton("Jasa", selectedCategory == "Jasa",
                          Icons.handyman_outlined),
                      SizedBox(width: 15),
                      _categoryButton(
                          "Kesehatan",
                          selectedCategory == "Kesehatan",
                          Icons.local_hospital_outlined),
                      SizedBox(width: 15),
                      _categoryButton(
                          "Pendidikan",
                          selectedCategory == "Pendidikan",
                          Icons.school_outlined),
                      SizedBox(width: 15),
                      _categoryButton("Hiburan", selectedCategory == "Hiburan",
                          Icons.park_outlined),
                    ],
                  ),
                ),
                SizedBox(height: 25),
                const CustomText(
                    text: "Rekomendasi usaha", style: CustomTextStyles.header),
                SizedBox(height: 15),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: recommendedBusinesses
                        .map((business) => Padding(
                              padding: const EdgeInsets.only(right: 20),
                              child: CustomContainerBerdiri(
                                  imagePath: business["image"]!,
                                  context: context),
                            ))
                        .toList(),
                  ),
                ),
                SizedBox(
                  height: 25,
                ),
                const CustomText(
                    text: "Usaha lainnya", style: CustomTextStyles.header),
                SizedBox(height: 15),
                Column(
                  children: otherBusinesses
                      .map((business) => Padding(
                            padding: const EdgeInsets.only(bottom: 15),
                            child: BuildContainerPanjang(business["image"]!,
                                business["title"]!, business["subtitle"]!),
                          ))
                      .toList(),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
