import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:sponsorin/page%20Usaha/profile/edit-akun.dart';

class ProfileUsaha extends StatefulWidget {
  const ProfileUsaha({super.key});

  @override
  State<ProfileUsaha> createState() => _ProfileUsahaState();
}

class _ProfileUsahaState extends State<ProfileUsaha> {
  String name = "";
  String email = "";
  String imageUrl = "";
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchUserData();
  }

  // Fungsi untuk mengambil data dari Firestore
  Future<void> fetchUserData() async {
    try {
      // Mendapatkan uid pengguna yang sedang login
      User? user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        String uid = user.uid;
        email = user.email ?? "";

        // Mengambil data dari Firestore
        DocumentSnapshot<Map<String, dynamic>> snapshot =
            await FirebaseFirestore.instance.collection('Companies').doc(uid).get();

        if (snapshot.exists) {
          setState(() {
            name = snapshot.data()?['name'] ?? "No Name";
            imageUrl = snapshot.data()?['image'] ?? "";
            isLoading = false;
          });
        } else {
          setState(() {
            name = "No Data";
            isLoading = false;
          });
        }
      }
    } catch (e) {
      print("Error fetching user data: $e");
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text(
          "Profile",
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: Colors.black87,
          ),
        ),
        centerTitle: true,
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : Container(
              height: MediaQuery.of(context).size.height,
              color: const Color.fromRGBO(244, 244, 244, 100),
              child: Padding(
                padding: const EdgeInsets.fromLTRB(24, 20, 24, 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                      child: Column(
                        children: [
                          CircleAvatar(
                            radius: 50,
                            backgroundColor: Colors.pink[100],
                            child: CircleAvatar(
                              radius: 45,
                              backgroundImage: imageUrl.isNotEmpty
                                  ? NetworkImage(imageUrl)
                                  : null,
                              child: imageUrl.isEmpty
                                  ? const Icon(Icons.person, size: 50)
                                  : null,
                            ),
                          ),
                          const SizedBox(height: 12),
                          Text(
                            name,
                            style: const TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(height: 5),
                          Text(
                            email,
                            style: const TextStyle(
                              fontSize: 16,
                              color: Colors.black54,
                            ),
                          ),
                          const SizedBox(height: 100),
                          Container(
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(10),
                              boxShadow: const [
                                BoxShadow(
                                  color: Color.fromARGB(255, 231, 231, 231),
                                  blurRadius: 2,
                                  spreadRadius: 1,
                                ),
                              ],
                            ),
                            child: Column(
                              children: [
                                ListTile(
                                  leading: const Icon(
                                    Icons.person_outline_rounded,
                                    color: Color(0xFF1EAAFD),
                                    size: 25,
                                  ),
                                  title: const Text(
                                    'Profile',
                                    style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.w500,
                                        color: Colors.black54),
                                  ),
                                  trailing: const Icon(
                                    Icons.arrow_forward_ios,
                                    size: 18,
                                    color: Color(0xFF1EAAFD),
                                  ),
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => EditAkunUsaha(),
                                      ),
                                    );
                                  },
                                ),
                                const Divider(),
                                ListTile(
                                  leading: const Icon(
                                    Icons.history,
                                    color: Color(0xFF1EAAFD),
                                    size: 25,
                                  ),
                                  title: const Text(
                                    'History Event',
                                    style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.w500,
                                        color: Colors.black54),
                                  ),
                                  trailing: const Icon(
                                    Icons.arrow_forward_ios,
                                    size: 18,
                                    color: Color(0xFF1EAAFD),
                                  ),
                                ),
                                const Divider(),
                                ListTile(
                                  leading: const Icon(
                                    Icons.settings_outlined,
                                    color: Color(0xFF1EAAFD),
                                    size: 25,
                                  ),
                                  title: const Text(
                                    'Settings',
                                    style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.w500,
                                        color: Colors.black54),
                                  ),
                                ),
                                const Divider(),
                                ListTile(
                                  leading: const Icon(
                                    Icons.logout,
                                    color: Color(0xFF1EAAFD),
                                    size: 25,
                                  ),
                                  title: const Text(
                                    'Log Out',
                                    style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.w500,
                                        color: Colors.black54),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}
