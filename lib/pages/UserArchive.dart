import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconsax/iconsax.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:thenotes/pages/settings.dart';
import '../Screens/pdf_viewer_page.dart';
import '../components/storageAPI.dart';

late User loggedIn;
bool liked = false;
int likedCount = 0;

class UserArchive extends StatefulWidget {
  static String id = "userarchive";
  final String dName;
  const UserArchive({super.key, required this.dName});

  @override
  State<UserArchive> createState() => _UserArchiveState();
}

class _UserArchiveState extends State<UserArchive> {
  final _auth = FirebaseAuth.instance;

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

  Future<ImageProvider> img() async {
    var imageURL;
    var collection = FirebaseFirestore.instance.collection('displayImages');
    var querySnapshot = await collection.get();
    for (var queryDocumentSnapshot in querySnapshot.docs) {
      Map<String, dynamic> data = queryDocumentSnapshot.data();
      imageURL = data['imageURL'];
      var userMail = data['userMail'];
      if (userMail == widget.dName.split(":")[1]) {
        break;
      }
    }
    return NetworkImage(imageURL);
  }

  bool checkCurrentUser() {
    if (widget.dName.split(":")[1] == loggedIn.email) {
      return true;
    } else {
      return false;
    }
  }

  late Future<ListResult> futureFiles;
  late Reference storageRef;
  @override
  void initState() {
    super.initState();

    getCurrentUser();
    futureFiles = FirebaseStorage.instance.ref('/${widget.dName}').listAll();
  }

  @override
  Widget build(BuildContext context) {
    final name = widget.dName.split(":")[0];
    return Scaffold(
      backgroundColor: Colors.black,
      body: Padding(
        padding: EdgeInsets.only(
            left: 16.0, top: MediaQuery.of(context).size.height * 0.04),
        child: ListView(children: [
          FutureBuilder(
            future: img(),
            builder: (context, snapshot) {
              return SizedBox(
                height: MediaQuery.of(context).size.height * 0.18,
                child: FittedBox(
                  fit: BoxFit.contain,
                  child: CircleAvatar(
                    radius: 75,
                    backgroundColor: Colors.transparent,
                    backgroundImage: snapshot.data,
                  ),
                ),
              );
            },
          ),
          Padding(
            padding: const EdgeInsets.only(top: 16.0),
            child: Center(
              child: Text(
                '$name\'s Archive',
                style: GoogleFonts.barlow(
                  color: Colors.white,
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                GestureDetector(
                  onTap: () {
                    setState(() {
                      liked = !liked;
                      if (liked == true) {
                        likedCount--;
                      } else {
                        likedCount++;
                      }
                    });
                  },
                  child: Icon(
                    liked ? Iconsax.like : Iconsax.like5,
                    color: Color.fromARGB(255, 247, 11, 58),
                    size: 40,
                  ),
                ),
                const SizedBox(
                  width: 8.0,
                ),
                Text(
                  '$likedCount',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 18.0),
            child: SizedBox(
              // height: MediaQuery.of(context).size.height * 0.25,
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
                          // print(file);
                          String fileName = file.name;
                          int lastIndexOfHash = fileName.lastIndexOf('x8u') + 2;
                          return Padding(
                            padding: const EdgeInsets.only(top: 22),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                GestureDetector(
                                  onTap: () async {
                                    final url = fileName;
                                    final file =
                                        await FirebaseStorageAPI.loadFirebase(
                                            url, widget.dName);
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
                                checkCurrentUser()
                                    ? Padding(
                                        padding:
                                            const EdgeInsets.only(right: 16.0),
                                        child: GestureDetector(
                                          onTap: () async {
                                            final storageRef =
                                                FirebaseStorage.instance.ref();
                                            final desertRef = storageRef.child(
                                                widget.dName + "/" + fileName);
                                            await desertRef.delete();
                                          },
                                          child: const Icon(
                                            size: 25,
                                            Icons.delete_rounded,
                                            color: Color.fromARGB(
                                                255, 247, 11, 58),
                                          ),
                                        ),
                                      )
                                    : Container(),
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
          ),
        ]),
      ),
    );
  }

  void openPDF(BuildContext context, File file) => Navigator.of(context).push(
        MaterialPageRoute(builder: (context) => PDFViewerPage(file: file)),
      );
}
