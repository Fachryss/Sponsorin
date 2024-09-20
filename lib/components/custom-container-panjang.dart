import 'package:flutter/material.dart';

Widget BuildContainerPanjang(String imagePath, String Title, String Sub) {
  return Column(
    children: [
      Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.all(Radius.circular(15)),
        ),
        child: Row(
          children: [
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(8)),
              ),
              width: 120,
              height: 80,
              margin: EdgeInsets.all(7),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8.0),
                child: Image.asset(
                  imagePath,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            SizedBox(
              width: 15,
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    Title,
                    style: TextStyle(
                      color: Color.fromRGBO(0, 0, 0, 70),
                      fontFamily: 'Poppins',
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  Text(
                    Sub,
                    style: TextStyle(
                      color: Color.fromRGBO(0, 0, 0, 70),
                      fontFamily: 'Poppins',
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                    maxLines: 2, // Atur jumlah baris maksimal
                    overflow: TextOverflow.ellipsis, // Tambahkan overflow
                  ),
                ],
              ),
            ),
            SizedBox(
              width: 15,
            ),
            Icon(
              Icons.arrow_forward_ios,
              color: Color.fromRGBO(30, 170, 253, 100),
              size: 20,
            ),
          ],
        ),
      ),
    ],
  );
}
