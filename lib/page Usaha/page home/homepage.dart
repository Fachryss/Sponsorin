import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:sponsorin/page%20Usaha/page%20home/custom-container-panjang-event.dart';
import 'package:sponsorin/page%20EO/page%20home/custom-container.dart';
import 'package:sponsorin/style/textstyle.dart';
import 'dart:math';
import 'package:sponsorin/page%20Usaha/page%20deskripsi%20event/informasi-event.dart';


class HomepageUsaha extends StatefulWidget {
  const HomepageUsaha({super.key});

  @override
  State<HomepageUsaha> createState() => _HomepageUsahaState();
}

class _HomepageUsahaState extends State<HomepageUsaha> {
  String selectedCategory = "Musik";
  bool isLoading = true;
  String? error;
  String userName = "User"; // Default username
  Map<String, List<Map<String, String>>> eventData = {};

  @override
  void initState() {
    super.initState();
    fetchUserName();
    fetchDataFromFirestore();
  }

  // Fetch the name field from Firestore
  Future<void> fetchUserName() async {
    try {
      String uid = FirebaseAuth.instance.currentUser!.uid;
      DocumentSnapshot userDoc = await FirebaseFirestore.instance.collection('users').doc(uid).get();
      
      setState(() {
        userName = userDoc['name'] ?? 'User';
      });
    } catch (e) {
      print("Error fetching user name: $e");
      setState(() {
        userName = 'User';
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

  Future<void> fetchDataFromFirestore() async {
    try {
      QuerySnapshot querySnapshot =
          await FirebaseFirestore.instance.collection('Event').get();
      print("Data fetched from Firestore: ${querySnapshot.docs.length} documents");

      for (var doc in querySnapshot.docs) {
        var eventData = doc.data() as Map<String, dynamic>;
        print("Event data: $eventData");

        List<String> categories = getCategoriesFromField(eventData['category']);
        String image = eventData['image'] ?? "";
        String name = eventData['name'] ?? "";
        String description = eventData['description'] ?? "";

        Map<String, String> eventEntry = {
          "image": image,
          "title": name,
          "description": description,
          "category": categories.join(', '),
        };

        for (String category in categories) {
          if (this.eventData.containsKey(category)) {
            this.eventData[category]!.add(eventEntry);
          } else {
            this.eventData[category] = [eventEntry];
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
        foregroundColor: isSelected ? Colors.white : Color.fromARGB(255, 109, 109, 109),
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
              color: isSelected ? Colors.white : Color.fromARGB(255, 109, 109, 109),
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  List<Map<String, String>> getRandomEvents(int count) {
    List<Map<String, String>> allEvents = [];
    eventData.forEach((key, value) {
      allEvents.addAll(value);
    });

    allEvents = allEvents.toSet().toList();
    allEvents.shuffle(Random());
    return allEvents.take(count).toList();
  }

  @override
  Widget build(BuildContext context) {
    List<Map<String, String>> recommendedEvents =
        eventData[selectedCategory] ?? [];
    List<Map<String, String>> otherEvents = getRandomEvents(6);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
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
      body: SingleChildScrollView(
        child: Container(
          color: Color.fromRGBO(244, 244, 244, 100),
          child: Padding(
            padding: EdgeInsets.fromLTRB(24, 20, 24, 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CustomText(
                  text: getGreeting() + " $userName",
                  style: CustomTextStyles.title,
                ),
                SizedBox(height: 5),
                const CustomText(
                  text: 'Ingin sponsorin event apa hari ini?',
                  style: CustomTextStyles.subtitle
                ),
                const SizedBox(height: 25),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      _categoryButton("Musik", selectedCategory == "Musik", Icons.music_note_outlined),
                      SizedBox(width: 15),
                      _categoryButton("Olahraga", selectedCategory == "Olahraga", Icons.sports_basketball_outlined),
                      SizedBox(width: 15),
                      _categoryButton("Seni & Budaya", selectedCategory == "Seni & Budaya", Icons.sports_gymnastics_outlined),
                      SizedBox(width: 15),
                      _categoryButton("Bisnis & Budaya", selectedCategory == "Bisnis & Budaya", Icons.business_outlined),
                      SizedBox(width: 15),
                      _categoryButton("Bisnis & Teknologi", selectedCategory == "Bisnis & Teknologi", Icons.computer_outlined),
                      SizedBox(width: 15),
                      _categoryButton("Pendidikan", selectedCategory == "Pendidikan", Icons.school_outlined),
                    ],
                  ),
                ),
                SizedBox(height: 25),
                const CustomText(
                  text: "Rekomendasi events",
                  style: CustomTextStyles.header
                ),
                SizedBox(height: 15),
                if (isLoading)
                  Center(child: CircularProgressIndicator())
                else if (error != null)
                  Center(child: Text('Error: $error'))
                else if (recommendedEvents.isEmpty)
                  Center(child: Text('No events found for this category'))
                else
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: recommendedEvents
                          .map((event) => Padding(
                                padding: const EdgeInsets.only(right: 20),
                                child: CustomContainerBerdiri(
                                  imagePath: event["image"]!,
                                  context: context,
                                  title: event["title"]!,
                                  category: event["category"]!,
                                  description: event["description"]!,
                                  address: "", // Remove if not needed
                                ),
                              ))
                          .toList(),
                    ),
                  ),
                SizedBox(height: 25),
                const CustomText(
                  text: "Events lainnya",
                  style: CustomTextStyles.header
                ),
                SizedBox(height: 15),
                if (otherEvents.isEmpty)
                  Center(child: Text('No other events available'))
                else
                  Column(
                    children: otherEvents
                        .map((event) => Padding(
                              padding: const EdgeInsets.only(bottom: 15),
                              child: BuildContainerPanjangEvent(
                                context: context,
                                imagePath: event["image"]!,
                                title: event["title"]!,
                                date: "Upcoming", // You might want to add date to your schema
                                time: "TBA", // You might want to add time to your schema
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