// Code A

import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:sponsorin/main.dart';
import 'package:sponsorin/page%20EO/page%20proses/proses-proposal.dart';
import 'package:uuid/uuid.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:file_picker/file_picker.dart';
import 'package:image_picker/image_picker.dart';

class FormEvent extends StatefulWidget {
  const FormEvent({super.key});

  @override
  State<FormEvent> createState() => _FormEventState();
}

class _FormEventState extends State<FormEvent> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final _formKey = GlobalKey<FormState>();
  String? phoneNumber;

  // Controllers for text fields
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _sponsorPurposeController =
      TextEditingController();
  final TextEditingController _subscriptionPackageController =
      TextEditingController();
  final TextEditingController _brandImpactController = TextEditingController();
  final TextEditingController _businessGoalsController =
      TextEditingController();
  final TextEditingController _categoryController = TextEditingController();
  final TextEditingController _eventHowController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _locationController = TextEditingController();
  final TextEditingController _tagController = TextEditingController();
  final TextEditingController _fileControllerLogo = TextEditingController();

  final List<String> _fileNamesLogo = [];

  // Controllers for file and list management
  final TextEditingController _fileControllerdokum = TextEditingController();
  final TextEditingController _fileControllerKegiatan = TextEditingController();
  final TextEditingController _fileControllerTargetAudiens =
      TextEditingController();
  final TextEditingController _fileControllerDemografiAudiens =
      TextEditingController();
  final TextEditingController _fileControllerSponsorsip =
      TextEditingController();
  final TextEditingController _fileControllerProposal = TextEditingController();

  // Lists for storing multiple items
  final List<String> _tags = [];
  final List<String> _fileNamesDocum = [];
  final List<String> _listKegiatanEvent = [];
  final List<String> _listTargetAudiens = [];
  final List<String> _listDemografiAudiens = [];
  final List<String> _listSponsorsip = [];

  final List<String> _suggestions = [
    "Musik",
    "Olahraga",
    "Seni & Budaya",
    "Bisnis & Budaya",
    "Bisnis & Teknologi",
    "Pendidikan"
  ];

  Future<String> _uploadFileToStorage(
      PlatformFile file, String fileType) async {
    final String uniqueFileName = '${const Uuid().v4()}_${file.name}';
    final Reference storageRef =
        FirebaseStorage.instance.ref().child(fileType).child(uniqueFileName);

    // Upload file to Firebase Storage
    await storageRef.putFile(File(file.path!));

    // Get file URL
    final String fileUrl = await storageRef.getDownloadURL();
    return fileUrl;
  }

  // File picking methods
  void _pickFileDokum() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles();
    if (result != null) {
      final file = result.files.single;
      final fileUrl = await _uploadFileToStorage(file, 'documentation');
      setState(() {
        _fileNamesDocum.add(file.name); // Simpan nama file alih-alih URL
        _fileControllerdokum.clear();
      });
    }
  }

  String? _fileNameProposal;

  // Existing methods...

  void _pickFileProposal() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf', 'docx'],
    );
    if (result != null) {
      final file = result.files.single;
      final fileExtension = file.extension?.toLowerCase();
      if (fileExtension == 'pdf' || fileExtension == 'docx') {
        final fileUrl = await _uploadFileToStorage(file, 'proposal');
        setState(() {
          _fileNameProposal = file.name; // Simpan nama file
          _fileControllerProposal.text =
              file.name; // Simpan URL ke Firestore nanti
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text('Please upload a file in PDF or Word format.')),
        );
      }


  void _pickFileLogo() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles();
    if (result != null) {
      final fileUrl = await _uploadFileToStorage(result.files.single, 'logo');
      setState(() {
        _fileNamesLogo.add(fileUrl); // Simpan URL ke Firestore nanti
        _fileControllerLogo.clear();
      });
    }
  }

  void _addFileNameLogo() {
    if (_fileControllerLogo.text.isNotEmpty) {
      setState(() {
        _fileNamesLogo.add(_fileControllerLogo.text);
        _fileControllerLogo.clear();
      });
    }
  }

  void _removeFileNameLogo(String fileName) {
    setState(() {
      _fileNamesLogo.remove(fileName);
    });
  }


    }
  }

  // List management methods
  void _addFileNameDocum() {
    if (_fileControllerdokum.text.isNotEmpty) {
      setState(() {
        _fileNamesDocum.add(_fileControllerdokum.text);
        _fileControllerdokum.clear();
      });
    }
  }

  void _addKegiatanEvent() {
    if (_fileControllerKegiatan.text.isNotEmpty) {
      setState(() {
        _listKegiatanEvent.add(_fileControllerKegiatan.text);
        _fileControllerKegiatan.clear();
      });
    }
  }

  void _addTargetAudiens() {
    if (_fileControllerTargetAudiens.text.isNotEmpty) {
      setState(() {
        _listTargetAudiens.add(_fileControllerTargetAudiens.text);
        _fileControllerTargetAudiens.clear();
      });
    }
  }

  void _addDemografiAudiens() {
    if (_fileControllerDemografiAudiens.text.isNotEmpty) {
      setState(() {
        _listDemografiAudiens.add(_fileControllerDemografiAudiens.text);
        _fileControllerDemografiAudiens.clear();
      });
    }
  }

  void _addSponsorsip() {
    if (_fileControllerSponsorsip.text.isNotEmpty) {
      setState(() {
        _listSponsorsip.add(_fileControllerSponsorsip.text);
        _fileControllerSponsorsip.clear();
      });
    }
  }

  // Remove methods for lists
  void _removeFileNameDocum(String fileName) {
    setState(() {
      _fileNamesDocum.remove(fileName);
    });
  }

  void _removeKegiatanEvent(String item) {
    setState(() {
      _listKegiatanEvent.remove(item);
    });
  }

  void _removeTargetAudiens(String item) {
    setState(() {
      _listTargetAudiens.remove(item);
    });
  }

  void _removeDemografiAudiens(String item) {
    setState(() {
      _listDemografiAudiens.remove(item);
    });
  }

  void _removeSponsorsip(String item) {
    setState(() {
      _listSponsorsip.remove(item);
    });
  }

  // Submit method
  Future<void> _submitEvent() async {
    try {
      if (!_formKey.currentState!.validate()) {
        throw Exception('Please fill in all required fields');
      }

      final User? currentUser = _auth.currentUser;
      if (currentUser == null) {
        throw Exception('No user logged in');
      }

      final String eventId = 'EventID_${const Uuid().v4().substring(0, 8)}';

      final Map<String, dynamic> eventData = {
        'EO_ID': currentUser.uid,
        'name': _nameController.text,
        'sponsorPurpose': _sponsorPurposeController.text,
        'subscriptionPackage':
            int.tryParse(_subscriptionPackageController.text) ?? 0,
        'targetAudience': _listTargetAudiens,
        'contact': phoneNumber,
        'brandImpact': _brandImpactController.text,
        'businessGoals': _businessGoalsController.text,
        'category': _categoryController.text,
        'demographics': _listDemografiAudiens,
        'description': _descriptionController.text,
        'document': _fileNamesDocum,
        'proposalURL': _fileControllerProposal.text,
        'eventActivities': _listKegiatanEvent,
        'eventHow': _eventHowController.text,
        'image': '',
        'location': _locationController.text,
        'media': [],
        'createdAt': FieldValue.serverTimestamp(),
        'tags': _tags,
      };

      await _firestore.collection('Event').doc(eventId).set(eventData);

      // ScaffoldMessenger.of(context).showSnackBar(
      //   const SnackBar(content: Text('Event berhasil ditambahkan!')),
      // );

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const ProsesProposal()),
      );

      // Future.delayed(const Duration(seconds: 5), () {
      //   Navigator.pushReplacement(
      //     context,
      //     MaterialPageRoute(builder: (context) => HomePage(role: 'EO',)),
      //   );
      // });
    } catch (e) {
      print('Error submitting event: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: ${e.toString()}')),
      );
    }
  }

  // Build UI components
  Widget buildTextAdderTextField({
    required TextEditingController controller,
    required VoidCallback onAddText,
    required String Title,
  }) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        hintText: Title,
        suffixIcon: IconButton(
          icon: Icon(
            Icons.add_circle,
            color: Color(0xFF1EAAFD),
          ),
          onPressed: onAddText,
        ),
        hintStyle: TextStyle(
          color: Colors.black45,
          fontSize: 15,
        ),
        enabledBorder: const OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(6)),
          borderSide: BorderSide(color: Color.fromRGBO(89, 89, 89, 1)),
        ),
        focusedBorder: const OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(6)),
          borderSide: BorderSide(color: Colors.black87),
        ),
      ),
    );
  }

  Widget buildTextList({
    required List<String> texts,
    required Function(String) onRemove,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: texts.map((text) {
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 4.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(child: Text(text)),
              IconButton(
                icon: const Icon(Icons.close, color: Colors.red),
                onPressed: () => onRemove(text),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Add Event"),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // buildTextAdderTextField(controller: _nameController, onAddText: , Title: '')
              TextFormField(
                controller: _nameController,
                decoration: InputDecoration(
                  hintText: 'Nama event',
                  hintStyle: TextStyle(
                    color: Colors.black45,
                    fontSize: 15,
                  ),
                  enabledBorder: const OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(6)),
                    borderSide:
                        BorderSide(color: Color.fromRGBO(89, 89, 89, 1)),
                  ),
                  focusedBorder: const OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(6)),
                    borderSide: BorderSide(color: Colors.black87),
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter event name';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              TextFormField(
                controller: _locationController,
                decoration: InputDecoration(
                  hintText: 'Lokasi event',
                  hintStyle: TextStyle(
                    color: Colors.black45,
                    fontSize: 15,
                  ),
                  enabledBorder: const OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(6)),
                    borderSide:
                        BorderSide(color: Color.fromRGBO(89, 89, 89, 1)),
                  ),
                  focusedBorder: const OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(6)),
                    borderSide: BorderSide(color: Colors.black87),
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter location';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              IntlPhoneField(
                decoration: InputDecoration(
                  labelText: 'Nomor telepon',
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
                initialCountryCode: 'ID',
                onChanged: (phone) {
                  phoneNumber = phone.completeNumber;
                },
              ),
              const SizedBox(height: 16),

              TextFormField(
                controller: _descriptionController,
                maxLines: null,
                decoration: InputDecoration(
                  hintText: "Deskripsi event",
                  hintStyle: TextStyle(
                    color: Colors.black45,
                    fontSize: 15,
                  ),
                  contentPadding: const EdgeInsets.all(16),
                  filled: true,
                  fillColor: Colors.transparent,
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
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter description';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // Tags
              TextField(
                controller: _tagController,
                onChanged: (text) {
                  setState(() {});
                },
                decoration: InputDecoration(
                  hintText: 'Tags event',
                  hintStyle: const TextStyle(
                    color: Colors.black45,
                    fontSize: 15,
                  ),
                  contentPadding: const EdgeInsets.all(16),
                  filled: true,
                  fillColor: Colors.transparent,
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
              ),
              SizedBox(height: 10),
              Wrap(
                spacing: 8.0,
                children: _tags
                    .map((tag) => Chip(
                          label: Text(tag),
                          labelStyle: TextStyle(color: Colors.white),
                          backgroundColor: Colors.blue,
                          deleteIcon: Icon(
                            Icons.remove_circle_outline_sharp,
                            color: Colors.white,
                            size: 20,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(18),
                            side: BorderSide(color: Colors.white),
                          ),
                          onDeleted: () {
                            setState(() {
                              _tags.remove(tag);
                            });
                          },
                        ))
                    .toList(),
              ),
              if (_tagController.text.isNotEmpty)
                Wrap(
                  spacing: 8.0,
                  children: _suggestions
                      .where((tag) => tag
                          .toLowerCase()
                          .contains(_tagController.text.toLowerCase()))
                      .map((tag) => GestureDetector(
                            onTap: () {
                              setState(() {
                                if (!_tags.contains(tag)) _tags.add(tag);
                                _tagController.clear();
                              });
                            },
                            child: Chip(
                              label: Text(tag),
                              labelStyle: TextStyle(color: Colors.white),
                              backgroundColor: Colors.blue,
                              deleteIcon: Icon(
                                Icons.remove_circle_outline_sharp,
                                color: Colors.white,
                                size: 20,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(18),
                                side: BorderSide(color: Colors.white),
                              ),
                            ),
                          ))
                      .toList(),
                ),
              const SizedBox(height: 16),

              buildTextAdderTextField(
                controller: _fileControllerKegiatan,
                onAddText: _addKegiatanEvent,
                Title: "Kegiatan event",
              ),
              buildTextList(
                texts: _listKegiatanEvent,
                onRemove: _removeKegiatanEvent,
              ),
              const SizedBox(height: 16),

              buildTextAdderTextField(
                controller: _fileControllerTargetAudiens,
                onAddText: _addTargetAudiens,
                Title: "Target audiens",
              ),
              buildTextList(
                texts: _listTargetAudiens,
                onRemove: _removeTargetAudiens,
              ),
              const SizedBox(height: 16),

              buildTextAdderTextField(
                controller: _fileControllerDemografiAudiens,
                onAddText: _addDemografiAudiens,
                Title: "Demografi audiens",
              ),
              buildTextList(
                texts: _listDemografiAudiens,
                onRemove: _removeDemografiAudiens,
              ),
              const SizedBox(height: 16),

              buildTextAdderTextField(
                controller: _fileControllerSponsorsip,
                onAddText: _addSponsorsip,
                Title: "Paket sponsorsip",
              ),
              buildTextList(
                texts: _listSponsorsip,
                onRemove: _removeSponsorsip,
              ),
              const SizedBox(height: 16),

              // File upload fields
              TextField(
                controller: _fileControllerdokum,
                readOnly: true,
                onTap: _pickFileDokum,
                decoration: InputDecoration(
                  hintText: "Dokumentasi event",
                  suffixIcon: IconButton(
                    icon: Icon(
                      Icons.add_circle,
                      color: Color(0xFF1EAAFD),
                    ),
                    onPressed: _addFileNameDocum,
                  ),
                  hintStyle: TextStyle(
                    color: Colors.black45,
                    fontSize: 15,
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
              ),
              SizedBox(height: 10),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: _fileNamesDocum.map((fileName) {
                  return fileName.isNotEmpty
                      ? Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(fileName), // Tampilkan nama file
                            IconButton(
                              icon: Icon(Icons.cancel, color: Colors.red),
                              onPressed: () {
                                setState(() {
                                  _fileNamesDocum.remove(fileName);
                                });
                              },
                            ),
                          ],
                        )
                      : Container(); // Return an empty container if fileName is empty
                }).toList(),
              ),
              // TextField(
              //   controller: _fileControllerdokum,
              //   readOnly: true,
              //   onTap: _pickFileDokum,
              //   decoration: InputDecoration(
              //     hintText: "Dokumentasi event",
              //     suffixIcon: IconButton(
              //       icon: Icon(
              //         Icons.add_circle,
              //         color: Color(0xFF1EAAFD),
              //       ),
              //       onPressed: _addFileNameDocum,
              //     ),
              //     hintStyle: TextStyle(
              //       color: Colors.black45,
              //       fontSize: 15,
              //     ),
              //     enabledBorder: const OutlineInputBorder(
              //       borderRadius: BorderRadius.all(Radius.circular(6)),
              //       borderSide:
              //           BorderSide(color: Color.fromRGBO(89, 89, 89, 100)),
              //     ),
              //     focusedBorder: const OutlineInputBorder(
              //       borderRadius: BorderRadius.all(Radius.circular(6)),
              //       borderSide: BorderSide(color: Colors.black87),
              //     ),
              //   ),
              // ),
              const SizedBox(height: 16),

              TextField(
                readOnly: true,
                onTap: _pickFileProposal,
                controller: _fileControllerProposal,
                decoration: InputDecoration(
                  hintText: "Proposal event",
                  suffixIcon: IconButton(
                    icon: Icon(
                      Icons.file_upload_outlined,
                      color: Color(0xFF1EAAFD),
                    ),
                    onPressed: _pickFileProposal,
                  ),
                  hintStyle: TextStyle(
                    color: Colors.black45,
                    fontSize: 15,
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
              ),

              TextFormField(
                controller: _fileControllerLogo,
                readOnly: true,
                decoration: InputDecoration(
                  labelText: 'Logo',
                  border: const OutlineInputBorder(),
                  suffixIcon: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.upload_file),
                        onPressed: _pickFileLogo,
                      ),
                    ],
                  ),
                ),
              ),
              buildTextList(
                texts: _fileNamesLogo,
                onRemove: _removeFileNameLogo,
              ),

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
            _submitEvent();
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => ProsesProposal()),
            );
          },
          child: Text(
            "Tambahkan Event",
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w600,
              fontSize: 18,
            ),
          ),
        ),
      ),
      // bottomNavigationBar: Padding(
      //   padding: const EdgeInsets.all(16.0),
      //   child: ElevatedButton(
      //     onPressed: _submitEvent,
      //     style: ElevatedButton.styleFrom(
      //       backgroundColor: const Color(0xFF1EAAFD),
      //       padding: const EdgeInsets.symmetric(vertical: 16),
      //     ),
      //     child: const Text(
      //       'Submit Event',
      //       style: TextStyle(fontSize: 18),
      //     ),
      //   ),
      // ),
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _sponsorPurposeController.dispose();
    _subscriptionPackageController.dispose();
    _brandImpactController.dispose();
    _businessGoalsController.dispose();
    _categoryController.dispose();
    _eventHowController.dispose();
    _descriptionController.dispose();
    _locationController.dispose();
    super.dispose();
  }
}
