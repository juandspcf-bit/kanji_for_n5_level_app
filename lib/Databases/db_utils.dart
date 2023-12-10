import 'dart:io';

import 'package:async/async.dart';
import 'package:dio/dio.dart';

void addToFutureGroup({
  required String path,
  required String link,
  required FutureGroup<Response<dynamic>> group,
  required Dio dio,
}) {
  group.add(dio.download(
    link,
    path,
    onReceiveProgress: (received, total) {
/*         if (total != -1) {
          print((received / total * 100).toStringAsFixed(0) + "%");
          //you can build progressbar feature too
        } */
    },
  ));
}

String getPathToDocuments({
  required Directory dirDocumentPath,
  required String link,
  required String uuid,
}) {
  final lastSeparatorIndex = link.lastIndexOf('/');
  final nameFile = link.substring(lastSeparatorIndex + 1);
  return '${dirDocumentPath.path}/${uuid}_$nameFile';
}

enum DeleteStatus {
  errorMediaLinksFiles,
  succesMediaLinksFiles,
  errorAudioExampleLinksFiles,
  succesAudioExampleLinksFiles,
  errorStrokeLinksFiles,
  succesStrokeLinksFiles,
  errorKanjiDatabase,
  successKanjiDatabase,
  succes,
}
