import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:sponsorin/page%20EO/page%20home/custom-container-panjang.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  String selectedCategory = "All";
  String _searchQuery = "";
  bool isLoading = true;
  Map<String, List<Map<String, String>>> businessData = {};

  @override
  void initState() {
    super.initState();
    fetchDataFromFirestore();
  }

  Future<void> fetchDataFromFirestore() async {
    try {
      QuerySnapshot querySnapshot =
          await FirebaseFirestore.instance.collection('Companies').get();
      for (var doc in querySnapshot.docs) {
        var companyData = doc.data() as Map<String, dynamic>;
        List<String> categories = getCategoriesFromField(companyData['category']);

        Map<String, String> businessEntry = {
          "image": companyData['image'] ?? "",
          "title": companyData['name'] ?? "",
          "subtitle": companyData['subtitle'] ?? "",
          "description": companyData['description'] ?? "",
          "address": companyData['location'] ?? "",
          "category": categories.join(', '),
        };

        for (String category in categories) {
          if (businessData.containsKey(category)) {
            businessData[category]!.add(businessEntry);
          } else {
            businessData[category] = [businessEntry];
          }
        }
      }

      setState(() {
        isLoading = false;
      });
    } catch (e) {
      print("Error fetching data from Firestore: $e");
      setState(() {
        isLoading = false;
      });
    }
  }

  List<String> getCategoriesFromField(dynamic categoryField) {
    if (categoryField is String) {
      return [categoryField];
    } else if (categoryField is List) {
      return categoryField.map((e) => e.toString()).toList();
    }
    return ['Unknown'];
  }

  Widget _categoryButton(String text, bool isSelected, IconData icon) {
    return ElevatedButton(
      onPressed: () {
        setState(() {
          selectedCategory = text;
          _searchQuery = "";
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
          Text(
            text,
            style: TextStyle(
              color: isSelected
                  ? Colors.white
                  : Color.fromARGB(255, 109, 109, 109),
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    List<Map<String, String>> displayedBusinesses = [];

    if (_searchQuery.isNotEmpty) {
      displayedBusinesses = businessData.values
          .expand((list) => list)
          .where((business) {
            return business["title"]!
                .toLowerCase()
                .contains(_searchQuery.toLowerCase());
          })
          .toList();
    } else if (selectedCategory == "All") {
      displayedBusinesses = businessData.values.expand((list) => list).toList();
    } else {
      displayedBusinesses = businessData[selectedCategory] ?? [];
    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromRGBO(244, 244, 244, 100),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 20),
            child: Container(
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
          padding: const EdgeInsets.only(left: 20),
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
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : Padding(
              padding: EdgeInsets.fromLTRB(24, 20, 24, 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextField(
                    onChanged: (value) {
                      setState(() {
                        _searchQuery = value;
                      });
                    },
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.white,
                      hintText: 'Cari perusahaan di sini',
                      hintStyle: TextStyle(
                        color: Colors.black54,
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                      prefixIcon: Icon(
                        Icons.search,
                        color: Color(0xFF539DF3),
                        size: 26,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide.none,
                      ),
                      contentPadding: EdgeInsets.symmetric(vertical: 15),
                    ),
                  ),
                  SizedBox(height: 25),
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: [
                        _categoryButton("All", selectedCategory == "All",
                            Icons.all_inclusive),
                        SizedBox(width: 15),
                        _categoryButton("Retail", selectedCategory == "Retail",
                            Icons.card_travel),
                        SizedBox(width: 15),
                        _categoryButton("Makanan", selectedCategory == "Makanan",
                            Icons.fastfood_outlined),
                        SizedBox(width: 15),
                        _categoryButton("Jasa", selectedCategory == "Jasa",
                            Icons.handyman_outlined),
                        SizedBox(width: 15),
                        _categoryButton("Kesehatan", selectedCategory == "Kesehatan",
                            Icons.local_hospital_outlined),
                        SizedBox(width: 15),
                        _categoryButton("Pendidikan", selectedCategory == "Pendidikan",
                            Icons.school_outlined),
                        SizedBox(width: 15),
                        _categoryButton("Hiburan", selectedCategory == "Hiburan",
                            Icons.park_outlined),
                      ],
                    ),
                  ),
                  SizedBox(height: 25),
                  Expanded(
                    child: ListView.builder(
                      itemCount: displayedBusinesses.length,
                      itemBuilder: (context, index) {
                        final business = displayedBusinesses[index];
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 15),
                          child: BuildContainerPanjang(
                            context: context,
                            imagePath: business["image"]!,
                            title: business["title"]!,
                            sub: business["subtitle"]!,
                            category: business["category"] ?? 'Unknown',
                            address: business["address"] ?? 'Unknown',
                            description: business["description"] ??
                                'No description available',
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}
