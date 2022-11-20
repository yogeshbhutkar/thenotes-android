import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../pages/welcome_page.dart';

const String id = 'Upload';
final storageRef = FirebaseStorage.instance.ref();

class AddFile extends StatefulWidget {
  const AddFile({Key? key}) : super(key: key);

  @override
  State<AddFile> createState() => _AddFileState();
}

class _AddFileState extends State<AddFile> {
  late PlatformFile file;
  late UploadTask uploadTask;
  bool showLoading = false;

  Future<void> uploadFile(String storagePath, PlatformFile storageFile) async {
    final file = File(storageFile.path!);
    uploadTask = storageRef.child(storagePath).putFile(file);
    await uploadTask.whenComplete(() {});
  }

  Future<void> pickFile() async {
    FilePickerResult? pickedFile =
        await FilePicker.platform.pickFiles(type: FileType.any);
    if (pickedFile != null) {
      setState(() {
        file = pickedFile.files.first;
        selectedFileName = file.name;
      });
    }
  }

  String selectedFileName = '';
  void pushData() async {
    var todDate = DateTime.now().millisecondsSinceEpoch;
    String title = 'f${todDate}x8u${file.name}';
    await uploadFile('global/$title', file);
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 20, 19, 19),
      body: Stack(
        children: [
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(15),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SizedBox(width: double.infinity),
                  Text(
                    'Select a file to upload',
                    style: GoogleFonts.barlow(
                      color: Colors.white,
                      fontSize: 28,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  OutlinedButton(
                    style: ButtonStyle(
                        foregroundColor: MaterialStateProperty.all<Color>(
                            const Color.fromARGB(255, 247, 11, 58))),
                    onPressed: () async {
                      await pickFile();
                    },
                    child: const Text('Pick a file'),
                  ),
                  Text(
                    selectedFileName,
                    style: GoogleFonts.barlow(
                      color: Colors.white,
                      fontSize: 22,
                      fontWeight: FontWeight.w300,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color.fromARGB(255, 247, 11, 58),
        onPressed: () {
          pushData();
        },
        child: const Icon(Icons.done_all_rounded),
      ),
    );
  }
}
