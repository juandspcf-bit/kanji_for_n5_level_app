import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:kanji_for_n5_level_app/models/secction_model.dart';

const temporalAvatar =
    "https://firebasestorage.googleapis.com/v0/b/kanji-for-n5.appspot.com/o/unnamed.jpg?alt=media&token=38275fec-42f3-4d95-b1fd-785e82d4086f&_gl=1*19p8v1f*_ga*MjAyNTg0OTcyOS4xNjk2NDEwODIz*_ga_CW55HF8NVT*MTY5NzEwMTY3NC45LjEuMTY5NzEwMzExMy4zMy4wLjA.";

class Sections extends StatelessWidget {
  const Sections({super.key});

  @override
  Widget build(BuildContext context) {
    return GridView(
      padding: const EdgeInsets.all(24),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 3 / 2,
        crossAxisSpacing: 20,
        mainAxisSpacing: 20,
      ),
      children: [
        for (final sectionData in listSections)
          Section(sectionData: sectionData)
      ],
    );
  }
}

class Section extends StatelessWidget {
  const Section({
    super.key,
    required this.sectionData,
  });

  final SectionModel sectionData;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {},
      splashColor: Theme.of(context).primaryColor,
      child: Container(
        padding: const EdgeInsets.only(left: 10, right: 10),
        width: 128,
        height: 128,
        decoration: BoxDecoration(
            //color: Theme.of(context).colorScheme.secondaryContainer,
            gradient: LinearGradient(colors: [
              Theme.of(context).colorScheme.secondaryContainer.withOpacity(0.9),
              Theme.of(context).colorScheme.secondaryContainer.withOpacity(0.3),
            ], begin: Alignment.topLeft, end: Alignment.bottomRight),
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: Colors.white38)),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              sectionData.title,
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).colorScheme.onSecondaryContainer,
                  fontFamily: GoogleFonts.roboto().fontFamily),
              textAlign: TextAlign.center,
            ),
            Text(
              "Seccion ${sectionData.sectionNumber}",
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: Theme.of(context).colorScheme.onSecondaryContainer,
                  fontFamily: GoogleFonts.roboto().fontFamily),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

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
