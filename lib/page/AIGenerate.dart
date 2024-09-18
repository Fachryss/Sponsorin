import 'package:flutter/material.dart';
import 'package:sponsorin/style/textstyle.dart';

class AIGenerate extends StatefulWidget {
  const AIGenerate({super.key});

  @override
  State<AIGenerate> createState() => _AIGenerateState();
}

class _AIGenerateState extends State<AIGenerate> {
  // Controller untuk mengatur teks yang diinput
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "AI Generate",
          style: CustomTextStyles.appBar, // Gaya teks appbar
        ),
        elevation: 0,
        centerTitle: true,
        backgroundColor: Color.fromARGB(255, 244, 244, 244),
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, color: Colors.black),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
          color: Color.fromARGB(255, 244, 244, 244),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(24, 30, 24, 0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Harap Diisi dengan Data yang Akurat dan Benar",
                  style: CustomTextStyles.header,
                ),
                const SizedBox(
                  height: 30,
                ),
                CustomTextArea(
                    hintText: 'Nama dan tagline acara',
                    controller: _nameController,
                    maxlines: 1,
                    minWords: 12),
                const SizedBox(height: 12,),
                CustomTextArea(
                  hintText:
                      "Deskripsi acara (tema, tujuan, kegiatan utama, dll)",
                  maxlines: 5,
                  minWords: 100,
                  controller: _descriptionController,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// Komponen Text Input: Text Area

class CustomTextArea extends StatelessWidget {
  final String hintText;
  final TextEditingController controller;
  final int maxlines;
  final int minWords;

  const CustomTextArea({
    required this.hintText,
    required this.controller,
    required this.maxlines,
    required this.minWords,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        TextField(
          controller: controller,
          maxLines: maxlines,
          decoration: InputDecoration(
            hintText: hintText,
            hintStyle: CustomTextStyles.hint,
            contentPadding: const EdgeInsets.all(16),
            filled: true,
            fillColor: Color.fromARGB(255, 244, 244, 244),
            border: const OutlineInputBorder(
              borderRadius: BorderRadius.zero,
              borderSide: BorderSide.none,
            ),
            enabledBorder: const OutlineInputBorder(
              borderRadius: BorderRadius.zero,
              borderSide: BorderSide(
                color: Colors.black,
                width: 1.0,
              ),
            ),
            focusedBorder: const OutlineInputBorder(
              borderRadius: BorderRadius.zero,
              borderSide: BorderSide(
                color: Colors.black,
                width: 1.0,
              ),
            ),
          ),
        ),
        Positioned(
          right: 16,
          bottom: 8,
          child: Text(
            '*Minimal $minWords kata',
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey,
            ),
          ),
        ),
      ],
    );
  }
}
