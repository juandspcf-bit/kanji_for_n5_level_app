// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'video_player_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$videoPlayerObjectHash() => r'3fec1dbed86e24aa607e616d6a46bf0940a5a398';

/// See also [VideoPlayerObject].
@ProviderFor(VideoPlayerObject)
final videoPlayerObjectProvider = AutoDisposeNotifierProvider<
    VideoPlayerObject,
    ({
      VideoPlayerController? videoPlayerController,
      Future<void> initializedVideoPlayer
    })>.internal(
  VideoPlayerObject.new,
  name: r'videoPlayerObjectProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$videoPlayerObjectHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$VideoPlayerObject = AutoDisposeNotifier<
    ({
      VideoPlayerController? videoPlayerController,
      Future<void> initializedVideoPlayer
    })>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member
