import 'package:flutter/material.dart';
import 'package:sponsorin/page%20EO/Page%20deskripsi%20usaha/informasi-usaha.dart';
import 'package:sponsorin/page%20Usaha/page%20deskripsi%20event/informasi-event.dart';

Widget CustomContainerBerdiri({
  required BuildContext context, 
  required String imagePath,
  required String title,
  required String category,
  required String address,
  required String description,
  
  }) {
  return GestureDetector(
    onTap: () {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => InfromasiEvent(
            eventData: {
              'imagePath': imagePath,
              'title': title,
              'category': category,
              'description': description,
              'address': address,
              'phoneNumber': '+62 853-3573-3052', // You might want to add this to your data model
              'dokumentasi': [
                'image/googleShow.jpg',
                'image/google.png',
                'image/google.png'
              ],
            },
          ),
        ),
      );
    },
    child: Container(
    padding: EdgeInsets.all(20),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(10),
    ),
    child: Column(
      children: [
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
          ),
          width: 180,
          height: 200,
          margin: EdgeInsets.all(7),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(8.0),
            child: Image.network(
              imagePath,
              fit: BoxFit.cover,
            ),
          ),
        ),
        SizedBox(height: 8),
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.blue,
            foregroundColor: Colors.white,
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(6),
            ),
          ),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => InformasiUsaha(businessName: title, category: category, address: address, description: description, imagePath: imagePath,)),
            );
          },
          child: Text(
            "Ajukan kerja sama",
            style: TextStyle(fontWeight: FontWeight.w600, fontSize: 15),
          ),
        ),
      ],
    ),
  )
  ); 
}
