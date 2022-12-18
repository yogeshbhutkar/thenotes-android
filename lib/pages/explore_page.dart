import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconsax/iconsax.dart';
import 'package:thenotes/pages/UserArchive.dart';

import '../Screens/pdf_viewer_page.dart';

class ExplorePage extends StatefulWidget {
  const ExplorePage({super.key});

  @override
  State<ExplorePage> createState() => _ExplorePageState();
}

class _ExplorePageState extends State<ExplorePage> {
  late Future<ListResult> futureFiles;

  @override
  void initState() {
    futureFiles = FirebaseStorage.instance.ref('/').listAll();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
          left: 16.0, top: MediaQuery.of(context).size.height * 0.04),
      child: ListView(
        children: [
          Text(
            'Explore',
            style: GoogleFonts.barlow(
              color: Colors.white,
              fontSize: 26,
              fontWeight: FontWeight.bold,
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 24.0),
            child: Text(
              'User\'s Archives',
              style: GoogleFonts.barlow(
                color: Colors.white,
                fontSize: 26,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          SizedBox(
            // height: MediaQuery.of(context).size.height * 0.25,
            child: StreamBuilder<ListResult>(
              stream: futureFiles.asStream(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  final files = snapshot.data!.prefixes;
                  return ListView.builder(
                      physics: const BouncingScrollPhysics(),
                      scrollDirection: Axis.vertical,
                      shrinkWrap: true,
                      itemCount: files.length,
                      itemBuilder: (context, index) {
                        final file = files[index];
                        String fileName = file.name;
                        return Padding(
                          padding: const EdgeInsets.only(top: 22),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              GestureDetector(
                                onTap: () {
                                  Navigator.of(context).push(
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          UserArchive(dName: fileName),
                                    ),
                                  );
                                },
                                child: Row(
                                  children: [
                                    const Icon(
                                      size: 40,
                                      Iconsax.folder,
                                      color: Color.fromARGB(255, 247, 11, 58),
                                    ),
                                    const SizedBox(
                                      width: 24,
                                    ),
                                    Text(
                                      '${fileName.split(":")[0]}\'s Archive',
                                      style:
                                          const TextStyle(color: Colors.white),
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
          ),
        ],
      ),
    );
  }

  void openPDF(BuildContext context, File file) => Navigator.of(context).push(
        MaterialPageRoute(builder: (context) => PDFViewerPage(file: file)),
      );
}
