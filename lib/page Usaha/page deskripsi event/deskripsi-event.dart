import 'package:flutter/material.dart';

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
  ImageProvider ImagePathOne,
  ImageProvider ImagePathTwo,
  ImageProvider ImagePathThree,
) {
  return Container(
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
        ),
        SizedBox(
          height: 10,
        ),
        Text(
          descriptionOne,
          textAlign: TextAlign.justify,
          style: TextStyle(fontSize: 14, color: Colors.black54),
        ),
        SizedBox(
          height: 25,
        ),
        Text(
          titleTwo,
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
        ),
        SizedBox(
          height: 10,
        ),
        Center(
          child: Container(
            height: 396,
            width: 360,
            child: PageView(
              children: [
                Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.transparent, width: 2),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(16),
                    child: Image(image: ImagePathOne, fit: BoxFit.cover),
                  ),
                ),
                Image(image: ImagePathTwo, fit: BoxFit.cover),
                Image(image: ImagePathThree, fit: BoxFit.cover),
              ],
            ),
          ),
        ),
        SizedBox(
          height: 25,
        ),
        Text(
          titleThree,
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
        ),
        SizedBox(
          height: 10,
        ),
        Text(
          descriptionTwo,
          textAlign: TextAlign.justify,
          style: TextStyle(fontSize: 14, color: Colors.black54),
        ),
        SizedBox(
          height: 25,
        ),
        Text(
          titleFour,
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
        ),
        SizedBox(
          height: 10,
        ),
        Text(
          descriptionThree,
          textAlign: TextAlign.justify,
          style: TextStyle(fontSize: 14, color: Colors.black54),
        ),
        SizedBox(
          height: 25,
        ),
        Text(
          titleFive,
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
        ),
        SizedBox(
          height: 10,
        ),
        Text(
          descriptionFour,
          textAlign: TextAlign.justify,
          style: TextStyle(fontSize: 14, color: Colors.black54),
        ),
        SizedBox(
          height: 25,
        ),
        Text(
          titleSix,
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
        ),
        SizedBox(
          height: 10,
        ),
        Text(
          descriptionFive,
          textAlign: TextAlign.justify,
          style: TextStyle(fontSize: 14, color: Colors.black54),
        )
      ],
    ),
  );
}
