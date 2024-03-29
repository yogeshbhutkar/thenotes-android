import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:path/path.dart';

class PDFViewerPage extends StatefulWidget {
  final File file;
  const PDFViewerPage({super.key, required this.file});

  @override
  State<PDFViewerPage> createState() => _PDFViewerPageState();
}

class _PDFViewerPageState extends State<PDFViewerPage> {
  @override
  Widget build(BuildContext context) {
    final name = basename(widget.file.path);
    int lastIndexOfHash = name.lastIndexOf('x8u') + 2;

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        centerTitle: true,
        title: Text(name.substring(
          lastIndexOfHash + 1,
          name.length - lastIndexOfHash > 30
              ? lastIndexOfHash + 30
              : name.length,
        )),
      ),
      body: PDFView(
        filePath: widget.file.path,
        onError: (error) {
          // print('this is the error ${error.toString()}');
        },
      ),
    );
  }
}
