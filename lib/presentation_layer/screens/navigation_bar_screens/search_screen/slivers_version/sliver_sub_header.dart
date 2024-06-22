import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kanji_for_n5_level_app/presentation_layer/screens/navigation_bar_screens/search_screen/search_screen_provider.dart';

class SliverTextField extends ConsumerWidget {
  final _formKey = GlobalKey<FormState>();
  final validCharacters = RegExp(r'^[a-zA-Z]+$');

  SliverTextField({
    super.key,
  });

  void onValidate(WidgetRef ref) async {
    final currenState = _formKey.currentState;
    if (currenState == null) return;
    if (currenState.validate()) {
      currenState.save();
      return;
    }
    ref.read(searchScreenProvider.notifier).setOnErrorTextField();
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final searchScreenState = ref.watch(searchScreenProvider);

    // 1
    return SliverPersistentHeader(
      pinned: true,
      delegate: _SliverAppBarDelegate(
        // 2
        minHeight: 0,
        maxHeight: 90,
        // 3
        child: Form(
          key: _formKey,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: TextFormField(
              initialValue: searchScreenState.word,
              decoration: const InputDecoration().copyWith(
                  border: const OutlineInputBorder(),
                  suffixIcon: GestureDetector(
                    child: const Icon(Icons.search),
                    onTap: () {
                      onValidate(ref);
                      FocusScopeNode currentFocus = FocusScope.of(context);

                      if (!currentFocus.hasPrimaryFocus) {
                        currentFocus.unfocus();
                      }
                    },
                  ),
                  labelText: 'english word',
                  hintText: 'english word'),
              keyboardType: TextInputType.text,
              validator: (text) {
                if (text != null &&
                    text.isNotEmpty &&
                    validCharacters.hasMatch(text.trim())) {
                  return null;
                } else {
                  return 'Not a valid word';
                }
              },
              onSaved: (value) {
                ref.read(searchScreenProvider.notifier).setWord(value ?? '');
              },
            ),
          ),
        ),
      ),
    );
  }
}

class _SliverAppBarDelegate extends SliverPersistentHeaderDelegate {
  final double minHeight;
  final double maxHeight;
  final Widget child;

  _SliverAppBarDelegate({
    required this.minHeight,
    required this.maxHeight,
    required this.child,
  });

  @override
  double get minExtent => minHeight;

  @override
  double get maxExtent => max(maxHeight, minHeight);

  // 2
  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return SizedBox.expand(child: child);
  }

  // 3
  @override
  bool shouldRebuild(_SliverAppBarDelegate oldDelegate) {
    return maxHeight != oldDelegate.maxHeight ||
        minHeight != oldDelegate.minHeight ||
        child != oldDelegate.child;
  }
}
