import 'package:flutter_riverpod/flutter_riverpod.dart';

class SectionProvider extends Notifier<int> {
  @override
  int build() {
    return 0;
  }

  void setSection(int section) {
    state = section;
  }
}

final sectionProvider =
    NotifierProvider<SectionProvider, int>(SectionProvider.new);
