import 'dart:io';

import 'package:kanji_for_n5_level_app/presentation_layer/screens/kanji_details/tabs/tab_strokes/pdf_strokes/save_and_open_pdf.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart';
import 'package:pdf/widgets.dart' as pw;

class PdfApi {
  static pw.Widget buildCustomPaint({String? svgRaw}) {
    final paint = pw.CustomPaint(
      size: const PdfPoint(100, 100),
      painter: (PdfGraphics canvas, PdfPoint size) {
        double dashWidth = size.x / 12,
            dashSpace = size.x / 12,
            startX = 0,
            startY = 0;

        while (startX < size.x) {
          canvas
            ..setColor(PdfColors.lightBlue100)
            ..setLineWidth(4)
            ..drawLine(
              startX,
              size.y / 2,
              startX + dashWidth,
              size.y / 2,
            )
            ..strokePath();
          startX += dashWidth + dashSpace;
        }

        while (startY < size.y) {
          canvas
            ..setColor(PdfColors.lightBlue100)
            ..setLineWidth(4)
            ..drawLine(
              size.x / 2,
              startY,
              size.x / 2,
              startY + dashWidth,
            )
            ..strokePath();
          startY += dashWidth + dashSpace;
        }

        canvas
          ..moveTo(0, 0)
          ..lineTo(0, size.y)
          ..lineTo(size.x, size.y)
          ..lineTo(size.x, 0)
          ..lineTo(0, 0)
          ..setColor(PdfColors.black)
          ..setLineWidth(2)
          ..strokePath();
      },
      child: svgRaw != null
          ? pw.SvgImage(
              svg: svgRaw,
              colorFilter: PdfColor.fromHex("#c7c7c7"),
            )
          : null,
    );

    return paint;
  }

  static Future<File> pdfGenerator(String svgRaw) {
    final pdf = Document();

    pdf.addPage(
      Page(
        pageFormat: PdfPageFormat.a4,
        build: (_) {
          return pw.Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              pw.Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  for (int i = 0; i < 5; i++)
                    pw.Container(
                      height: 100,
                      width: 100,
                      child: buildCustomPaint(svgRaw: svgRaw),
                    ),
                ],
              ),
              for (int i = 0; i < 7; i++)
                pw.Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    for (int i = 0; i < 5; i++)
                      pw.Container(
                        height: 100,
                        width: 100,
                        child: buildCustomPaint(),
                      )
                  ],
                )
            ],
          );
        },
      ),
    );

    return SaveAndOpenPdf.savePdf(name: "kanji.pdf", pdf: pdf);
  }
}
