import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconsax/iconsax.dart';
import 'package:thenotes/Screens/pdf_viewer_page.dart';

import '../components/storageAPI.dart';

class RecentUpload extends StatefulWidget {
  static String id = 'RecentUpload';
  const RecentUpload({super.key});

  @override
  State<RecentUpload> createState() => _RecentUploadState();
}

class _RecentUploadState extends State<RecentUpload> {
  late Future<ListResult> futureFiles;

  late Reference storageRef;
  @override
  void initState() {
    super.initState();
    futureFiles = FirebaseStorage.instance.ref('/global').listAll();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Padding(
        padding: EdgeInsets.only(
            left: 16.0, top: MediaQuery.of(context).size.height * 0.04),
        child: SafeArea(
          child: ListView(
            physics: const BouncingScrollPhysics(),
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Recently uploaded',
                    style: GoogleFonts.barlow(
                      color: Colors.white,
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: Padding(
                      padding: const EdgeInsets.only(right: 16.0),
                      child: Text(
                        'BACK',
                        style: GoogleFonts.barlow(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ),
                  ),
                ],
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
                            int lastIndexOfHash =
                                fileName.lastIndexOf('x8u') + 2;
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
                                          color:
                                              Color.fromARGB(255, 247, 11, 58),
                                        ),
                                        const SizedBox(
                                          width: 24,
                                        ),
                                        Text(
                                          fileName.substring(
                                            lastIndexOfHash + 1,
                                            fileName.length - lastIndexOfHash >
                                                    30
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
              ),
            ],
          ),
        ),
      ),
    );
  }

  void openPDF(BuildContext context, File file) => Navigator.of(context).push(
        MaterialPageRoute(builder: (context) => PDFViewerPage(file: file)),
      );
}
