import 'package:flutter/material.dart';
// ignore: file_names
import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconsax/iconsax.dart';
import 'package:thenotes/components/storageAPI.dart';

import '../Screens/pdf_viewer_page.dart';

late User loggedIn;
List recentlyOpened = [];

class WelcomePage extends StatefulWidget {
  const WelcomePage({super.key});

  @override
  State<WelcomePage> createState() => _WelcomePageState();
}

class _WelcomePageState extends State<WelcomePage> {
  late Future<ListResult> futureFiles;
  late Reference storageRef;
  final _auth = FirebaseAuth.instance;
  @override
  void initState() {
    getCurrentUser();
    super.initState();
    futureFiles = FirebaseStorage.instance.ref('/global').listAll();
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
    if (loggedIn.photoURL.toString() != "null") {
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
    return Padding(
      padding: const EdgeInsets.only(left: 16.0, top: 16.0),
      child: ListView(physics: const BouncingScrollPhysics(), children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      greet(),
                      style: GoogleFonts.barlow(
                          color: Colors.white,
                          fontSize: 22,
                          fontWeight: FontWeight.w300),
                    ),
                    Text(
                      loggedIn.displayName.toString() == "null"
                          ? "user"
                          : loggedIn.displayName.toString(),
                      style: GoogleFonts.barlow(
                        color: Colors.white,
                        fontSize: 28,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
                Column(
                  children: [
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
              ],
            ),
            Padding(
              padding: EdgeInsets.only(
                  top: MediaQuery.of(context).size.height * 0.05),
              child: Text(
                'Recently uploaded',
                style: GoogleFonts.barlow(
                  color: Colors.white,
                  fontSize: 26,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            SizedBox(
              // height: MediaQuery.of(context).size.height * 0.27,
              child: StreamBuilder<ListResult>(
                stream: futureFiles.asStream(),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    final files = snapshot.data!.items;
                    return ListView.builder(
                        physics: const BouncingScrollPhysics(),
                        scrollDirection: Axis.vertical,
                        shrinkWrap: true,
                        itemCount: files.length,
                        itemBuilder: (context, index) {
                          final file = files[index];
                          String fileName = file.name;
                          int lastIndexOfHash = fileName.lastIndexOf('x8u') + 2;
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
                                  child: Row(
                                    children: [
                                      const Icon(
                                        size: 40,
                                        Iconsax.document5,
                                        color: Color.fromARGB(255, 247, 11, 58),
                                      ),
                                      const SizedBox(
                                        width: 24,
                                      ),
                                      Text(
                                        fileName.substring(
                                          lastIndexOfHash + 1,
                                          fileName.length - lastIndexOfHash > 30
                                              ? lastIndexOfHash + 30
                                              : fileName.length,
                                        ),
                                        style: const TextStyle(
                                            color: Colors.white),
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(
                                  width: 24,
                                ),
                              ],
                            ),
                          );
                        });
                  } else if (snapshot.hasError) {
                    return const Text(
                      "An error has occured",
                      style: TextStyle(color: Colors.white),
                    );
                  } else {
                    return const Padding(
                      padding: EdgeInsets.only(top: 60.0),
                      child: Center(child: CircularProgressIndicator()),
                    );
                  }
                },
              ),
            )
          ],
        ),
      ]),
    );
  }

  void openPDF(BuildContext context, File file) => Navigator.of(context).push(
        MaterialPageRoute(builder: (context) => PDFViewerPage(file: file)),
      );
}
