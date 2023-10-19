import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kanji_for_n5_level_app/main.dart';
import 'package:kanji_for_n5_level_app/providers/favorites_kanjis_providers.dart';

class FavoritesKanjisScreen extends ConsumerStatefulWidget {
  const FavoritesKanjisScreen({super.key});

  @override
  ConsumerState<FavoritesKanjisScreen> createState() =>
      FavoritesKanjisScreenState();
}

class FavoritesKanjisScreenState extends ConsumerState<FavoritesKanjisScreen> {
  late Future<QuerySnapshot<Map<String, dynamic>>> getAllFavoritesQuery;

  @override
  void initState() {
    super.initState();
    getAllFavoritesQuery = dbFirebase.collection("favorites").get();
  }

  @override
  Widget build(BuildContext context) {
    return myFavoritesCached.isNotEmpty
        ? const Center(child: Text("there is data"))
        : FutureBuilder(
            future: getAllFavoritesQuery,
            builder: (ctx, snapshot) {
              final state = snapshot.connectionState;
              if (state == ConnectionState.waiting) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              } else if (state == ConnectionState.done) {
                QuerySnapshot<Map<String, dynamic>>? querySnapshot =
                    snapshot.data;

                myFavoritesCached = querySnapshot!.docs.map(
                  (e) {
                    Map<String, dynamic> data = e.data();
                    return (
                      e.id,
                      'kanjiCharacter',
                      data['kanjiCharacter'] as String
                    );
                  },
                ).toList();

                return Column(
                  children: [
                    for (var docSnapshot in querySnapshot.docs)
                      Text("data ${docSnapshot.data()}")

                    //print('${docSnapshot.id} => ${docSnapshot.data()}');
                  ],
                );
              } else {
                return const Center(
                  child: Text("Errror"),
                );
              }
            }); //const Center(child: Text("hhhhhh"));
  }
}
