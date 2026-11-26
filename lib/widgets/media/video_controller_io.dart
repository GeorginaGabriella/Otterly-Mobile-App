import 'dart:io';
import 'package:video_player/video_player.dart';

VideoPlayerController createPlatformVideoController(String path) {
  if (path.startsWith('assets/')) {
    return VideoPlayerController.asset(path);
  }
  if (path.startsWith('http://') ||
      path.startsWith('https://') ||
      path.startsWith('blob:')) {
    return VideoPlayerController.networkUrl(Uri.parse(path));
  }
  return VideoPlayerController.file(File(path));
}
