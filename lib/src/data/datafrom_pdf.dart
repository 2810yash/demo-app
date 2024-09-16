import 'package:flutter/material.dart';
import 'package:pdf_text/pdf_text.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'dart:io';
import 'package:path_provider/path_provider.dart';

class PdfExtractorPage extends StatefulWidget {
  const PdfExtractorPage({Key? key}) : super(key: key);

  @override
  _PdfExtractorPageState createState() => _PdfExtractorPageState();
}

class _PdfExtractorPageState extends State<PdfExtractorPage> {
  late PDFDoc _pdfDoc;
  List<Map<String, String>> studentList = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadPdfFromAssets();
  }

  Future<void> _loadPdfFromAssets() async {
    // Load the PDF from assets
    final byteData =
        await rootBundle.load('assets/your_pdf_file.pdf'); // Your PDF in assets

    // Get a temporary directory
    final directory = await getTemporaryDirectory();
    final filePath = '${directory.path}/temp_pdf.pdf';

    // Write the PDF file to the temp location
    final file = File(filePath);
    await file.writeAsBytes(byteData.buffer.asUint8List());

    // Now load the PDF with PDFDoc
    _pdfDoc = await PDFDoc.fromFile(file);

    // Extract text from the PDF
    String text = await _pdfDoc.text;

    // Parse the text (custom logic based on the PDF structure)
    _extractData(text);
  }

  void _extractData(String text) {
    List<String> lines = text.split('\n');

    for (String line in lines) {
      List<String> columns =
          line.split(' '); // Adjust this based on how the PDF separates values
      if (columns.length == 4) {
        String studentName =
            columns[1]; // Assuming Student Name is the 2nd column
        String prn = columns[3]; // Assuming PRN is the 4th column

        // Add the extracted data to the list
        studentList.add({'Student Name': studentName, 'PRN': prn});
      }
    }

    // Notify the UI that loading is done
    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("PDF Extractor"),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : DropdownButtonFormField<Map<String, String>>(
              items: studentList.map((student) {
                return DropdownMenuItem<Map<String, String>>(
                  value: student,
                  child: Text('${student['Student Name']} (${student['PRN']})'),
                );
              }).toList(),
              onChanged: (selectedStudent) {
                // Handle the dropdown selection
                print('Selected: ${selectedStudent?['Student Name']}');
              },
              hint: const Text('Select Student'),
            ),
    );
  }
}
