import 'dart:io';

import 'package:kanji_for_n5_level_app/presentation_layer/screens/kanji_details/tabs/pdf_strokes/save_and_open_pdf.dart';
import 'package:pdf/widgets.dart';
import 'package:pdf/widgets.dart' as pw;

class PdfApi {
  static Future<File> pdfGenerator(String imagePath) {
    final pdf = Document();

    pdf.addPage(
      Page(
        build: (_) => pw.Center(
          child: pw.Container(
            height: 90,
            width: 90,
          ),
        ),
      ),
    );

    return SaveAndOpenPdf.savePdf(name: "kanji", pdf: pdf);
  }
}
