import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kanji_for_n5_level_app/main.dart';
import 'package:kanji_for_n5_level_app/presentation_layer/screens/account_details/account_details.dart';
import 'package:kanji_for_n5_level_app/presentation_layer/screens/main_screens/avatar_main_screen/avatar_main_screen_provider.dart';
import 'package:kanji_for_n5_level_app/providers/status_connection_provider.dart';

class AvatarMainScreenLandScape extends ConsumerWidget {
  const AvatarMainScreenLandScape({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final avatarLink = ref.watch(avatarMainScreenProvider);
    const sizeAvatar = 60;
    return LayoutBuilder(
      builder: (context, constraints) {
        logger.d(constraints.minWidth);
        return avatarLink.when(
          data: (data) {
            final (connection, url) = data;
            return GestureDetector(
              onTap: () {
                Navigator.of(context).push(
                  PageRouteBuilder(
                    transitionDuration: const Duration(seconds: 1),
                    reverseTransitionDuration: const Duration(seconds: 1),
                    pageBuilder: (context, animation, secondaryAnimation) =>
                        const AccountDetails(),
                    transitionsBuilder:
                        (context, animation, secondaryAnimation, child) {
                      return SlideTransition(
                        position: Tween<Offset>(
                          begin: const Offset(0, 1),
                          end: Offset.zero,
                        ).animate(
                          animation.drive(
                            CurveTween(
                              curve: Curves.easeInOutBack,
                            ),
                          ),
                        ),
                        child: child,
                      );
                    },
                  ),
                );
              },
              child: (connection == ConnectionStatus.noConnected)
                  ? Container(
                      color: Colors.transparent,
                      child: SizedBox(
                        width: sizeAvatar.toDouble(),
                        height: sizeAvatar.toDouble(),
                        child: Container(
                          decoration: BoxDecoration(
                              border: Border.all(
                                width: 0.5,
                                color: Colors.white,
                              ),
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(100)),
                          child: CircleAvatar(
                            backgroundImage: FileImage(File(url)),
                          ),
                        ),
                      ),
                    )
                  : CachedNetworkImage(
                      fit: BoxFit.contain,
                      imageBuilder: (context, imageProvider) {
                        return SizedBox(
                          width: sizeAvatar.toDouble(),
                          height: sizeAvatar.toDouble(),
                          child: Container(
                            decoration: BoxDecoration(
                                border: Border.all(
                                  width: 0.5,
                                  color: Colors.white,
                                ),
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(100)),
                            child: CircleAvatar(
                              backgroundImage: imageProvider,
                            ),
                          ),
                        );
                      },
                      imageUrl: url,
                      placeholder: (context, url) => SizedBox(
                            width: sizeAvatar.toDouble(),
                            height: sizeAvatar.toDouble(),
                            child: const Padding(
                              padding: EdgeInsets.all(8),
                              child: CircularProgressIndicator(),
                            ),
                          ),
                      errorWidget: (context, url, error) => SizedBox(
                            width: sizeAvatar.toDouble(),
                            height: sizeAvatar.toDouble(),
                            child: Container(
                              decoration: BoxDecoration(
                                  border: Border.all(
                                    width: 0.5,
                                    color: Colors.white,
                                  ),
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(100)),
                              child: Image.asset('assets/images/user.png'),
                            ),
                          )),
            );
          },
          error: (error, stack) => Container(),
          loading: () => SizedBox(
            width: sizeAvatar.toDouble(),
            height: sizeAvatar.toDouble(),
            child: const Padding(
              padding: EdgeInsets.all(8.0),
              child: CircularProgressIndicator(),
            ),
          ),
        );
      },
    );
  }
}
