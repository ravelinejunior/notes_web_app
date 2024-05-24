import 'dart:typed_data';

import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:notes_web_app/src/domain/model/note.dart';

Future<Uint8List> generateSinglePdf(Note note) async {
  final pdf = pw.Document();

  pdf.addPage(
    pw.Page(
      pageFormat: PdfPageFormat.standard,
      build: (pw.Context context) {
        return pw.Padding(
          padding: const pw.EdgeInsets.all(10),
          child: pw.Column(
            children: [
              pw.Text(
                note.title,
                style:
                    pw.TextStyle(fontSize: 20, fontWeight: pw.FontWeight.bold),
              ),
              pw.SizedBox(height: 10),
              pw.Text(note.content),
            ],
          ),
        );
      },
    ),
  );

  return pdf.save();
}
