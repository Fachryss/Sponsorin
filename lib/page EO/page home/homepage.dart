import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:sponsorin/page%20EO/page%20home/custom-container-panjang.dart';
import 'package:sponsorin/page%20EO/page%20home/custom-container.dart';
import 'package:sponsorin/style/textstyle.dart';
import 'dart:math';

class HomepageEO extends StatefulWidget {
  const HomepageEO({super.key});

  @override
  State<HomepageEO> createState() => _HomepageEOState();
}

class _HomepageEOState extends State<HomepageEO> {
  String selectedCategory = "Retail";
  bool isLoading = true;
  String? error;

  Map<String, List<Map<String, String>>> businessData = {};

  @override
  void initState() {
    super.initState();
    fetchDataFromFirestore();
  }

  // Helper function to handle category conversion
  List<String> getCategoriesFromField(dynamic categoryField) {
    if (categoryField is String) {
      return [categoryField];
    } else if (categoryField is List) {
      return categoryField.map((e) => e.toString()).toList();
    }
    return ['Unknown'];
  }

  // Updated fetch function to handle both String and List categories
  Future<void> fetchDataFromFirestore() async {
    try {
      QuerySnapshot querySnapshot =
          await FirebaseFirestore.instance.collection('Companies').get();
      print("Data fetched from Firestore: ${querySnapshot.docs.length} documents");

      for (var doc in querySnapshot.docs) {
        var companyData = doc.data() as Map<String, dynamic>;
        print("Company data: $companyData");

        // Get all categories for this company
        List<String> categories = getCategoriesFromField(companyData['category']);
        
        // Company details
        String image = companyData['image'] ?? "";
        String name = companyData['name'] ?? "";
        String subtitle = companyData['subtitle'] ?? "";
        String description = companyData['description'] ?? "";
        String address = companyData['location'] ?? "";

        // Create business entry
        Map<String, String> businessEntry = {
          "image": image,
          "title": name,
          "subtitle": subtitle,
          "description": description,
          "address": address,
          "category": categories.join(', '), // Join multiple categories for display
        };

        // Add the business entry to each of its categories
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
        error = e.toString();
        isLoading = false;
      });
    }
  }

  Widget _categoryButton(String text, bool isSelected, IconData icon) {
    return ElevatedButton(
      onPressed: () {
        setState(() {
          selectedCategory = text;
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

  List<Map<String, String>> getRandomBusinesses(int count) {
    List<Map<String, String>> allBusinesses = [];
    businessData.forEach((key, value) {
      allBusinesses.addAll(value);
    });
    
    // Remove duplicates based on title
    allBusinesses = allBusinesses.toSet().toList();
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
                CustomText(
                  text: getGreeting() +
                      " Ryo", // Menggunakan fungsi getGreeting()
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
                  // scrollDirection: Axis.horizontal,
                  child: Row(
                    children: recommendedBusinesses
                        .map((business) => Padding(
                              padding: const EdgeInsets.only(right: 20),
                              child: CustomContainerBerdiri(
                                imagePath: business["image"]!,
                                context: context,
                                title: business["title"]!,
                                category: business["category"] ?? 'Unknown',
                                address: business["address"]!,
                                description: business["description"]!,
                              ),
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
                            child: BuildContainerPanjang(
                              context:
                                  context, // Pass the context for navigation
                              imagePath: business["image"]!,
                              title: business["title"]!,
                              sub: business["subtitle"]!,
                              category: business["category"] ??
                                  'Unknown', // Use ?? for default value
                              address: business["address"]!,
                              description: business["description"]!,
                            ),
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

  String getGreeting() {
    var hour = DateTime.now().hour;

    if (hour >= 5 && hour < 12) {
      return 'Selamat Pagi';
    } else if (hour >= 12 && hour < 15) {
      return 'Selamat Siang';
    } else if (hour >= 15 && hour < 18) {
      return 'Selamat Sore';
    } else {
      return 'Selamat Malam';
    }
  }
}
