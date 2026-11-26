import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/app_colors.dart';
import '../../models/friend_profile_model.dart';
import '../../providers/social_profile_provider.dart';
import '../../widgets/friends/friend_request_card_widget.dart';
import '../../widgets/friends/friend_user_card_widget.dart';
import '../../widgets/friends/mutual_friends_sheet_widget.dart';
import '../profile/profile_screen.dart';

class FriendsScreen extends ConsumerStatefulWidget {
  final int initialTabIndex;

  const FriendsScreen({
    super.key,
    this.initialTabIndex = 0,
  });

  @override
  ConsumerState<FriendsScreen> createState() => _FriendsScreenState();
}

class _FriendsScreenState extends ConsumerState<FriendsScreen>
    with SingleTickerProviderStateMixin {
  late final TabController _tabController;
  final TextEditingController _discoverSearchController = TextEditingController();
  final TextEditingController _friendsSearchController = TextEditingController();
  String _friendsFilterQuery = '';

  static const List<String> _facultyFilters = [
    'All',
    'Faculty of Information Technology',
    'Faculty of Economics and Business',
    'Faculty of Engineering',
    'Faculty of Psychology',
    'Faculty of Art and Design',
    'Faculty of Law',
    'Faculty of Communication Sciences',
  ];

  @override
  void initState() {
    super.initState();
    final clampedIndex = widget.initialTabIndex.clamp(0, 2);
    _tabController = TabController(
      length: 3,
      vsync: this,
      initialIndex: clampedIndex,
    );
    _discoverSearchController.text =
        ref.read(socialProfileProvider).searchQuery;
  }

  @override
  void dispose() {
    _tabController.dispose();
    _discoverSearchController.dispose();
    _friendsSearchController.dispose();
    super.dispose();
  }

  void _openStudentProfile(String studentId) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => ProfileScreen(
          studentId: studentId,
          showAppBar: true,
        ),
      ),
    );
  }

  void _showSnack(String message, {Color background = AppColors.burgundy}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: background,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  Future<void> _confirmRemoveFriend(StudentProfileModel student) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        backgroundColor: AppColors.background,
        title: const Text(
          'Remove Friend',
          style: TextStyle(
            color: AppColors.burgundy,
            fontWeight: FontWeight.bold,
          ),
        ),
        content: Text(
          'Remove ${student.fullName} from your UNTAR friend list?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, false),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.pink,
              foregroundColor: AppColors.white,
              minimumSize: const Size(0, 40),
            ),
            onPressed: () => Navigator.pop(dialogContext, true),
            child: const Text('Remove'),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      await ref.read(socialProfileProvider.notifier).removeFriend(student.id);
      if (mounted) {
        _showSnack('Removed ${student.fullName} from friends.');
      }
    }
  }

  Future<void> _confirmBlockUser(StudentProfileModel student) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        backgroundColor: AppColors.background,
        title: const Text(
          'Block Student',
          style: TextStyle(
            color: AppColors.error,
            fontWeight: FontWeight.bold,
          ),
        ),
        content: Text(
          'Block ${student.fullName}? They will no longer appear in your friend list or suggestions.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, false),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.error,
              foregroundColor: AppColors.white,
              minimumSize: const Size(0, 40),
            ),
            onPressed: () => Navigator.pop(dialogContext, true),
            child: const Text('Block'),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      await ref.read(socialProfileProvider.notifier).blockUser(student.id);
      if (mounted) {
        _showSnack('Blocked ${student.fullName}.');
      }
    }
  }

  void _showBlockedUsersSheet() {
    showModalBottomSheet<void>(
      context: context,
      showDragHandle: true,
      backgroundColor: AppColors.background,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (sheetContext) => Consumer(
        builder: (context, ref, _) {
          final blocked = ref.watch(socialProfileProvider).blockedUsers;
          return SafeArea(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 4, 20, 20),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Blocked Students',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: AppColors.burgundy,
                    ),
                  ),
                  const SizedBox(height: 12),
                  if (blocked.isEmpty)
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: AppColors.white,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: AppColors.border),
                      ),
                      child: const Text(
                        'You have not blocked anyone.',
                        textAlign: TextAlign.center,
                        style: TextStyle(color: AppColors.textSecondary),
                      ),
                    )
                  else
                    Flexible(
                      child: ListView.separated(
                        shrinkWrap: true,
                        itemCount: blocked.length,
                        separatorBuilder: (_, __) => const SizedBox(height: 8),
                        itemBuilder: (_, index) {
                          final student = blocked[index];
                          return ListTile(
                            tileColor: AppColors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(14),
                              side: const BorderSide(color: AppColors.border),
                            ),
                            leading: CircleAvatar(
                              backgroundColor: AppColors.cream,
                              backgroundImage: AssetImage(student.avatar),
                            ),
                            title: Text(
                              student.fullName,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 14,
                              ),
                            ),
                            subtitle: Text('@${student.username}'),
                            trailing: TextButton(
                              onPressed: () async {
                                await ref
                                    .read(socialProfileProvider.notifier)
                                    .unblockUser(student.id);
                                if (mounted) {
                                  _showSnack(
                                    'Unblocked ${student.fullName}.',
                                    background: AppColors.success,
                                  );
                                }
                              },
                              child: const Text('Unblock'),
                            ),
                          );
                        },
                      ),
                    ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Future<void> _handleCardPrimaryAction(StudentProfileModel student) async {
    final notifier = ref.read(socialProfileProvider.notifier);
    switch (student.friendshipStatus) {
      case FriendshipStatus.none:
        await notifier.sendFriendRequest(student.id);
        if (mounted) {
          _showSnack(
            'Friend request sent to ${student.fullName}!',
            background: AppColors.success,
          );
        }
      case FriendshipStatus.requestedSent:
        await notifier.cancelFriendRequest(student.id);
        if (mounted) {
          _showSnack('Friend request cancelled.');
        }
      case FriendshipStatus.requestedReceived:
        await notifier.acceptFriendRequest(student.id);
        if (mounted) {
          _showSnack(
            'You are now friends with ${student.fullName}!',
            background: AppColors.success,
          );
        }
      case FriendshipStatus.friends:
        await _confirmRemoveFriend(student);
      case FriendshipStatus.blocked:
        break;
    }
  }

  Widget _buildDiscoverTab(SocialProfileState state) {
    final notifier = ref.read(socialProfileProvider.notifier);
    final suggestions = state.suggestions;
    final directory = state.filteredDirectory;
    final showSuggestionsHighlight =
        state.searchQuery.trim().isEmpty &&
        state.selectedFacultyFilter == 'All' &&
        suggestions.isNotEmpty;

    return RefreshIndicator(
      color: AppColors.pink,
      onRefresh: notifier.refresh,
      child: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          TextField(
            controller: _discoverSearchController,
            onChanged: notifier.updateSearchQuery,
            decoration: InputDecoration(
              hintText: 'Find UNTAR friends by name, @username, NIM...',
              prefixIcon: const Icon(
                Icons.search_rounded,
                color: AppColors.burgundy,
              ),
              suffixIcon: state.searchQuery.isNotEmpty
                  ? IconButton(
                      icon: const Icon(Icons.clear_rounded),
                      onPressed: () {
                        _discoverSearchController.clear();
                        notifier.updateSearchQuery('');
                      },
                    )
                  : null,
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
            height: 38,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: _facultyFilters.length,
              separatorBuilder: (_, __) => const SizedBox(width: 8),
              itemBuilder: (context, index) {
                final faculty = _facultyFilters[index];
                final selected = state.selectedFacultyFilter == faculty;
                final shortLabel = faculty == 'All'
                    ? 'All Faculties'
                    : faculty.replaceFirst('Faculty of ', '');
                return ChoiceChip(
                  label: Text(shortLabel),
                  selected: selected,
                  onSelected: (_) => notifier.updateFacultyFilter(faculty),
                  selectedColor: AppColors.pink,
                  backgroundColor: AppColors.white,
                  side: BorderSide(
                    color: selected ? AppColors.pink : AppColors.border,
                  ),
                  labelStyle: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: selected ? AppColors.white : AppColors.textDark,
                  ),
                );
              },
            ),
          ),
          if (showSuggestionsHighlight) ...[
            const SizedBox(height: 20),
            Row(
              children: [
                const Expanded(
                  child: Text(
                    'Friend Suggestions',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: AppColors.burgundy,
                    ),
                  ),
                ),
                Text(
                  '${suggestions.length} suggested',
                  style: const TextStyle(
                    fontSize: 12,
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            SizedBox(
              height: 224,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemCount: suggestions.length,
                separatorBuilder: (_, __) => const SizedBox(width: 12),
                itemBuilder: (context, index) {
                  final student = suggestions[index];
                  final mutualCount = state.mutualFriendsFor(student).length;
                  return Container(
                    width: 168,
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: AppColors.white,
                      borderRadius: BorderRadius.circular(18),
                      border: Border.all(color: AppColors.border),
                    ),
                    child: InkWell(
                      onTap: () => _openStudentProfile(student.id),
                      child: Column(
                        children: [
                          CircleAvatar(
                            radius: 30,
                            backgroundColor: AppColors.cream,
                            backgroundImage: AssetImage(student.avatar),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            student.fullName,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 13.5,
                              color: AppColors.textDark,
                            ),
                          ),
                          Text(
                            student.studyProgram,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              fontSize: 11,
                              color: AppColors.textSecondary,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            mutualCount > 0
                                ? '$mutualCount mutual friend${mutualCount > 1 ? 's' : ''}'
                                : 'Angkatan ${student.entryYear}',
                            style: const TextStyle(
                              fontSize: 11,
                              color: AppColors.burgundy,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const Spacer(),
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              onPressed: () =>
                                  _handleCardPrimaryAction(student),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppColors.pink,
                                foregroundColor: AppColors.white,
                                elevation: 0,
                                minimumSize: const Size(0, 34),
                                padding: EdgeInsets.zero,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(11),
                                ),
                              ),
                              child: const Text(
                                'Add Friend',
                                style: TextStyle(fontSize: 12),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
          const SizedBox(height: 20),
          Row(
            children: [
              const Expanded(
                child: Text(
                  'UNTAR Student Directory',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: AppColors.burgundy,
                  ),
                ),
              ),
              Text(
                '${directory.length} students',
                style: const TextStyle(
                  fontSize: 12,
                  color: AppColors.textSecondary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          if (directory.isEmpty)
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: AppColors.white,
                borderRadius: BorderRadius.circular(18),
                border: Border.all(color: AppColors.border),
              ),
              child: const Column(
                children: [
                  Icon(
                    Icons.person_search_rounded,
                    size: 42,
                    color: AppColors.textSecondary,
                  ),
                  SizedBox(height: 10),
                  Text(
                    'No matching students found.',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: AppColors.textDark,
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    'Try searching another name, faculty, or NIM.',
                    style: TextStyle(
                      fontSize: 12,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            )
          else
            ...directory.map((student) {
              final mutuals = state.mutualFriendsFor(student);
              return FriendUserCardWidget(
                student: student,
                mutualFriendsCount: mutuals.length,
                onTapProfile: () => _openStudentProfile(student.id),
                onPrimaryFriendAction: () => _handleCardPrimaryAction(student),
                onToggleFollow: () => notifier.toggleFollow(student.id),
                onViewMutuals: () => MutualFriendsSheetWidget.show(
                  context,
                  targetName: student.fullName,
                  mutualFriends: mutuals,
                  onSelectStudent: (friend) => _openStudentProfile(friend.id),
                ),
                onRemoveFriend: student.friendshipStatus ==
                        FriendshipStatus.friends
                    ? () => _confirmRemoveFriend(student)
                    : null,
                onBlockUser: () => _confirmBlockUser(student),
              );
            }),
        ],
      ),
    );
  }

  Widget _buildRequestsTab(SocialProfileState state) {
    final notifier = ref.read(socialProfileProvider.notifier);
    final incoming = state.incomingRequests;
    final sent = state.sentRequests;

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Row(
          children: [
            const Expanded(
              child: Text(
                'Incoming Friend Requests',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: AppColors.burgundy,
                ),
              ),
            ),
            Text(
              '${incoming.length} pending',
              style: const TextStyle(
                fontSize: 12,
                color: AppColors.textSecondary,
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
        if (incoming.isEmpty)
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: AppColors.white,
              borderRadius: BorderRadius.circular(18),
              border: Border.all(color: AppColors.border),
            ),
            child: const Text(
              'No incoming friend requests right now.',
              textAlign: TextAlign.center,
              style: TextStyle(color: AppColors.textSecondary),
            ),
          )
        else
          ...incoming.map((student) {
            final mutuals = state.mutualFriendsFor(student);
            return FriendRequestCardWidget(
              student: student,
              mutualFriendsCount: mutuals.length,
              onTapProfile: () => _openStudentProfile(student.id),
              onAccept: () async {
                await notifier.acceptFriendRequest(student.id);
                if (mounted) {
                  _showSnack(
                    'Accepted ${student.fullName}!',
                    background: AppColors.success,
                  );
                }
              },
              onDecline: () async {
                await notifier.declineFriendRequest(student.id);
                if (mounted) {
                  _showSnack('Declined request from ${student.fullName}.');
                }
              },
              onViewMutuals: () => MutualFriendsSheetWidget.show(
                context,
                targetName: student.fullName,
                mutualFriends: mutuals,
                onSelectStudent: (friend) => _openStudentProfile(friend.id),
              ),
            );
          }),
        const SizedBox(height: 20),
        Row(
          children: [
            const Expanded(
              child: Text(
                'Sent Requests',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: AppColors.burgundy,
                ),
              ),
            ),
            Text(
              '${sent.length} sent',
              style: const TextStyle(
                fontSize: 12,
                color: AppColors.textSecondary,
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
        if (sent.isEmpty)
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: AppColors.white,
              borderRadius: BorderRadius.circular(18),
              border: Border.all(color: AppColors.border),
            ),
            child: const Text(
              'No outgoing friend requests.',
              textAlign: TextAlign.center,
              style: TextStyle(color: AppColors.textSecondary),
            ),
          )
        else
          ...sent.map((student) {
            final mutuals = state.mutualFriendsFor(student);
            return FriendUserCardWidget(
              student: student,
              mutualFriendsCount: mutuals.length,
              onTapProfile: () => _openStudentProfile(student.id),
              onPrimaryFriendAction: () => _handleCardPrimaryAction(student),
              onToggleFollow: () => notifier.toggleFollow(student.id),
              onViewMutuals: () => MutualFriendsSheetWidget.show(
                context,
                targetName: student.fullName,
                mutualFriends: mutuals,
                onSelectStudent: (friend) => _openStudentProfile(friend.id),
              ),
              onBlockUser: () => _confirmBlockUser(student),
            );
          }),
      ],
    );
  }

  Widget _buildMyFriendsTab(SocialProfileState state) {
    final notifier = ref.read(socialProfileProvider.notifier);
    final query = _friendsFilterQuery.trim().toLowerCase();
    final friends = state.friends.where((friend) {
      if (query.isEmpty) return true;
      return friend.fullName.toLowerCase().contains(query) ||
          friend.username.toLowerCase().contains(query) ||
          friend.studyProgram.toLowerCase().contains(query);
    }).toList();

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        TextField(
          controller: _friendsSearchController,
          onChanged: (value) => setState(() => _friendsFilterQuery = value),
          decoration: InputDecoration(
            hintText: 'Search your friend list...',
            prefixIcon: const Icon(
              Icons.search_rounded,
              color: AppColors.burgundy,
            ),
            suffixIcon: _friendsFilterQuery.isNotEmpty
                ? IconButton(
                    icon: const Icon(Icons.clear_rounded),
                    onPressed: () {
                      _friendsSearchController.clear();
                      setState(() => _friendsFilterQuery = '');
                    },
                  )
                : null,
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
        const SizedBox(height: 16),
        Row(
          children: [
            const Expanded(
              child: Text(
                'Connected Friends',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: AppColors.burgundy,
                ),
              ),
            ),
            Text(
              '${friends.length} friends',
              style: const TextStyle(
                fontSize: 12,
                color: AppColors.textSecondary,
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
        if (friends.isEmpty)
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: AppColors.white,
              borderRadius: BorderRadius.circular(18),
              border: Border.all(color: AppColors.border),
            ),
            child: Column(
              children: [
                const Icon(
                  Icons.people_outline_rounded,
                  size: 42,
                  color: AppColors.textSecondary,
                ),
                const SizedBox(height: 8),
                const Text(
                  'No friends to show here yet.',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: AppColors.textDark,
                  ),
                ),
                const SizedBox(height: 6),
                TextButton(
                  onPressed: () => _tabController.animateTo(0),
                  child: const Text('Find UNTAR Friends'),
                ),
              ],
            ),
          )
        else
          ...friends.map((student) {
            final mutuals = state.mutualFriendsFor(student);
            return FriendUserCardWidget(
              student: student,
              mutualFriendsCount: mutuals.length,
              onTapProfile: () => _openStudentProfile(student.id),
              onPrimaryFriendAction: () => _confirmRemoveFriend(student),
              onToggleFollow: () => notifier.toggleFollow(student.id),
              onViewMutuals: () => MutualFriendsSheetWidget.show(
                context,
                targetName: student.fullName,
                mutualFriends: mutuals,
                onSelectStudent: (friend) => _openStudentProfile(friend.id),
              ),
              onRemoveFriend: () => _confirmRemoveFriend(student),
              onBlockUser: () => _confirmBlockUser(student),
            );
          }),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final socialState = ref.watch(socialProfileProvider);
    final incomingCount = socialState.incomingRequests.length;
    final friendsCount = socialState.friends.length;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        title: const Text(
          'Friends & Connections',
          style: TextStyle(
            color: AppColors.burgundy,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          IconButton(
            tooltip: 'Blocked Users',
            onPressed: _showBlockedUsersSheet,
            icon: const Icon(
              Icons.block_rounded,
              color: AppColors.burgundy,
            ),
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          labelColor: AppColors.pink,
          unselectedLabelColor: AppColors.textSecondary,
          indicatorColor: AppColors.pink,
          tabs: [
            const Tab(text: 'Discover'),
            Tab(
              text: incomingCount > 0 ? 'Requests ($incomingCount)' : 'Requests',
            ),
            Tab(text: 'Friends ($friendsCount)'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildDiscoverTab(socialState),
          _buildRequestsTab(socialState),
          _buildMyFriendsTab(socialState),
        ],
      ),
    );
  }
}
