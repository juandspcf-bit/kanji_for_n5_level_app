class SectionModel {
  const SectionModel({required this.title, required this.sectionNumber});

  final String title;
  final int sectionNumber;
}

const listSections = [
  SectionModel(title: "From pictures", sectionNumber: 1),
  SectionModel(title: "Numbers", sectionNumber: 2),
  SectionModel(title: "Numbers and directions", sectionNumber: 3),
  SectionModel(title: "Human body and people", sectionNumber: 4),
  SectionModel(title: "Days and kanjis for the school", sectionNumber: 5),
  SectionModel(title: "Time", sectionNumber: 6),
  SectionModel(title: "Adjectives", sectionNumber: 7),
  SectionModel(title: "Verbs", sectionNumber: 8),
  SectionModel(title: "Nouns", sectionNumber: 9)
];
