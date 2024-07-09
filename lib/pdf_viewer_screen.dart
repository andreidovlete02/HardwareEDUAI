import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'dart:io' as io;
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as path;

class PDFViewerScreen extends StatefulWidget {
  final String pdfPath;

  const PDFViewerScreen({Key? key, required this.pdfPath}) : super(key: key);

  @override
  _PDFViewerScreenState createState() => _PDFViewerScreenState();
}

class _PDFViewerScreenState extends State<PDFViewerScreen> {
  String? localPdfPath;

  @override
  void initState() {
    super.initState();
    _loadPdf();
  }

  Future<void> _loadPdf() async {
    print('Starting to load PDF...');
    try {
      print('Loading asset: ${widget.pdfPath}');
      final file = await _copyAssetToLocal(widget.pdfPath);
      print('Asset loaded successfully');
      setState(() {
        localPdfPath = file.path;
      });
    } catch (e) {
      print('Error loading PDF: $e');
    }
  }

  Future<io.File> _copyAssetToLocal(String assetPath) async {
    try {
      final byteData = await rootBundle.load(assetPath);
      final buffer = byteData.buffer;
      final tempDir = await getTemporaryDirectory();
      final filePath = path.join(tempDir.path, assetPath.split('/').last);
      final file = io.File(filePath);
      await file.writeAsBytes(buffer.asUint8List(byteData.offsetInBytes, byteData.lengthInBytes));
      return file;
    } catch (e) {
      throw Exception('Error copying asset to local file: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('PDF Viewer'),
      ),
      body: localPdfPath == null
          ? Center(child: CircularProgressIndicator())
          : SfPdfViewer.file(io.File(localPdfPath!)),
    );
  }
}
