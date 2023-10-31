import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kanji_for_n5_level_app/providers/favorites_cached_provider.dart';
import 'package:kanji_for_n5_level_app/screens/body_list/body_list.dart';

class FavoriteScreen extends ConsumerStatefulWidget {
  const FavoriteScreen({
    super.key,
  });

  @override
  ConsumerState<FavoriteScreen> createState() => _FavoriteScreenState();
}

class _FavoriteScreenState extends ConsumerState<FavoriteScreen> {
  @override
  Widget build(BuildContext context) {
    final kanjis = ref.watch(favoritesCachedProvider);
    return BodyKanjisList(
      statusResponse: kanjis.$2,
      kanjisFromApi: kanjis.$1,
    );
  }
}
