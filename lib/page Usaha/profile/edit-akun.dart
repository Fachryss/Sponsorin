import 'package:flutter/material.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:sponsorin/page%20Usaha/profile/profile.dart';

class EditAkunUsaha extends StatefulWidget {
  const EditAkunUsaha({super.key});

  @override
  State<EditAkunUsaha> createState() => _EditAkunUsahaState();
}

class CustomBuild extends StatelessWidget {
  final String hintText;

  const CustomBuild({
    required this.hintText,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 25.0), // Add bottom margin here
      child: Stack(
        children: [
          TextField(
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
                borderSide: BorderSide(color: Color.fromRGBO(89, 89, 89, 100)),
              ),
              enabledBorder: const OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(6)),
                borderSide: BorderSide(color: Color.fromRGBO(89, 89, 89, 100)),
              ),
              focusedBorder: const OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(6)),
                borderSide: BorderSide(color: Colors.black87),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _EditAkunUsahaState extends State<EditAkunUsaha> {
  FocusNode focusNode = FocusNode();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(
          "Edit Profile Anda",
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
      body: Container(
        color: const Color.fromRGBO(244, 244, 244, 100),
        child: Padding(
          padding: EdgeInsets.fromLTRB(24, 20, 24, 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CustomBuild(hintText: 'Nama Usaha'),
              CustomBuild(hintText: ' Email'),
              IntlPhoneField(
                focusNode: focusNode,
                decoration: InputDecoration(
                  labelText: 'Nomor Telepon',
                  labelStyle: TextStyle(color: Colors.black45, fontSize: 15),
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
                initialCountryCode: 'ID', // Set default country to Indonesia
                languageCode: "IN",
                onChanged: (phone) {
                  print(phone.completeNumber);
                },
                onCountryChanged: (country) {
                  print('Country code changed to: ' + country.name);
                },
              ),
              CustomBuild(hintText: 'Alamat'),
            ],
          ),
        ),
      ),
      bottomNavigationBar: Container(
        margin: EdgeInsets.fromLTRB(
            24, 15, 24, 15), // Jarak dari samping kiri, kanan, dan bawah
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            padding: EdgeInsets.fromLTRB(20, 10, 20, 10),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            backgroundColor: Color(0xFF1EAAFD),
            minimumSize: Size(200, 50), // Ukuran minimum tombol
          ),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => ProfileUsaha()),
            );
          },
          child: Text(
            "Edit Profile",
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w600,
              fontSize: 18,
            ),
          ),
        ),
      ),
    );
  }
}
