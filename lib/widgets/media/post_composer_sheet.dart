import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../../core/app_colors.dart';
import '../../core/app_constants.dart';
import 'post_image_view.dart';
import 'post_video_player_widget.dart';

class PostComposerResult {
  final String content;
  final String category;
  final String? location;
  final String audience;
  final List<String> imagePaths;
  final String? videoPath;

  const PostComposerResult({
    required this.content,
    required this.category,
    this.location,
    this.audience = 'Public',
    this.imagePaths = const [],
    this.videoPath,
  });
}

class PostComposerSheet extends StatefulWidget {
  final String authorName;
  final String authorAvatar;
  final String initialCategory;
  final bool asFullPage;
  final ValueChanged<PostComposerResult>? onPublish;

  const PostComposerSheet({
    super.key,
    required this.authorName,
    this.authorAvatar = AppConstants.pinkAvatarPath,
    this.initialCategory = 'Campus Life',
    this.asFullPage = false,
    this.onPublish,
  });

  static Future<PostComposerResult?> show(
    BuildContext context, {
    required String authorName,
    String authorAvatar = AppConstants.pinkAvatarPath,
    String initialCategory = 'Campus Life',
  }) {
    return showModalBottomSheet<PostComposerResult>(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      backgroundColor: AppColors.background,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (_) => PostComposerSheet(
        authorName: authorName,
        authorAvatar: authorAvatar,
        initialCategory: initialCategory,
      ),
    );
  }

  @override
  State<PostComposerSheet> createState() => _PostComposerSheetState();
}

class _PostComposerSheetState extends State<PostComposerSheet> {
  final TextEditingController _contentController = TextEditingController();
  final TextEditingController _locationController = TextEditingController();
  final ImagePicker _picker = ImagePicker();

  late String _selectedCategory;
  String _selectedAudience = 'Public';
  bool _showLocationField = false;
  final List<String> _imagePaths = [];
  String? _videoPath;

  static const List<String> _categories = [
    'General',
    'Campus Life',
    'Academic',
    'Organization',
    'Events',
    'Promotion',
    'Entertainment',
  ];

  static const List<String> _audiences = ['Public', 'Friends', 'Only Me'];

  static const List<String> _campusSpots = [
    'Kampus 1 UNTAR',
    'Gedung Utama UNTAR',
    'Perpustakaan UNTAR',
    'Selasar Gedung M',
  ];

  @override
  void initState() {
    super.initState();
    _selectedCategory = _categories.contains(widget.initialCategory)
        ? widget.initialCategory
        : 'Campus Life';
  }

  @override
  void dispose() {
    _contentController.dispose();
    _locationController.dispose();
    super.dispose();
  }

  Future<void> _pickPhotos() async {
    try {
      final List<XFile> picked = await _picker.pickMultiImage(
        maxWidth: 1400,
        imageQuality: 85,
      );
      if (picked.isEmpty || !mounted) return;
      setState(() {
        _videoPath = null;
        _imagePaths.addAll(picked.map((e) => e.path));
      });
    } catch (_) {
      if (!mounted) return;
      _showSampleMediaPicker();
    }
  }

  Future<void> _pickVideo() async {
    try {
      final XFile? picked = await _picker.pickVideo(
        source: ImageSource.gallery,
      );
      if (picked == null || !mounted) return;
      setState(() {
        _imagePaths.clear();
        _videoPath = picked.path;
      });
    } catch (_) {
      if (!mounted) return;
      _showSampleMediaPicker();
    }
  }

