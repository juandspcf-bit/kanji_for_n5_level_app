class SectionModel {
  const SectionModel({required this.title, required this.sectionNumber});

  final String title;
  final int sectionNumber;
}

const listSections = [
  SectionModel(title: "From pictures", sectionNumber: 1),
  SectionModel(title: "Numbers", sectionNumber: 2),
  SectionModel(title: "From pictures", sectionNumber: 3),
  SectionModel(title: "Numbers and directions", sectionNumber: 4),
  SectionModel(title: "Human body and people", sectionNumber: 5),
  SectionModel(title: "From pictures", sectionNumber: 6),
  SectionModel(title: "Days and kanjis for the school", sectionNumber: 7),
  SectionModel(title: "Time", sectionNumber: 8),
  SectionModel(title: "Adjectives", sectionNumber: 9),
  SectionModel(title: "Verbs", sectionNumber: 10)
];
