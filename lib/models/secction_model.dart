class SectionModel {
  SectionModel({
    required this.title,
    required this.sectionNumber,
    this.kanjis = const [],
  });

  final String title;
  final int sectionNumber;
  List<String> kanjis;
}

final listSections = [
  SectionModel(
      title: "From pictures",
      sectionNumber: 1,
      kanjis: sectionsKanjis['section1']!),
  SectionModel(
    title: "Numbers",
    sectionNumber: 2,
    kanjis: sectionsKanjis['section2']!,
  ),
  SectionModel(
      title: "Numbers and directions",
      sectionNumber: 3,
      kanjis: sectionsKanjis['section3']!),
  SectionModel(
      title: "Human body and people",
      sectionNumber: 4,
      kanjis: sectionsKanjis['section4']!),
  SectionModel(
      title: "Days and kanjis for the school",
      sectionNumber: 5,
      kanjis: sectionsKanjis['section5']!),
  SectionModel(
    title: "Time",
    sectionNumber: 6,
    kanjis: sectionsKanjis['section6']!,
  ),
  SectionModel(
      title: "Adjectives",
      sectionNumber: 7,
      kanjis: sectionsKanjis['section7']!),
  SectionModel(
    title: "Verbs",
    sectionNumber: 8,
    kanjis: sectionsKanjis['section8']!,
  ),
  SectionModel(
    title: "Nouns",
    sectionNumber: 9,
    kanjis: sectionsKanjis['section9']!,
  )
];

const sectionsKanjis = {
  "section1": ['山', '川', '天', '気', '田', '雨'],
  "section2": ['一', '二', '三', '四', '五', '六', '七', '八', '九', '十'],
  "section3": ['百', '千', '万', '円', '前', '後', '左', '右', '上', '下'],
  "section4": ['目', '口', '耳', '手', '足', '力', '父', '母', '男', '女', '子', '人', '名'],
  "section5": ['月', '火', '水', '木', '金', '土', '日', '先', '生', '学', '校', '本', '友'],
  "section6": ['年', '毎', '時', '分', '午', '間', '今', '半', '週', '朝', '昼', '夕', '夜'],
  "section7": ['高', '大', '中', '小', '長', '白', '安', '新', '古', '多', '少', '早'],
  "section8": [
    '言',
    '話',
    '語',
    '読',
    '書',
    '見',
    '聞',
    '行',
    '来',
    '出',
    '入',
    '食',
    '飲',
    '立',
    '休',
    '買'
  ],
  "section9": [
    '電',
    '車',
    '門',
    '馬',
    '魚',
    '道',
    '会',
    '社',
    '店',
    '駅',
    '花',
    '家',
    '外',
    '国',
    '方',
    '英'
  ]
};