  void _showSampleMediaPicker() {
    showModalBottomSheet<void>(
      context: context,
      showDragHandle: true,
      backgroundColor: AppColors.background,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(22)),
      ),
      builder: (sheetContext) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(18, 4, 18, 20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Campus Media Gallery',
                style: TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.bold,
                  color: AppColors.burgundy,
                ),
              ),
              const SizedBox(height: 4),
              const Text(
                'Tap any campus photo to add (multi-photo supported) or select the campus video reel.',
                style: TextStyle(fontSize: 12, color: AppColors.textSecondary),
              ),
              const SizedBox(height: 14),
              SizedBox(
                height: 92,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  itemCount: AppConstants.sampleCampusPhotos.length,
                  separatorBuilder: (_, __) => const SizedBox(width: 10),
                  itemBuilder: (_, index) {
                    final asset = AppConstants.sampleCampusPhotos[index];
                    return GestureDetector(
                      onTap: () {
                        setState(() {
                          _videoPath = null;
                          if (!_imagePaths.contains(asset)) {
                            _imagePaths.add(asset);
                          }
                        });
                        Navigator.pop(sheetContext);
                      },
                      child: Container(
                        width: 92,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(14),
                          border: Border.all(color: AppColors.border),
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(14),
                          child: PostImageView(path: asset),
                        ),
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: 14),
              ListTile(
                tileColor: AppColors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                  side: const BorderSide(color: AppColors.border),
                ),
                leading: const CircleAvatar(
                  backgroundColor: AppColors.cream,
                  child: Icon(
                    Icons.videocam_rounded,
                    color: AppColors.burgundy,
                  ),
                ),
                title: const Text(
                  'Otter.ly UNTAR Campus Reel (MP4)',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13.5),
                ),
                subtitle: const Text(
                  '4s campus highlight video',
                  style: TextStyle(fontSize: 12),
                ),
                trailing: const Icon(
                  Icons.add_circle_outline_rounded,
                  color: AppColors.pink,
                ),
                onTap: () {
                  setState(() {
                    _imagePaths.clear();
                    _videoPath = AppConstants.campusVideoPath;
                  });
                  Navigator.pop(sheetContext);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _publish() {
    final content = _contentController.text.trim();
    if (content.isEmpty && _imagePaths.isEmpty && _videoPath == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Write a caption or attach a photo/video first.'),
          backgroundColor: AppColors.error,
        ),
      );
      return;
    }

    final location = _locationController.text.trim();
    final result = PostComposerResult(
      content: content.isEmpty ? 'Shared a campus moment 🦦' : content,
      category: _selectedCategory,
      location: location.isEmpty ? null : location,
      audience: _selectedAudience,
      imagePaths: List<String>.from(_imagePaths),
      videoPath: _videoPath,
    );

    if (widget.onPublish != null) {
      widget.onPublish!(result);
      _contentController.clear();
      _locationController.clear();
      setState(() {
        _imagePaths.clear();
        _videoPath = null;
        _showLocationField = false;
      });
      return;
    }

    Navigator.pop(context, result);
  }

  Widget _buildAudienceChip() {
    return PopupMenuButton<String>(
      initialValue: _selectedAudience,
      onSelected: (value) => setState(() => _selectedAudience = value),
      itemBuilder: (_) => _audiences
          .map(
            (audience) => PopupMenuItem<String>(
              value: audience,
              child: Row(
                children: [
                  Icon(
                    audience == 'Public'
                        ? Icons.public
                        : audience == 'Friends'
                            ? Icons.people_outline_rounded
                            : Icons.lock_outline_rounded,
                    size: 16,
                    color: AppColors.burgundy,
                  ),
                  const SizedBox(width: 8),
                  Text(audience),
                ],
              ),
            ),
          )
          .toList(),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
        decoration: BoxDecoration(
          color: AppColors.cream,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              _selectedAudience == 'Public'
                  ? Icons.public
                  : _selectedAudience == 'Friends'
                      ? Icons.people_outline_rounded
                      : Icons.lock_outline_rounded,
              size: 13,
              color: AppColors.burgundy,
            ),
            const SizedBox(width: 4),
            Text(
              _selectedAudience,
              style: const TextStyle(
                fontSize: 11.5,
                fontWeight: FontWeight.w600,
                color: AppColors.burgundy,
              ),
            ),
            const Icon(
              Icons.arrow_drop_down_rounded,
              size: 16,
              color: AppColors.burgundy,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMediaPreview() {
    if (_videoPath != null) {
      return Stack(
        children: [
          PostVideoPlayerWidget(videoPath: _videoPath!, height: 200),
          Positioned(
            top: 8,
            right: 8,
            child: IconButton(
              onPressed: () => setState(() => _videoPath = null),
              style: IconButton.styleFrom(
                backgroundColor: Colors.black.withValues(alpha: 0.65),
              ),
              icon: const Icon(Icons.close_rounded, color: AppColors.white),
            ),
          ),
        ],
      );
    }

    if (_imagePaths.isEmpty) {
      return const SizedBox.shrink();
    }

    return SizedBox(
      height: 112,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: _imagePaths.length + 1,
        separatorBuilder: (_, __) => const SizedBox(width: 8),
        itemBuilder: (_, index) {
          if (index == _imagePaths.length) {
            return GestureDetector(
              onTap: _pickPhotos,
              child: Container(
                width: 96,
                decoration: BoxDecoration(
                  color: AppColors.white,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: AppColors.border),
                ),
                child: const Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.add_photo_alternate_outlined,
                        color: AppColors.pink),
                    SizedBox(height: 4),
                    Text(
                      'Add Photo',
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        color: AppColors.burgundy,
                      ),
                    ),
                  ],
                ),
              ),
            );
          }

          return Stack(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(14),
                child: SizedBox(
                  width: 112,
                  height: 112,
                  child: PostImageView(path: _imagePaths[index]),
                ),
              ),
              Positioned(
                top: 4,
                right: 4,
                child: GestureDetector(
                  onTap: () => setState(() => _imagePaths.removeAt(index)),
                  child: Container(
                    padding: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      color: Colors.black.withValues(alpha: 0.65),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.close_rounded,
                      size: 14,
                      color: AppColors.white,
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildToolbarButton({
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: color, size: 20),
            const SizedBox(width: 5),
            Text(
              label,
              style: const TextStyle(
                fontSize: 12.5,
                fontWeight: FontWeight.w600,
                color: AppColors.textDark,
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final bottomInset = MediaQuery.of(context).viewInsets.bottom;

    return Padding(
      padding: EdgeInsets.only(bottom: widget.asFullPage ? 0 : bottomInset),
      child: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(18, 12, 18, 18),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                if (!widget.asFullPage)
                  IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(
                      Icons.close_rounded,
                      color: AppColors.burgundy,
                    ),
                  ),
                const Expanded(
                  child: Text(
                    'Create Post',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: AppColors.burgundy,
                    ),
                  ),
                ),
                ElevatedButton(
                  onPressed: _publish,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.pink,
                    foregroundColor: AppColors.white,
                    minimumSize: const Size(86, 38),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text('Post'),
                ),
              ],
            ),
            const Divider(color: AppColors.border),
            const SizedBox(height: 8),
            Row(
              children: [
                CircleAvatar(
                  radius: 22,
                  backgroundColor: AppColors.cream,
                  backgroundImage: AssetImage(widget.authorAvatar),
                ),
                const SizedBox(width: 10),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.authorName,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 14.5,
                        color: AppColors.textDark,
                      ),
                    ),
                    const SizedBox(height: 4),
                    _buildAudienceChip(),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 14),
            TextField(
              controller: _contentController,
              maxLines: 4,
              decoration: InputDecoration(
                hintText: "What's on your mind, ${widget.authorName.split(' ').first}?",
                filled: true,
                fillColor: AppColors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: const BorderSide(color: AppColors.border),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: const BorderSide(color: AppColors.border),
                ),
              ),
            ),
            const SizedBox(height: 12),
            SizedBox(
              height: 36,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemCount: _categories.length,
                separatorBuilder: (_, __) => const SizedBox(width: 8),
                itemBuilder: (_, index) {
                  final cat = _categories[index];
                  final selected = _selectedCategory == cat;
                  return ChoiceChip(
                    label: Text(cat),
                    selected: selected,
                    onSelected: (_) => setState(() => _selectedCategory = cat),
                    selectedColor: AppColors.pink,
                    backgroundColor: AppColors.white,
                    side: BorderSide(
                      color: selected ? AppColors.pink : AppColors.border,
                    ),
                    labelStyle: TextStyle(
                      fontSize: 11.5,
                      fontWeight: FontWeight.w600,
                      color: selected ? AppColors.white : AppColors.textDark,
                    ),
                  );
                },
              ),
            ),
            if (_showLocationField) ...[
              const SizedBox(height: 12),
              TextField(
                controller: _locationController,
                decoration: InputDecoration(
                  hintText: 'Add campus location...',
                  prefixIcon: const Icon(
                    Icons.location_on_outlined,
                    color: AppColors.pink,
                  ),
                  filled: true,
                  fillColor: AppColors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                    borderSide: const BorderSide(color: AppColors.border),
                  ),
                ),
              ),
              const SizedBox(height: 8),
              Wrap(
                spacing: 6,
                runSpacing: 6,
                children: _campusSpots
                    .map(
                      (spot) => ActionChip(
                        label: Text(spot, style: const TextStyle(fontSize: 11)),
                        backgroundColor: AppColors.cream,
                        onPressed: () {
                          setState(() => _locationController.text = spot);
                        },
                      ),
                    )
                    .toList(),
              ),
            ],
            if (_imagePaths.isNotEmpty || _videoPath != null) ...[
              const SizedBox(height: 14),
              _buildMediaPreview(),
            ],
            const SizedBox(height: 14),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
              decoration: BoxDecoration(
                color: AppColors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppColors.border),
              ),
              child: Wrap(
                spacing: 4,
                runSpacing: 4,
                alignment: WrapAlignment.spaceBetween,
                children: [
                  _buildToolbarButton(
                    icon: Icons.photo_library_rounded,
                    label: 'Photo',
                    color: AppColors.success,
                    onTap: _pickPhotos,
                  ),
                  _buildToolbarButton(
                    icon: Icons.videocam_rounded,
                    label: 'Video',
                    color: AppColors.coral,
                    onTap: _pickVideo,
                  ),
                  _buildToolbarButton(
                    icon: Icons.collections_rounded,
                    label: 'Campus Media',
                    color: AppColors.pink,
                    onTap: _showSampleMediaPicker,
                  ),
                  _buildToolbarButton(
                    icon: Icons.location_on_rounded,
                    label: 'Location',
                    color: AppColors.burgundy,
                    onTap: () => setState(
                      () => _showLocationField = !_showLocationField,
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
