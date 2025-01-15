import 'package:flutter/material.dart';
import 'package:sponsorin/main.dart';
import 'package:sponsorin/page%20EO/ai/AIGenerate.dart';
import 'package:sponsorin/page%20EO/profile/profile.dart';

class ProsesProposal extends StatefulWidget {
  const ProsesProposal({super.key});

  @override
  State<ProsesProposal> createState() => _ProsesProposalState();
}

class _ProsesProposalState extends State<ProsesProposal> {
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      Future.delayed(const Duration(seconds: 5), () {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => HomePage(role: 'EO')),
        );
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Color(0xFF1EAAFD),
        child: Center(
          child: Container(
            alignment: Alignment.center,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(24, 20, 24, 25),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset('image/mail-check.png'),
                  SizedBox(
                    height: 25,
                  ),
                  Text(
                    "Proposal anda berhasil dikirim kepada sponsor, tunggu kabar dari mereka.",
                    style: TextStyle(
                      fontSize: 17.8,
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                    ),
                    textAlign: TextAlign.center, // Center-align the text
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
