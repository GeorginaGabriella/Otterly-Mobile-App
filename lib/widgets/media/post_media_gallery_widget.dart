import 'package:flutter/material.dart';
import '../../core/app_colors.dart';
import 'post_image_view.dart';

class PostMediaGalleryWidget extends StatelessWidget {
  final List<String> imagePaths;

  const PostMediaGalleryWidget({
    super.key,
    required this.imagePaths,
  });

  void _openLightbox(BuildContext context, int initialIndex) {
    showDialog<void>(
      context: context,
      barrierColor: Colors.black.withValues(alpha: 0.92),
      builder: (_) => _MediaLightboxDialog(
        imagePaths: imagePaths,
        initialIndex: initialIndex,
      ),
    );
  }

  Widget _buildTile(
    BuildContext context, {
    required int index,
    int? extraCountOverlay,
  }) {
    final path = imagePaths[index];
    return GestureDetector(
      onTap: () => _openLightbox(context, index),
      child: Stack(
        fit: StackFit.expand,
        children: [
          PostImageView(path: path, fit: BoxFit.cover),
          if (extraCountOverlay != null && extraCountOverlay > 0)
            Container(
              color: Colors.black.withValues(alpha: 0.55),
              child: Center(
                child: Text(
                  '+$extraCountOverlay',
                  style: const TextStyle(
                    color: AppColors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (imagePaths.isEmpty) {
      return const SizedBox.shrink();
    }

    return ClipRRect(
      borderRadius: BorderRadius.circular(14),
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(color: AppColors.border),
          borderRadius: BorderRadius.circular(14),
        ),
        child: _buildLayout(context),
      ),
    );
  }

  Widget _buildLayout(BuildContext context) {
    if (imagePaths.length == 1) {
      return SizedBox(
        height: 230,
        width: double.infinity,
        child: _buildTile(context, index: 0),
      );
    }

    if (imagePaths.length == 2) {
      return SizedBox(
        height: 200,
        child: Row(
          children: [
            Expanded(child: _buildTile(context, index: 0)),
            const SizedBox(width: 3),
            Expanded(child: _buildTile(context, index: 1)),
          ],
        ),
      );
    }

    if (imagePaths.length == 3) {
      return SizedBox(
        height: 220,
        child: Row(
          children: [
            Expanded(flex: 3, child: _buildTile(context, index: 0)),
            const SizedBox(width: 3),
            Expanded(
              flex: 2,
              child: Column(
                children: [
                  Expanded(child: _buildTile(context, index: 1)),
                  const SizedBox(height: 3),
                  Expanded(child: _buildTile(context, index: 2)),
                ],
              ),
            ),
          ],
        ),
      );
    }

    final extraCount = imagePaths.length - 4;
    return SizedBox(
      height: 230,
      child: Column(
        children: [
          Expanded(
            child: Row(
              children: [
                Expanded(child: _buildTile(context, index: 0)),
                const SizedBox(width: 3),
                Expanded(child: _buildTile(context, index: 1)),
              ],
            ),
          ),
          const SizedBox(height: 3),
          Expanded(
            child: Row(
              children: [
                Expanded(child: _buildTile(context, index: 2)),
                const SizedBox(width: 3),
                Expanded(
                  child: _buildTile(
                    context,
                    index: 3,
                    extraCountOverlay: extraCount,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _MediaLightboxDialog extends StatefulWidget {
  final List<String> imagePaths;
  final int initialIndex;

  const _MediaLightboxDialog({
    required this.imagePaths,
    required this.initialIndex,
  });

  @override
  State<_MediaLightboxDialog> createState() => _MediaLightboxDialogState();
}

class _MediaLightboxDialogState extends State<_MediaLightboxDialog> {
  late final PageController _pageController;
  late int _currentIndex;

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.initialIndex;
    _pageController = PageController(initialPage: widget.initialIndex);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog.fullscreen(
      backgroundColor: Colors.black,
      child: SafeArea(
        child: Stack(
          children: [
            PageView.builder(
              controller: _pageController,
              itemCount: widget.imagePaths.length,
              onPageChanged: (index) => setState(() => _currentIndex = index),
              itemBuilder: (context, index) {
                return Center(
                  child: InteractiveViewer(
                    minScale: 0.8,
                    maxScale: 4.0,
                    child: PostImageView(
                      path: widget.imagePaths[index],
                      fit: BoxFit.contain,
                    ),
                  ),
                );
              },
            ),
            Positioned(
              top: 12,
              left: 16,
              right: 16,
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.black.withValues(alpha: 0.55),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      '${_currentIndex + 1} / ${widget.imagePaths.length}',
                      style: const TextStyle(
                        color: AppColors.white,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  const Spacer(),
                  IconButton(
                    onPressed: () => Navigator.pop(context),
                    style: IconButton.styleFrom(
                      backgroundColor: Colors.black.withValues(alpha: 0.55),
                    ),
                    icon: const Icon(
                      Icons.close_rounded,
                      color: AppColors.white,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
