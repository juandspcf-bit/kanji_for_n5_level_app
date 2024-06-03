import 'package:dio/dio.dart';
import 'package:kanji_for_n5_level_app/repositories_layer/local_database/db_utils.dart';
import 'package:path_provider/path_provider.dart';

Future<String> downloadStrokeData(
  String link,
  String uuid,
) async {
  final path = getPathToDocuments(
    dirDocumentPath: await getTemporaryDirectory(),
    link: link,
    uuid: uuid,
  );

  Dio dio = Dio();
  await dio.download(
    link,
    path,
    onReceiveProgress: (received, total) {
/*       if (total != -1) {
        print((received / total * 100).toStringAsFixed(0) + "%");
        //you can build progressbar feature too
      } */
    },
  );

  return path;
}
