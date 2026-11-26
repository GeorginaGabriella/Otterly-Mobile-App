import 'dart:async';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import '../../core/app_colors.dart';
import 'video_controller_stub.dart'
    if (dart.library.io) 'video_controller_io.dart';

class PostVideoPlayerWidget extends StatefulWidget {
  final String videoPath;
  final double height;
  final bool allowFullscreen;

  const PostVideoPlayerWidget({
    super.key,
    required this.videoPath,
    this.height = 220,
    this.allowFullscreen = true,
  });

  @override
  State<PostVideoPlayerWidget> createState() => _PostVideoPlayerWidgetState();
}

class _PostVideoPlayerWidgetState extends State<PostVideoPlayerWidget> {
  VideoPlayerController? _controller;
  bool _isInitialized = false;
  bool _useFallbackPreview = false;
  bool _isMuted = false;

  // Fallback simulation state when native video_player plugin isn't registered (e.g. unit tests)
  bool _fallbackPlaying = false;
  int _fallbackSeconds = 0;
  static const int _fallbackDurationSeconds = 4;
  Timer? _fallbackTimer;

  @override
  void initState() {
    super.initState();
    _initController();
  }

  @override
  void didUpdateWidget(covariant PostVideoPlayerWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.videoPath != widget.videoPath) {
      _disposeController();
      _initController();
    }
  }

  Future<void> _initController() async {
    _isInitialized = false;
    _useFallbackPreview = false;
    try {
      final controller = createPlatformVideoController(widget.videoPath);
      _controller = controller;
      await controller.initialize();
      await controller.setLooping(true);
      if (!mounted) return;
      controller.addListener(_onVideoTick);
      setState(() {
        _isInitialized = true;
      });
    } catch (_) {
      _disposeController();
      if (!mounted) return;
      setState(() {
        _useFallbackPreview = true;
      });
    }
  }

  void _onVideoTick() {
    if (mounted) setState(() {});
  }

  void _disposeController() {
    _fallbackTimer?.cancel();
    _fallbackTimer = null;
    final controller = _controller;
    _controller = null;
    if (controller != null) {
      controller.removeListener(_onVideoTick);
      unawaited(controller.dispose());
    }
  }

  @override
  void dispose() {
    _disposeController();
    super.dispose();
  }

  void _togglePlay() {
    if (_useFallbackPreview) {
      setState(() {
        _fallbackPlaying = !_fallbackPlaying;
      });
      _fallbackTimer?.cancel();
      if (_fallbackPlaying) {
        _fallbackTimer = Timer.periodic(const Duration(seconds: 1), (_) {
          if (!mounted) return;
          setState(() {
            _fallbackSeconds =
                (_fallbackSeconds + 1) % (_fallbackDurationSeconds + 1);
          });
        });
      }
      return;
    }

    final controller = _controller;
    if (controller == null || !_isInitialized) return;
    if (controller.value.isPlaying) {
      unawaited(controller.pause());
    } else {
      unawaited(controller.play());
    }
    setState(() {});
  }

  void _toggleMute() {
    setState(() {
      _isMuted = !_isMuted;
    });
    if (_controller != null && _isInitialized) {
      unawaited(_controller!.setVolume(_isMuted ? 0.0 : 1.0));
    }
  }

  void _openFullscreen() {
    if (!widget.allowFullscreen) return;
    showDialog<void>(
      context: context,
      barrierColor: Colors.black.withValues(alpha: 0.94),
      builder: (dialogContext) => Dialog.fullscreen(
        backgroundColor: Colors.black,
        child: SafeArea(
          child: Stack(
            children: [
              Center(
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: PostVideoPlayerWidget(
                    videoPath: widget.videoPath,
                    height: 360,
                    allowFullscreen: false,
                  ),
                ),
              ),
              Positioned(
                top: 12,
                right: 16,
                child: IconButton(
                  onPressed: () => Navigator.pop(dialogContext),
                  style: IconButton.styleFrom(
                    backgroundColor: Colors.black.withValues(alpha: 0.6),
                  ),
                  icon: const Icon(Icons.close_rounded, color: AppColors.white),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _formatDuration(Duration d) {
    final minutes = d.inMinutes.remainder(60).toString();
    final seconds = d.inSeconds.remainder(60).toString().padLeft(2, '0');
    return '$minutes:$seconds';
  }

  @override
  Widget build(BuildContext context) {
    final bool isPlaying = _useFallbackPreview
        ? _fallbackPlaying
        : (_controller?.value.isPlaying ?? false);
    final Duration position = _useFallbackPreview
        ? Duration(seconds: _fallbackSeconds)
        : (_controller?.value.position ?? Duration.zero);
    final Duration duration = _useFallbackPreview
        ? const Duration(seconds: _fallbackDurationSeconds)
        : (_controller?.value.duration ?? Duration.zero);

    final progress = duration.inMilliseconds > 0
        ? (position.inMilliseconds / duration.inMilliseconds).clamp(0.0, 1.0)
        : 0.0;

    return ClipRRect(
      borderRadius: BorderRadius.circular(14),
      child: Container(
        height: widget.height,
        width: double.infinity,
        decoration: BoxDecoration(
          color: AppColors.textDark,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: AppColors.border),
        ),
        child: Stack(
          alignment: Alignment.center,
          children: [
            if (_isInitialized && _controller != null)
              Center(
                child: AspectRatio(
                  aspectRatio: _controller!.value.aspectRatio == 0
                      ? 16 / 9
                      : _controller!.value.aspectRatio,
                  child: VideoPlayer(_controller!),
                ),
              )
            else
              Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      AppColors.burgundy,
                      AppColors.pink,
                      AppColors.coral,
                    ],
                  ),
                ),
                child: Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(
                        Icons.videocam_rounded,
                        color: AppColors.cream,
                        size: 46,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        _useFallbackPreview
                            ? 'Otter.ly Video Clip'
                            : 'Loading video...',
                        style: const TextStyle(
                          color: AppColors.white,
                          fontSize: 12.5,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            Positioned.fill(
              child: GestureDetector(
                onTap: _togglePlay,
                behavior: HitTestBehavior.translucent,
                child: AnimatedOpacity(
                  opacity: isPlaying ? 0.0 : 1.0,
                  duration: const Duration(milliseconds: 180),
                  child: Center(
                    child: Container(
                      width: 56,
                      height: 56,
                      decoration: BoxDecoration(
                        color: AppColors.pink.withValues(alpha: 0.9),
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.3),
                            blurRadius: 12,
                          ),
                        ],
                      ),
                      child: Icon(
                        isPlaying
                            ? Icons.pause_rounded
                            : Icons.play_arrow_rounded,
                        color: AppColors.white,
                        size: 32,
                      ),
                    ),
                  ),
                ),
              ),
            ),
            Positioned(
              top: 10,
              left: 10,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.black.withValues(alpha: 0.55),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.videocam_rounded,
                      color: AppColors.yellow,
                      size: 14,
                    ),
                    SizedBox(width: 4),
                    Text(
                      'VIDEO',
                      style: TextStyle(
                        color: AppColors.white,
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 0.6,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              child: Container(
                padding: const EdgeInsets.fromLTRB(8, 12, 8, 6),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.transparent,
                      Colors.black.withValues(alpha: 0.72),
                    ],
                  ),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(4),
                      child: LinearProgressIndicator(
                        value: progress,
                        minHeight: 3.5,
                        backgroundColor: Colors.white.withValues(alpha: 0.25),
                        valueColor:
                            const AlwaysStoppedAnimation<Color>(AppColors.pink),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        IconButton(
                          constraints: const BoxConstraints(),
                          padding: const EdgeInsets.all(4),
                          onPressed: _togglePlay,
                          icon: Icon(
                            isPlaying
                                ? Icons.pause_rounded
                                : Icons.play_arrow_rounded,
                            color: AppColors.white,
                            size: 20,
                          ),
                        ),
                        const SizedBox(width: 4),
                        Text(
                          '${_formatDuration(position)} / ${_formatDuration(duration)}',
                          style: const TextStyle(
                            color: AppColors.white,
                            fontSize: 11,
                          ),
                        ),
                        const Spacer(),
                        IconButton(
                          constraints: const BoxConstraints(),
                          padding: const EdgeInsets.all(4),
                          onPressed: _toggleMute,
                          icon: Icon(
                            _isMuted
                                ? Icons.volume_off_rounded
                                : Icons.volume_up_rounded,
                            color: AppColors.white,
                            size: 18,
                          ),
                        ),
                        if (widget.allowFullscreen)
                          IconButton(
                            constraints: const BoxConstraints(),
                            padding: const EdgeInsets.all(4),
                            onPressed: _openFullscreen,
                            icon: const Icon(
                              Icons.fullscreen_rounded,
                              color: AppColors.white,
                              size: 20,
                            ),
                          ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
