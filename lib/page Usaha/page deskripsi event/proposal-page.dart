import 'package:flutter/material.dart';

Widget buildProposalCard() {
  return Container(
    height: 70,
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(12),
    ),
    child: Center(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            height: 55,
            width: 55,
            padding: EdgeInsets.fromLTRB(9, 11, 9, 11),
            margin: EdgeInsets.fromLTRB(8, 7, 8, 7),
            decoration: BoxDecoration(
              color: Colors.grey[100],
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              Icons.picture_as_pdf,
              color: Colors.blue,
              size: 32,
            ),
          ),
          Expanded(
            child: Text(
              'Proposal Google I/O Extendeds Surabaya',
              style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                  color: Colors.black87),
              overflow: TextOverflow.ellipsis,
            ),
          ),
          IconButton(
            onPressed: () {},
            icon: Icon(
              Icons.file_download_outlined,
              size: 30,
              color: Colors.blue,
            ),
          )
        ],
      ),
    ),
  );
}
