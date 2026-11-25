import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../widgets/home/home_header_widget.dart';
import '../../widgets/home/story_list_widget.dart';
import '../../widgets/home/post_category_widget.dart';
import '../../widgets/home/create_post_shortcut_widget.dart';
import '../../widgets/home/post_card_widget.dart';
import '../../widgets/home/trending_post_widget.dart';
import '../../widgets/home/suggested_post_widget.dart';
import '../../widgets/home/feed_loading_widget.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String selectedCategory = 'All';
  bool isLoading = false;

  final List<String> categories = [
    'General',
    'Campus Life',
    'Academic',
    'Organization',
    'Events',
    'Promotion',
    'Entertainment',
  ];

  final List<Map<String, dynamic>> posts = [
    {
      'name': 'Garini Cinkalisty',
      'faculty': 'Teknik Informatika',
      'time': '10 min ago',
      'category': 'Campus Life',
      'content':
          'Hello Otter friends! Ada yang tahu kegiatan menarik di kampus minggu ini? Yuk sharing di sini! 🦦',
      'likes': 24,
      'comments': 8,
      'liked': false,
      'saved': false,
      'commentList': <String>[],
    },
    {
      'name': 'Georgina Gabriella',
      'faculty': 'Teknik Informatika',
      'time': '30 min ago',
      'category': 'Academic',
      'content':
          'Semangat untuk semua mahasiswa yang sedang mengerjakan tugas Mobile Programming! Jangan lupa istirahat juga. 💗',
      'likes': 18,
      'comments': 5,
      'liked': false,
      'saved': false,
      'commentList': <String>[],
    },
    {
      'name': 'Celine Aurora',
      'faculty': 'Teknik Informatika',
      'time': '1 hour ago',
      'category': 'Organization',
      'content':
          'Yuk ikut kegiatan organisasi kampus dan tambah pengalaman serta teman baru!',
      'likes': 32,
      'comments': 12,
      'liked': false,
      'saved': false,
      'commentList': <String>[],
    },
    {
      'name': 'Felicia Angeline',
      'faculty': 'Mahasiswa UNTAR',
      'time': '2 hours ago',
      'category': 'Events',
      'content': 'Jangan lupa cek informasi event kampus terbaru minggu ini!',
      'likes': 15,
      'comments': 4,
      'liked': false,
      'saved': false,
      'commentList': <String>[],
    },
  ];

  List<Map<String, dynamic>> get filteredPosts {
    if (selectedCategory == 'All') {
      return posts;
    }

    return posts.where((post) => post['category'] == selectedCategory).toList();
  }

  List<Map<String, dynamic>> get savedPosts {
    return posts.where((post) => post['saved'] == true).toList();
  }

  Future<void> _refreshFeed() async {
    setState(() {
      isLoading = true;
    });

    await Future.delayed(const Duration(seconds: 1));

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

  void _toggleLike(int index) {
    setState(() {
      final post = posts[index];
      post['liked'] = !(post['liked'] as bool);

      if (post['liked'] as bool) {
        post['likes'] = (post['likes'] as int) + 1;
      } else {
        post['likes'] = (post['likes'] as int) - 1;
      }
    });
  }

  void _toggleSave(int index) {
    setState(() {
      posts[index]['saved'] = !(posts[index]['saved'] as bool);
    });

    final isSaved = posts[index]['saved'] as bool;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          isSaved
              ? 'Postingan berhasil disimpan!'
              : 'Postingan dihapus dari Saved Posts.',
        ),
      ),
    );
  }

  Future<void> _sharePost(int index) async {
    final post = posts[index];

    final text = '${post['name']} di Otter.ly:\n\n${post['content']}';

    await Clipboard.setData(ClipboardData(text: text));

    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Konten postingan berhasil disalin!')),
    );
  }

  void _createPost() {
    final contentController = TextEditingController();
    String selectedPostCategory = 'General';

    showDialog(
      context: context,
      builder: (dialogContext) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              backgroundColor: const Color(0xFFFFFAF0),
              title: const Text(
                'Create Post',
                style: TextStyle(
                  color: Color(0xFFB0183D),
                  fontWeight: FontWeight.bold,
                ),
              ),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextField(
                      controller: contentController,
                      maxLines: 5,
                      decoration: InputDecoration(
                        hintText: "What's on your mind?",
                        filled: true,
                        fillColor: Colors.white,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                    const SizedBox(height: 15),
                    DropdownButtonFormField<String>(
                      initialValue: selectedCategory,
                      decoration: const InputDecoration(
                        labelText: 'Category',
                        border: OutlineInputBorder(),
                      ),
                      items: categories.map((category) {
                        return DropdownMenuItem(
                          value: category,
                          child: Text(category),
                        );
                      }).toList(),
                      onChanged: (value) {
                        if (value != null) {
                          setDialogState(() {
                            selectedPostCategory = value;
                          });
                        }
                      },
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(dialogContext);
                    contentController.dispose();
                  },
                  child: const Text('Cancel'),
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFE23C64),
                    foregroundColor: Colors.white,
                  ),
                  onPressed: () {
                    final content = contentController.text.trim();

                    if (content.isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Isi postingan terlebih dahulu.'),
                        ),
                      );
                      return;
                    }

                    setState(() {
                      posts.insert(0, {
                        'name': 'Otter Friend',
                        'faculty': 'Mahasiswa UNTAR',
                        'time': 'Just now',
                        'category': selectedPostCategory,
                        'content': content,
                        'likes': 0,
                        'comments': 0,
                        'liked': false,
                        'saved': false,
                        'commentList': <String>[],
                      });

                      selectedCategory = 'All';
                    });

                    Navigator.pop(dialogContext);
                    contentController.dispose();

                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Postingan berhasil dibuat!'),
                      ),
                    );
                  },
                  child: const Text('Publish'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  void _showComments(int index) {
    final controller = TextEditingController();
    final post = posts[index];

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      showDragHandle: true,
      backgroundColor: const Color(0xFFFFFAF0),
      builder: (sheetContext) {
        return StatefulBuilder(
          builder: (context, setSheetState) {
            final comments = post['commentList'] as List<String>;

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
                  Text('Postingan dari ${post['name']}'),
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
                        title: const Text(
                          'Otter Friend',
                          style: TextStyle(fontWeight: FontWeight.bold),
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
                            post['comments'] = (post['comments'] as int) + 1;
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
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: const Color(0xFFFFFAF0),
          title: Text('$name Story'),
          content: const Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              CircleAvatar(
                radius: 35,
                backgroundColor: Color(0xFFFFD464),
                child: Icon(Icons.pets, size: 35, color: Color(0xFFB0183D)),
              ),
              SizedBox(height: 15),
              Text('Welcome to Otter.ly! 🦦'),
              Text(
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

  void _showSavedPosts() {
    showModalBottomSheet(
      context: context,
      showDragHandle: true,
      builder: (context) {
        final saved = savedPosts;

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
                    title: Text(post['name'] as String),
                    subtitle: Text(
                      post['content'] as String,
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
    return Scaffold(
      backgroundColor: const Color(0xFFFFFAF0),
      body: SafeArea(
        child: RefreshIndicator(
          color: const Color(0xFFE23C64),
          onRefresh: _refreshFeed,
          child: ListView(
            padding: const EdgeInsets.all(18),
            children: [
              HomeHeaderWidget(
                userName: 'Otter Friend',
                onNotificationTap: _showSavedPosts,
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
                userName: 'Otter Friend',
                onTap: _createPost,
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
                  final index = posts.indexOf(post);

                  return Padding(
                    padding: const EdgeInsets.only(bottom: 16),
                    child: PostCardWidget(
                      userName: post['name'] as String,
                      faculty: post['faculty'] as String,
                      time: post['time'] as String,
                      category: post['category'] as String,
                      content: post['content'] as String,
                      likeCount: post['likes'] as int,
                      commentCount: post['comments'] as int,
                      isLiked: post['liked'] as bool,
                      isSaved: post['saved'] as bool,
                      onLike: () => _toggleLike(index),
                      onComment: () => _showComments(index),
                      onShare: () => _sharePost(index),
                      onSave: () => _toggleSave(index),
                    ),
                  );
                }),

              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
