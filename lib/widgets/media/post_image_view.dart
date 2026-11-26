import 'package:flutter/material.dart';
import '../../core/app_colors.dart';
import '../profile/adaptive_image_stub.dart'
    if (dart.library.io) '../profile/adaptive_image_io.dart';

class PostImageView extends StatelessWidget {
  final String path;
  final BoxFit fit;
  final double? width;
  final double? height;

  const PostImageView({
    super.key,
    required this.path,
    this.fit = BoxFit.cover,
    this.width,
    this.height,
  });

  @override
  Widget build(BuildContext context) {
    if (path.startsWith('assets/')) {
      return Container(
        color: AppColors.cream,
        child: Image.asset(
          path,
          fit: fit,
          width: width,
          height: height,
          errorBuilder: (_, __, ___) => _fallback(),
        ),
      );
    }

    if (path.startsWith('http://') || path.startsWith('https://')) {
      return Image.network(
        path,
        fit: fit,
        width: width,
        height: height,
        errorBuilder: (_, __, ___) => _fallback(),
      );
    }

    return buildAdaptiveFileImage(
      path,
      fit: fit,
      width: width,
      height: height,
      errorBuilder: (_, __, ___) => _fallback(),
    );
  }

  Widget _fallback() {
    return Container(
      width: width,
      height: height,
      color: AppColors.cream,
      child: const Center(
        child: Icon(
          Icons.image_not_supported_outlined,
          color: AppColors.burgundy,
          size: 32,
        ),
      ),
    );
  }
}
