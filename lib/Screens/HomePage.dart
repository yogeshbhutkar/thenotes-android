import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:thenotes/components/storageAPI.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';

import 'pdf_viewer_page.dart';

late User loggedIn;

class HomePage extends StatefulWidget {
  static String id = "Homepage";
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late Future<ListResult> futureFiles;
  final _auth = FirebaseAuth.instance;
  @override
  void initState() {
    getCurrentUser();
    super.initState();
    futureFiles = FirebaseStorage.instance.ref('/').listAll();
    print(futureFiles);
  }

  void getCurrentUser() {
    try {
      final user = _auth.currentUser;
      if (user != null) {
        loggedIn = user;
      }
    } catch (e) {
      //
    }
  }

  ImageProvider img() {
    if (loggedIn.photoURL.toString().isNotEmpty) {
      return NetworkImage(loggedIn.photoURL.toString());
    } else {
      return const AssetImage('images/man.png');
    }
  }

  String greet() {
    final hour = TimeOfDay.now().hour;

    if (hour <= 12) {
      return 'Good Morning,';
    } else if (hour <= 17) {
      return 'Good Afternoon,';
    }
    return 'Good Evening,';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.only(left: 16.0, top: 16.0),
          child: ListView(children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      greet(),
                      style: GoogleFonts.barlow(
                          color: Colors.white,
                          fontSize: 22,
                          fontWeight: FontWeight.w300),
                    ),
                    GestureDetector(
                      onTap: () {},
                      child: Padding(
                        padding: const EdgeInsets.only(right: 16.0, top: 8.0),
                        child: CircleAvatar(
                          backgroundColor: Colors.transparent,
                          backgroundImage: img(),
                          radius: 20,
                        ),
                      ),
                    ),
                  ],
                ),
                Text(
                  loggedIn.displayName.toString().isEmpty
                      ? 'User'
                      : loggedIn.displayName.toString(),
                  style: GoogleFonts.barlow(
                    color: Colors.white,
                    fontSize: 28,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(
                      top: MediaQuery.of(context).size.height * 0.05),
                  child: Text(
                    'Uploaded Notes',
                    style: GoogleFonts.barlow(
                      color: Colors.white,
                      fontSize: 26,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                FutureBuilder<ListResult>(
                  future: futureFiles,
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      final files = snapshot.data!.items;
                      return ListView.builder(
                          physics: ClampingScrollPhysics(),
                          scrollDirection: Axis.vertical,
                          shrinkWrap: true,
                          itemCount: files.length,
                          itemBuilder: (context, index) {
                            final file = files[index];
                            String fileName = file.name;
                            return Padding(
                              padding: const EdgeInsets.only(top: 22),
                              child: Row(
                                children: [
                                  GestureDetector(
                                    onTap: () async {
                                      final url = fileName;
                                      final file =
                                          await FirebaseStorageAPI.loadFirebase(
                                              url);

                                      openPDF(context, file);
                                    },
                                    child: Image.asset(
                                      'images/folder 1.png',
                                      height: 50,
                                    ),
                                  ),
                                  SizedBox(
                                    width: 24,
                                  ),
                                  Text(
                                    file.name.length > 40
                                        ? file.name.substring(0, 40)
                                        : file.name,
                                    style: TextStyle(color: Colors.white),
                                  ),
                                ],
                              ),
                            );
                          });
                    } else if (snapshot.hasError) {
                      return Text(
                        "An error has occured",
                        style: TextStyle(color: Colors.white),
                      );
                    } else {
                      return CircularProgressIndicator();
                    }
                  },
                )
              ],
            ),
          ]),
        ),
      ),
    );
  }

  void openPDF(BuildContext context, File file) => Navigator.of(context).push(
        MaterialPageRoute(builder: (context) => PDFViewerPage(file: file)),
      );
}
