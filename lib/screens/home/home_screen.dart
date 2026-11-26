import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/app_constants.dart';
import '../../models/friend_profile_model.dart';
import '../../providers/auth_provider.dart';
import '../../providers/social_profile_provider.dart';
import '../../widgets/home/create_post_shortcut_widget.dart';
import '../../widgets/home/feed_loading_widget.dart';
import '../../widgets/home/home_header_widget.dart';
import '../../widgets/home/post_card_widget.dart';
import '../../widgets/home/post_category_widget.dart';
import '../../widgets/home/story_list_widget.dart';
import '../../widgets/home/suggested_post_widget.dart';
import '../../widgets/home/trending_post_widget.dart';
import '../../widgets/media/post_composer_sheet.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  String selectedCategory = 'All';
  bool isLoading = false;
  final Map<String, List<String>> _commentsByPostId = {};

  Future<void> _refreshFeed() async {
    setState(() {
      isLoading = true;
    });

    await ref.read(socialProfileProvider.notifier).refresh();

    if (!mounted) return;

    setState(() {
      isLoading = false;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Feed berhasil diperbarui!'),
        duration: Duration(seconds: 1),
      ),
    );
  }

  Future<void> _toggleLike(String postId) async {
    await ref.read(socialProfileProvider.notifier).togglePostLike(postId);
  }

  Future<void> _toggleSave(ProfilePostItem post) async {
    final willSave = !post.isSaved;
    await ref.read(socialProfileProvider.notifier).togglePostSave(post.id);

    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          willSave
              ? 'Postingan berhasil disimpan!'
              : 'Postingan dihapus dari Saved Posts.',
        ),
      ),
    );
  }

  Future<void> _sharePost(ProfilePostItem post) async {
    final text = '${post.authorName} di Otter.ly:\n\n${post.content}';

    await Clipboard.setData(ClipboardData(text: text));

    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Konten postingan berhasil disalin!')),
    );
  }

  Future<void> _createPost({
    bool openCampusMedia = false,
    bool showLocation = false,
  }) async {
    final currentUser = ref.read(authProvider) ?? buildFallbackDemoUser();
    final result = await PostComposerSheet.show(
      context,
      authorName: currentUser.fullName,
      authorAvatar: currentUser.avatar,
      initialCategory: selectedCategory == 'All' ? 'General' : selectedCategory,
      initialOpenCampusMedia: openCampusMedia,
      initialShowLocation: showLocation,
    );

    if (result == null) return;

    await ref.read(socialProfileProvider.notifier).addProfilePost(
          author: currentUser,
          category: result.category,
          content: result.content,
          location: result.location,
          audience: result.audience,
          imagePaths: result.imagePaths,
          videoPath: result.videoPath,
        );

    if (!mounted) return;
    setState(() {
      selectedCategory = 'All';
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Postingan berhasil dibuat!'),
      ),
    );
  }

  Future<void> _editPost(ProfilePostItem post) async {
    final currentUser = ref.read(authProvider) ?? buildFallbackDemoUser();
    final result = await PostComposerSheet.show(
      context,
      authorName: currentUser.fullName,
      authorAvatar: currentUser.avatar,
      initialPost: post,
    );
    if (result == null) return;

    await ref.read(socialProfileProvider.notifier).updateProfilePost(
          postId: post.id,
          category: result.category,
          content: result.content,
          location: result.location,
          audience: result.audience,
          imagePaths: result.imagePaths,
          videoPath: result.videoPath,
        );
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Postingan berhasil diperbarui!')),
    );
  }

  Future<void> _deletePost(String postId) async {
    await ref.read(socialProfileProvider.notifier).deleteProfilePost(postId);
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Postingan dihapus.')),
    );
  }

  void _showComments(ProfilePostItem post) {
    final controller = TextEditingController();
    final currentUserName =
        ref.read(authProvider)?.fullName ?? 'Otter Friend';

    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      showDragHandle: true,
      backgroundColor: const Color(0xFFFFFAF0),
      builder: (sheetContext) {
        return StatefulBuilder(
          builder: (context, setSheetState) {
            final comments =
                _commentsByPostId.putIfAbsent(post.id, () => <String>[]);

            return Padding(
              padding: EdgeInsets.only(
                left: 20,
                right: 20,
                top: 10,
                bottom: MediaQuery.of(context).viewInsets.bottom + 20,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Comments',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFFB0183D),
                    ),
                  ),
                  const SizedBox(height: 15),
                  Text('Postingan dari ${post.authorName}'),
                  const SizedBox(height: 12),
                  if (comments.isEmpty)
                    const Padding(
                      padding: EdgeInsets.symmetric(vertical: 15),
                      child: Text('Belum ada komentar. Jadilah yang pertama!'),
                    )
                  else
                    ...comments.map(
                      (comment) => ListTile(
                        contentPadding: EdgeInsets.zero,
                        leading: const CircleAvatar(
                          backgroundColor: Color(0xFFFFD464),
                          child: Icon(Icons.person, color: Color(0xFFB0183D)),
                        ),
                        title: Text(
                          currentUserName,
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        subtitle: Text(comment),
                      ),
                    ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: controller,
                          decoration: InputDecoration(
                            hintText: 'Write a comment...',
                            filled: true,
                            fillColor: Colors.white,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(25),
                            ),
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 15,
                              vertical: 10,
                            ),
                          ),
                        ),
                      ),
                      IconButton(
                        icon: const Icon(
                          Icons.send_rounded,
                          color: Color(0xFFE23C64),
                        ),
                        onPressed: () {
                          final value = controller.text.trim();

                          if (value.isEmpty) return;

                          setState(() {
                            comments.add(value);
                          });

                          setSheetState(() {});
                          controller.clear();
                        },
                      ),
                    ],
                  ),
                ],
              ),
            );
          },
        );
      },
    ).whenComplete(controller.dispose);
  }

  void _showStory(String name) {
    showDialog<void>(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: const Color(0xFFFFFAF0),
          title: Text('$name Story'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              CircleAvatar(
                radius: 35,
                backgroundColor: const Color(0xFFFFD464),
                backgroundImage: AssetImage(AppConstants.pinkAvatarPath),
              ),
              const SizedBox(height: 15),
              const Text('Welcome to Otter.ly! 🦦'),
              const Text(
                'Story preview menggunakan data demo.',
                style: TextStyle(fontSize: 12, color: Color(0xFF8B7479)),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Close'),
            ),
          ],
        );
      },
    );
  }

  void _showSavedPosts(List<ProfilePostItem> saved) {
    showModalBottomSheet<void>(
      context: context,
      showDragHandle: true,
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Saved Posts',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFFB0183D),
                ),
              ),
              const SizedBox(height: 12),
              if (saved.isEmpty)
                const Padding(
                  padding: EdgeInsets.all(20),
                  child: Center(child: Text('Belum ada postingan tersimpan.')),
                )
              else
                ...saved.map(
                  (post) => ListTile(
                    leading: const Icon(
                      Icons.bookmark,
                      color: Color(0xFFE23C64),
                    ),
                    title: Text(post.authorName),
                    subtitle: Text(
                      post.content,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ),
            ],
          ),
        );
      },
    );
  }

  void _selectSuggestedCategory(String category) {
    setState(() {
      selectedCategory = category;
    });

    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text('Menampilkan kategori $category')));
  }

  @override
  Widget build(BuildContext context) {
    final currentUser = ref.watch(authProvider);
    final displayName = currentUser?.fullName ?? 'Otter Friend';
    final socialState = ref.watch(socialProfileProvider);
    final allPosts = socialState.posts;
    final filteredPosts = selectedCategory == 'All'
        ? allPosts
        : allPosts.where((post) => post.category == selectedCategory).toList();
    final saved = socialState.savedPosts;

    return Scaffold(
      backgroundColor: const Color(0xFFFFFAF0),
      body: SafeArea(
        child: RefreshIndicator(
          color: const Color(0xFFE23C64),
          onRefresh: _refreshFeed,
          child: Align(
            alignment: Alignment.topCenter,
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 620),
              child: ListView(
            padding: const EdgeInsets.all(18),
            children: [
              HomeHeaderWidget(
                userName: displayName,
                onNotificationTap: () => _showSavedPosts(saved),
              ),

              const SizedBox(height: 22),

              const Text(
                'Your Campus Stories',
                style: TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF38252A),
                ),
              ),

              const SizedBox(height: 12),

              StoryListWidget(onStoryTap: _showStory),

              const SizedBox(height: 18),

              CreatePostShortcutWidget(
                userName: displayName,
                onTap: _createPost,
                onPhotoTap: () => _createPost(openCampusMedia: true),
                onVideoTap: () => _createPost(openCampusMedia: true),
                onLocationTap: () => _createPost(showLocation: true),
              ),

              const SizedBox(height: 22),

              const Text(
                'Explore Topics',
                style: TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF38252A),
                ),
              ),

              const SizedBox(height: 12),

              PostCategoryWidget(
                selectedCategory: selectedCategory,
                onCategorySelected: (category) {
                  setState(() {
                    selectedCategory = category;
                  });
                },
              ),

              const SizedBox(height: 22),

              const Text(
                'Trending on Campus 🔥',
                style: TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF38252A),
                ),
              ),

              const SizedBox(height: 12),

              SizedBox(
                height: 135,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  children: const [
                    TrendingPostWidget(
                      title: 'Tips survive tugas kuliah!',
                      category: 'Academic',
                      likes: 120,
                    ),
                    SizedBox(width: 12),
                    TrendingPostWidget(
                      title: 'Kegiatan seru mahasiswa UNTAR',
                      category: 'Campus Life',
                      likes: 95,
                    ),
                    SizedBox(width: 12),
                    TrendingPostWidget(
                      title: 'Info event kampus terbaru',
                      category: 'Events',
                      likes: 80,
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 22),

              const Text(
                'Suggested for You',
                style: TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF38252A),
                ),
              ),

              const SizedBox(height: 12),

              SuggestedPostWidget(
                title: 'Campus Community',
                description: 'Explore campus life discussions',
                icon: Icons.groups_rounded,
                onTap: () => _selectSuggestedCategory('Campus Life'),
              ),

              const SizedBox(height: 22),

              Row(
                children: [
                  const Expanded(
                    child: Text(
                      'Latest Posts',
                      style: TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF38252A),
                      ),
                    ),
                  ),
                  Text(
                    '${filteredPosts.length} posts',
                    style: const TextStyle(
                      fontSize: 12,
                      color: Color(0xFF8B7479),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 12),

              if (isLoading) const FeedLoadingWidget(),

              if (!isLoading && filteredPosts.isEmpty)
                const Padding(
                  padding: EdgeInsets.all(25),
                  child: Center(
                    child: Text(
                      'Belum ada postingan di kategori ini.',
                      style: TextStyle(color: Color(0xFF8B7479)),
                    ),
                  ),
                ),

              if (!isLoading)
                ...filteredPosts.map((post) {
                  final localCommentCount =
                      post.commentsCount +
                      (_commentsByPostId[post.id]?.length ?? 0);

                  return Padding(
                    padding: const EdgeInsets.only(bottom: 16),
                    child: PostCardWidget(
                      userName: post.authorName,
                      faculty: post.faculty,
                      time: post.timeAgo,
                      category: post.category,
                      content: post.content,
                      likeCount: post.likesCount,
                      commentCount: localCommentCount,
                      isLiked: post.isLiked,
                      isSaved: post.isSaved,
                      imagePaths: post.imagePaths,
                      videoPath: post.videoPath,
                      location: post.location,
                      audience: post.audience,
                      onLike: () => _toggleLike(post.id),
                      onComment: () => _showComments(post),
                      onShare: () => _sharePost(post),
                      onSave: () => _toggleSave(post),
                      onEdit: post.isOwnPost ? () => _editPost(post) : null,
                      onDelete:
                          post.isOwnPost ? () => _deletePost(post.id) : null,
                    ),
                  );
                }),

              const SizedBox(height: 20),
            ],
          ),
            ),
          ),
        ),
      ),
    );
  }
}
