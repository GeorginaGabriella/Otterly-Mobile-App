import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:otterly/core/app_constants.dart';
import 'package:otterly/models/friend_profile_model.dart';
import 'package:otterly/models/user_model.dart';
import 'package:otterly/providers/auth_provider.dart';
import 'package:otterly/providers/social_profile_provider.dart';
import 'package:otterly/screens/friends/friends_screen.dart';
import 'package:otterly/screens/home/home_screen.dart';
import 'package:otterly/screens/navigation/main_navigation.dart';
import 'package:otterly/screens/profile/edit_profile_screen.dart';
import 'package:otterly/screens/profile/profile_screen.dart';
import 'package:otterly/widgets/media/post_composer_sheet.dart';
import 'package:otterly/widgets/media/post_media_gallery_widget.dart';
import 'package:otterly/widgets/media/post_video_player_widget.dart';

void main() {
  setUp(() {
    SharedPreferences.setMockInitialValues({});
  });

  group('UserModel & SocialProfileProvider unit tests', () {
    test('UserModel parses legacy JSON and builds effectiveUsername', () {
      final legacy = UserModel.fromJson({
        'id': 'u1',
        'fullName': 'Felicia Angeline',
        'nim': '535250029',
        'email': 'felicia@stu.untar.ac.id',
        'faculty': 'Faculty of Information Technology',
        'studyProgram': 'Informatics',
        'entryYear': '2025',
        'avatar': AppConstants.pinkAvatarPath,
        'isVerified': true,
      });

      expect(legacy.effectiveUsername, 'felicia.angeline');
      expect(legacy.isPrivate, isFalse);
      expect(legacy.coverPreset, 'sunset');

      final edited = legacy.copyWith(
        username: '@felicia.dev',
        bio: 'Flutter builder',
        isPrivate: true,
      );
      expect(edited.effectiveUsername, 'felicia.dev');
      expect(edited.bio, 'Flutter builder');
      expect(edited.isPrivate, isTrue);
    });

    test('Friend request, accept, follow, block, and post flows update state', () async {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      // Initialize provider and let initial microtask load complete.
      container.read(socialProfileProvider);
      await Future<void>.delayed(const Duration(milliseconds: 50));

      final notifier = container.read(socialProfileProvider.notifier);
      var state = container.read(socialProfileProvider);

      expect(state.friends, isNotEmpty);
      expect(state.incomingRequests, isNotEmpty);
      expect(state.suggestions, isNotEmpty);

      // Send and cancel friend request.
      final targetSuggestion = state.suggestions.first;
      await notifier.sendFriendRequest(targetSuggestion.id);
      state = container.read(socialProfileProvider);
      expect(
        state.findStudentById(targetSuggestion.id)?.friendshipStatus,
        FriendshipStatus.requestedSent,
      );

      await notifier.cancelFriendRequest(targetSuggestion.id);
      state = container.read(socialProfileProvider);
      expect(
        state.findStudentById(targetSuggestion.id)?.friendshipStatus,
        FriendshipStatus.none,
      );

      // Accept incoming friend request.
      final incoming = state.incomingRequests.first;
      final beforeFriends = state.friends.length;
      await notifier.acceptFriendRequest(incoming.id);
      state = container.read(socialProfileProvider);
      expect(state.friends.length, beforeFriends + 1);
      expect(
        state.findStudentById(incoming.id)?.friendshipStatus,
        FriendshipStatus.friends,
      );

      // Follow & unfollow.
      final followTarget = state.suggestions.first;
      final initialFollowers = followTarget.followersCount;
      await notifier.toggleFollow(followTarget.id);
      state = container.read(socialProfileProvider);
      expect(state.findStudentById(followTarget.id)?.isFollowing, isTrue);
      expect(
        state.findStudentById(followTarget.id)?.followersCount,
        initialFollowers + 1,
      );

      // Block & unblock hides from filteredDirectory.
      await notifier.blockUser(followTarget.id);
      state = container.read(socialProfileProvider);
      expect(
        state.blockedUsers.any((u) => u.id == followTarget.id),
        isTrue,
      );
      expect(
        state.filteredDirectory.any((u) => u.id == followTarget.id),
        isFalse,
      );

      await notifier.unblockUser(followTarget.id);
      state = container.read(socialProfileProvider);
      expect(
        state.blockedUsers.any((u) => u.id == followTarget.id),
        isFalse,
      );

      // Profile posts: add, like, save, delete.
      final initialMyPosts = state.myPosts.length;
      await notifier.addProfilePost(
        author: buildFallbackDemoUser(),
        category: 'Academic',
        content: 'Testing Otter.ly profile post creation!',
      );
      state = container.read(socialProfileProvider);
      expect(state.myPosts.length, initialMyPosts + 1);

      final createdPost = state.myPosts.first;
      await notifier.togglePostLike(createdPost.id);
      await notifier.togglePostSave(createdPost.id);
      state = container.read(socialProfileProvider);
      expect(
        state.myPosts.firstWhere((p) => p.id == createdPost.id).isLiked,
        isTrue,
      );
      expect(
        state.savedPosts.any((p) => p.id == createdPost.id),
        isTrue,
      );

      await notifier.deleteProfilePost(createdPost.id);
      state = container.read(socialProfileProvider);
      expect(state.myPosts.length, initialMyPosts);
    });
  });

  group('Profile & Friends widget tests', () {
    testWidgets('ProfileScreen displays user info, stats, and post tabs', (tester) async {
      await tester.pumpWidget(
        const ProviderScope(
          child: MaterialApp(
            home: ProfileScreen(showAppBar: true),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('Felicia Angeline'), findsAtLeastNWidgets(1));
      expect(find.text('@felicia.angeline'), findsOneWidget);
      expect(find.text('Friends'), findsOneWidget);
      expect(find.text('Followers'), findsOneWidget);
      expect(find.text('Following'), findsOneWidget);

      await tester.scrollUntilVisible(
        find.text('Student Information'),
        200,
        scrollable: find.byType(Scrollable).first,
      );
      expect(find.text('Student Information'), findsOneWidget);

      // Switch to Saved posts tab.
      await tester.scrollUntilVisible(
        find.textContaining('Saved ('),
        200,
        scrollable: find.byType(Scrollable).first,
      );
      await tester.tap(find.textContaining('Saved ('));
      await tester.pumpAndSettle();

      expect(find.textContaining('Garini Cinkalisty'), findsAtLeastNWidgets(1));
    });

    testWidgets('EditProfileScreen updates user profile details', (tester) async {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      await tester.pumpWidget(
        UncontrolledProviderScope(
          container: container,
          child: const MaterialApp(
            home: EditProfileScreen(),
          ),
        ),
      );
      await tester.pumpAndSettle();

      final nameField = find.widgetWithText(TextFormField, 'Felicia Angeline');
      await tester.enterText(nameField, 'Felicia Angeline Updated');

      await tester.ensureVisible(find.text('Save Changes'));
      await tester.tap(find.text('Save Changes'));
      await tester.pumpAndSettle();

      expect(
        container.read(authProvider)?.fullName,
        'Felicia Angeline Updated',
      );
    });

    testWidgets('FriendsScreen searches, accepts requests, and shows friends', (tester) async {
      await tester.pumpWidget(
        const ProviderScope(
          child: MaterialApp(
            home: FriendsScreen(),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('Friends & Connections'), findsOneWidget);
      expect(find.text('Friend Suggestions'), findsOneWidget);

      // Search for a student by name.
      await tester.enterText(
        find.byType(TextField).first,
        'Nadia Santoso',
      );
      await tester.pumpAndSettle();
      expect(find.text('Nadia Santoso'), findsAtLeastNWidgets(1));
      expect(find.textContaining('@nadiasantoso'), findsOneWidget);

      // Switch to Requests tab and accept Fransiska.
      await tester.tap(find.textContaining('Requests'));
      await tester.pumpAndSettle();
      expect(find.text('Fransiska'), findsOneWidget);

      await tester.tap(find.text('Accept').first);
      await tester.pumpAndSettle();

      // Switch to Friends tab and confirm Fransiska is now connected.
      await tester.tap(find.textContaining('Friends ('));
      await tester.pumpAndSettle();
      await tester.enterText(
        find.byWidgetPredicate(
          (w) =>
              w is TextField &&
              w.decoration?.hintText == 'Search your friend list...',
        ),
        'Fransiska',
      );
      await tester.pumpAndSettle();
      expect(find.text('Fransiska'), findsAtLeastNWidgets(1));
      expect(find.textContaining('@fransiska.untar'), findsOneWidget);

      // Tap Fransiska's card to open her profile page.
      await tester.tap(find.textContaining('@fransiska.untar'));
      await tester.pumpAndSettle();
      expect(find.byType(ProfileScreen), findsOneWidget);
      expect(find.text('Student Information'), findsNothing);
    });

    testWidgets('PostMediaGalleryWidget & PostVideoPlayerWidget render Facebook-style media', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SingleChildScrollView(
              child: Column(
                children: const [
                  PostMediaGalleryWidget(
                    imagePaths: [
                      'assets/images/onboarding/onboarding_1_welcome.png',
                      'assets/images/onboarding/onboarding_2_connect.png',
                      'assets/images/onboarding/onboarding_3_campus.png',
                      'assets/images/otter_logo.png',
                      'assets/images/otter_pink.png',
                    ],
                  ),
                  SizedBox(height: 12),
                  PostVideoPlayerWidget(
                    videoPath: AppConstants.campusVideoPath,
                  ),
                ],
              ),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      // 5 images shows 2x2 grid with +1 overlay badge.
      expect(find.text('+1'), findsOneWidget);
      expect(find.text('VIDEO'), findsOneWidget);

      // Tap first image to open lightbox.
      await tester.tap(
        find
            .descendant(
              of: find.byType(PostMediaGalleryWidget),
              matching: find.byType(GestureDetector),
            )
            .first,
      );
      await tester.pumpAndSettle();
      expect(find.text('1 / 5'), findsOneWidget);

      await tester.tap(find.byIcon(Icons.close_rounded));
      await tester.pumpAndSettle();

      // Toggle fallback play/pause on video player without crash.
      await tester.tap(find.byIcon(Icons.play_arrow_rounded).first);
      await tester.pump();
    });

    testWidgets('PostComposerSheet supports attaching campus photos, video, and publishing', (tester) async {
      PostComposerResult? captured;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: PostComposerSheet(
              authorName: 'Felicia Angeline',
              asFullPage: true,
              onPublish: (res) => captured = res,
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      await tester.enterText(
        find.byType(TextField).first,
        'Sharing campus photos & video!',
      );
      await tester.tap(find.text('Campus Media'));
      await tester.pumpAndSettle();
      expect(find.text('Campus Media Gallery'), findsOneWidget);

      await tester.tap(find.text('Otter.ly UNTAR Campus Reel (MP4)'));
      await tester.pumpAndSettle();
      expect(find.byType(PostVideoPlayerWidget), findsOneWidget);

      await tester.tap(find.text('Post'));
      await tester.pumpAndSettle();

      expect(captured, isNotNull);
      expect(captured!.content, 'Sharing campus photos & video!');
      expect(captured!.videoPath, AppConstants.campusVideoPath);
    });

    testWidgets('HomeScreen displays media posts and navigates Create tab', (tester) async {
      await tester.pumpWidget(
        const ProviderScope(
          child: MaterialApp(
            home: MainNavigation(),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.byType(HomeScreen), findsOneWidget);

      // Tap Create tab in bottom bar and confirm PostComposerSheet appears.
      await tester.tap(find.text('Create'));
      await tester.pumpAndSettle();
      expect(find.byType(PostComposerSheet), findsOneWidget);
      expect(find.text('Campus Media'), findsOneWidget);
    });

    testWidgets('MainNavigation Profile tab renders ProfileScreen', (tester) async {
      await tester.pumpWidget(
        const ProviderScope(
          child: MaterialApp(
            home: MainNavigation(),
          ),
        ),
      );
      await tester.pumpAndSettle();

      await tester.tap(find.text('Profile'));
      await tester.pumpAndSettle();

      expect(find.byType(ProfileScreen), findsOneWidget);
      expect(find.text('Edit Profile'), findsOneWidget);
    });
  });
}
