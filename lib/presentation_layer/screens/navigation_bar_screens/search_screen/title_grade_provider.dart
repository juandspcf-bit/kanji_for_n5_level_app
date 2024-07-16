import 'package:riverpod_annotation/riverpod_annotation.dart';

part "title_grade_provider.g.dart";

@riverpod
class TitleGrade extends _$TitleGrade {
  @override
  String build() {
    return "";
  }

  void setTitle(String newTitle) {
    state = newTitle;
  }
}
