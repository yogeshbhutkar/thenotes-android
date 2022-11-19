import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconsax/iconsax.dart';
import 'package:thenotes/constants.dart';

import '../Screens/pdf_viewer_page.dart';
import '../components/storageAPI.dart';

String target = "";

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  late Future<ListResult> futureFiles;
  @override
  void initState() {
    super.initState();
    futureFiles = FirebaseStorage.instance.ref('/global').listAll();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: ListView(
        children: [
          TextField(
              style: const TextStyle(color: Colors.white),
              onChanged: (value) {
                setState(() {
                  target = value;
                });
              },
              decoration: kMessageSearchTextFieldDecoration.copyWith(
                  hintText: 'Search')),
          Padding(
            padding:
                EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.05),
            child: Text(
              target.isNotEmpty ? "Search Results" : "",
              style: GoogleFonts.barlow(
                  color: Colors.white,
                  fontWeight: FontWeight.w500,
                  fontSize: 32),
            ),
          ),
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.27,
            child: StreamBuilder<ListResult>(
              stream: futureFiles.asStream(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  final files = snapshot.data!.items;
                  final lis = [];

                  for (var ele in files) {
                    if (ele.fullPath
                            .toString()
                            .toLowerCase()
                            .substring(
                              7,
                            )
                            .contains(target) &&
                        target.isNotEmpty) {
                      lis.add(ele);
                    }
                  }
                  return ListView.builder(
                      physics: const BouncingScrollPhysics(),
                      scrollDirection: Axis.vertical,
                      shrinkWrap: true,
                      itemCount: lis.length,
                      itemBuilder: (context, index) {
                        final file = lis[index];
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
                                child: const Icon(
                                  size: 40,
                                  Iconsax.document5,
                                  color: Color.fromARGB(255, 247, 11, 58),
                                ),
                              ),
                              const SizedBox(
                                width: 24,
                              ),
                              Text(
                                file.name.length > 40
                                    ? file.name.substring(0, 40)
                                    : file.name,
                                style: const TextStyle(color: Colors.white),
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
                  return const Center(child: CircularProgressIndicator());
                }
              },
            ),
          )
        ],
      ),
    );
  }

  void openPDF(BuildContext context, File file) => Navigator.of(context).push(
        MaterialPageRoute(builder: (context) => PDFViewerPage(file: file)),
      );
}
