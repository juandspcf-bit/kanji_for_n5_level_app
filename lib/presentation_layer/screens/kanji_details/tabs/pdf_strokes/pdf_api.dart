import 'dart:io';

import 'package:kanji_for_n5_level_app/presentation_layer/screens/kanji_details/tabs/pdf_strokes/save_and_open_pdf.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart';
import 'package:pdf/widgets.dart' as pw;

class PdfApi {
  static pw.Widget buildCustomPaint(String svgRaw) {
    final paint = pw.CustomPaint(
      size: const PdfPoint(90, 90),
      painter: (PdfGraphics canvas, PdfPoint size) {
        canvas
          ..moveTo(0, 0)
          ..lineTo(0, size.y)
          ..lineTo(size.x, size.y)
          ..lineTo(size.x, 0)
          ..lineTo(0, 0)
          ..setColor(PdfColors.black)
          ..setLineWidth(5)
          ..strokePath();
      },
      child: pw.SvgImage(svg: svgRaw, colorFilter: PdfColor.fromHex("#c7c7c7")),
    );

    return paint;
  }

  static Future<File> pdfGenerator(String svgRaw) {
    final pdf = Document();

    final svgImage = pw.SvgImage(
        svg: svgRaw,
        colorFilter: PdfColor.fromHex("#c7c7c7"),
        width: 90,
        height: 90);

    pdf.addPage(
      Page(
        build: (_) => pw.Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            pw.Container(
              height: 90,
              width: 90,
              child: buildCustomPaint(svgRaw),
            ),
            pw.Container(
              height: 90,
              width: 90,
              child: buildCustomPaint(svgRaw),
            ),
          ],
        ),
      ),
    );

    return SaveAndOpenPdf.savePdf(name: "kanji.pdf", pdf: pdf);
  }
}
