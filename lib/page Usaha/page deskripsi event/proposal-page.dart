import 'package:flutter/material.dart';

Widget buildProposalCard() {
  return Container(
    height: 70,
    decoration: BoxDecoration(
      color: Colors.red,
      borderRadius: BorderRadius.circular(12),
    ),
    child: Center(
      child: Row(
        children: [
          Container(
              height: 55,
              width: 55,
              padding: EdgeInsets.fromLTRB(9, 11, 9, 11),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.picture_as_pdf,
                    color: Colors.blue,
                    size: 32,
                  ),
                  Text('Proposal Google I/O Extended Surabaya ')
                ],
              ))
        ],
      ),
    ),
  );
}
