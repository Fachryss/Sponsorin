import 'package:flutter/material.dart';
import 'package:sponsorin/page%20EO/profile/edit-akun.dart';
import 'package:sponsorin/page%20Usaha/profile/edit-akun.dart';

class ProfileEO extends StatefulWidget {
  const ProfileEO({super.key});

  @override
  State<ProfileEO> createState() => _ProfileEOState();
}

class _ProfileEOState extends State<ProfileEO> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(
          "Profile",
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: Colors.black87,
          ),
        ),
        centerTitle: true,
      ),
      body: Container(
        height: MediaQuery.of(context).size.height,
        color: const Color.fromRGBO(244, 244, 244, 100),
        child: Padding(
          padding: EdgeInsets.fromLTRB(24, 20, 24, 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Column(
                  children: [
                    CircleAvatar(
                      radius: 50,
                      backgroundColor:
                          Colors.pink[100], // Background color of the avatar
                      child: CircleAvatar(
                        radius: 45,
                        // backgroundImage: AssetImage('assets/profile_image.png'), // Replace with your image
                      ),
                    ),
                    SizedBox(
                      height: 12,
                    ),
                    Text(
                      'Leanardo',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    Text(
                      'leanardo@gmail.com',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.black54,
                      ),
                    ),
                    SizedBox(
                      height: 100,
                    ),
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                        boxShadow: [
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
                            leading: Icon(
                              Icons.person_outline_rounded,
                              color: Color(0xFF1EAAFD),
                              size: 25,
                            ),
                            title: Text(
                              'Profile',
                              style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.black54),
                            ),
                            trailing: Icon(
                              Icons.arrow_forward_ios,
                              size: 18,
                              color: Color(0xFF1EAAFD),
                            ),
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => EditAkunEO(),
                                ),
                              );
                            },
                          ),
                          Divider(
                            color: Color.fromARGB(255, 231, 231, 231),
                          ),
                          ListTile(
                            leading: Icon(
                              Icons.history,
                              color: Color(0xFF1EAAFD),
                              size: 25,
                            ),
                            title: Text(
                              'History Event',
                              style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.black54),
                            ),
                            trailing: Icon(
                              Icons.arrow_forward_ios,
                              size: 18,
                              color: Color(0xFF1EAAFD),
                            ),
                            onTap: () {
                              // Navigate to history event
                            },
                          ),
                          Divider(
                            color: Color.fromARGB(255, 231, 231, 231),
                          ),
                          ListTile(
                            leading: Icon(
                              Icons.settings_outlined,
                              color: Color(0xFF1EAAFD),
                              size: 25,
                            ),
                            title: Text(
                              'Settings',
                              style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.black54),
                            ),
                            trailing: Icon(
                              Icons.arrow_forward_ios,
                              size: 18,
                              color: Color(0xFF1EAAFD),
                            ),
                            onTap: () {
                              // Navigate to settings
                            },
                          ),
                          Divider(
                            color: Color.fromARGB(255, 231, 231, 231),
                          ),
                          ListTile(
                            leading: Icon(
                              Icons.logout,
                              color: Color(0xFF1EAAFD),
                              size: 25,
                            ),
                            title: Text(
                              'Log Out',
                              style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.black54),
                            ),
                            trailing: Icon(
                              Icons.arrow_forward_ios,
                              size: 18,
                              color: Color(0xFF1EAAFD),
                            ),
                            onTap: () {
                              // Log out logic here
                            },
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
