import 'package:flutter/material.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'custom_dropdown_menu_provider.g.dart';

@riverpod
class CustomDropdownMenuState extends _$CustomDropdownMenuState {
  @override
  ({GradeKanji grade, TextEditingController controller}) build() {
    return (grade: GradeKanji.grade1, controller: TextEditingController());
  }

  void setGrade(GradeKanji grade) {
    state = (grade: grade, controller: state.controller);
  }
}

enum GradeKanji {
  grade1(1),
  grade2(2),
  grade3(3),
  grade4(4),
  grade5(5),
  grade6(6);

  const GradeKanji(
    this.grade,
  );
  final int grade;
}
