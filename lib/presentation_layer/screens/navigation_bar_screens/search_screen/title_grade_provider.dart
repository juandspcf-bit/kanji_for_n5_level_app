import 'package:riverpod_annotation/riverpod_annotation.dart';

part "title_grade_provider.g.dart";

@riverpod
class TitleGrade extends _$TitleGrade {
  @override
  String build({required String initText}) {
    return initText;
  }

  void setTitle(String newTitle) {
    state = newTitle;
  }
}
