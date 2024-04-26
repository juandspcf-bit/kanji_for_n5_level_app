import 'package:cloud_firestore/cloud_firestore.dart';

Future<Map<String, dynamic>> fetchKanjiDataFirestore(
  String kanjiCharacter,
  FirebaseFirestore dbFirebase,
) async {
  final kanjisCollection = dbFirebase.collection("kanjis");
  final documentSnapshot = await kanjisCollection.doc(kanjiCharacter).get();
  return documentSnapshot.data() as Map<String, dynamic>;
}
