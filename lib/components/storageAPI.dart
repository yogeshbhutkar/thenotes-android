import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart';
import 'package:firebase_storage/firebase_storage.dart';

class FirebaseStorageAPI {
  static Future<File> _storeFile(String url, List<int> bytes) async {
    final filename = basename(url);
    final dir = await getApplicationDocumentsDirectory();

    final file = File('${dir.path}/$filename');
    await file.writeAsBytes(bytes, flush: true);
    return file;
  }

  static Future<File> loadFirebase(String url, String path) async {
    final refPDF = FirebaseStorage.instance.ref('/$path').child(url);
    final bytes = await refPDF.getData();
    return _storeFile(url, bytes!);
  }
}
