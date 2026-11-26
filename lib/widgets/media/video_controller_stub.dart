import 'package:video_player/video_player.dart';

VideoPlayerController createPlatformVideoController(String path) {
  if (path.startsWith('assets/')) {
    return VideoPlayerController.asset(path);
  }
  return VideoPlayerController.networkUrl(Uri.parse(path));
}
