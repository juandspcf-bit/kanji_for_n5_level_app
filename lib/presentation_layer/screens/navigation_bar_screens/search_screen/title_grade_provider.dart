import 'package:riverpod_annotation/riverpod_annotation.dart';

part "title_grade_provider.g.dart";

@riverpod
class TitleGrade extends _$TitleGrade {
  @override
  String build() {
    return "The kyōiku kanji (教育漢字, literally 'education kanji'),are those kanji listed on the Gakunenbetsu kanji haitō hyō, a list of 1,026 kanji and associated readings developed and maintained by the Japanese Ministry of Education that prescribes which kanji, and which readings of kanji, Japanese students should learn from first grade to the sixth grade of elementary school.\n\n\n  Search kanjis by grade!!";
  }

  void setTitle(int grade) {
    state = "Kanjis for grade  $grade";
  }
}
