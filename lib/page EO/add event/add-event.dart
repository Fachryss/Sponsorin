import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:sponsorin/page%20EO/add%20event/form-detail-event.dart';
import 'package:sponsorin/page%20EO/page%20home/custom-container-panjang.dart';
import 'package:sponsorin/style/textstyle.dart';
import 'package:intl/intl.dart';


class AddEvent extends StatefulWidget {
  const AddEvent({super.key});

  @override
  State<AddEvent> createState() => _AddEventState();
}

class _AddEventState extends State<AddEvent> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  Stream<QuerySnapshot>? _eventsStream;

  @override
  void initState() {
    super.initState();
    _initializeEventStream();
  }

  void _initializeEventStream() {
    final currentUser = _auth.currentUser;
    if (currentUser != null) {
      _eventsStream = _firestore
          .collection('Event')
          .where('EO_ID', isEqualTo: currentUser.uid)
          .snapshots();
    }
  }

  // Helper function to validate and process image URL
  String processImageUrl(String? imageUrl) {
    if (imageUrl == null || imageUrl.isEmpty) {
      return 'https://via.placeholder.com/150';
    }

    if (!imageUrl.startsWith('https://firebasestorage.googleapis.com')) {
      return 'https://via.placeholder.com/150';
    }

    return imageUrl;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromRGBO(244, 244, 244, 100),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 20),
            child: Container(
              width: 50,
              height: 50,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white,
              ),
              child: const Icon(
                Icons.notifications_none_outlined,
                size: 30,
                color: Colors.black54,
              ),
            ),
          ),
        ],
        leading: Padding(
          padding: const EdgeInsets.only(left: 20),
          child: const SizedBox(
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
      floatingActionButton: SizedBox(
        width: 60,
        height: 60,
        child: FloatingActionButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => FormEvent()),
            );
          },
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: const Icon(
            Icons.add,
            color: Colors.white,
            size: 35,
          ),
          backgroundColor: Colors.blue,
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(24, 20, 24, 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const CustomText(
                text: 'Daftar event yang anda buat',
                style: CustomTextStyles.header,
              ),
              const SizedBox(height: 20),
              StreamBuilder<QuerySnapshot>(
                stream: _eventsStream,
                builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
                  if (snapshot.hasError) {
                    return const Text('Terjadi kesalahan saat memuat data');
                  }

                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                    return const Center(
                      child: Text('Belum ada event yang dibuat'),
                    );
                  }

                  return Column(
                    children: snapshot.data!.docs.map((DocumentSnapshot document) {
                      Map<String, dynamic> data = document.data()! as Map<String, dynamic>;
                      String validImageUrl = processImageUrl(data['image']);

                      return Padding(
                        padding: const EdgeInsets.only(bottom: 15),
                        child: BuildContainerPanjang(
                          context: context,
                          imagePath: validImageUrl,
                          title: data['name'] ?? 'Untitled Event',
                          sub: 'Dibuat: ${data['createdAt'] != null ? DateFormat('dd MMMM yyyy').format((data['createdAt'] as Timestamp).toDate()) : 'No creation date available'}',
                          category: data['category'] ?? 'Uncategorized',
                          address: data['address'] ?? 'No address specified',
                          description: data['eventHow'] ?? 'No data available',
                        ),
                      );
                    }).toList(),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
