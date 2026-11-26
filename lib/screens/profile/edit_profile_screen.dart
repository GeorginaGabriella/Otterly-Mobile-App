import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import '../../core/app_colors.dart';
import '../../core/app_constants.dart';
import '../../models/friend_profile_model.dart';
import '../../providers/auth_provider.dart';
import '../../providers/social_profile_provider.dart';
import '../../widgets/auth_text_field.dart';
import '../../widgets/avatar_selector.dart';
import '../../widgets/primary_button.dart';
import '../../widgets/profile/adaptive_image_stub.dart'
    if (dart.library.io) '../../widgets/profile/adaptive_image_io.dart';

class EditProfileScreen extends ConsumerStatefulWidget {
  const EditProfileScreen({super.key});

  @override
  ConsumerState<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends ConsumerState<EditProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  final ImagePicker _imagePicker = ImagePicker();

  late final TextEditingController _nameController;
  late final TextEditingController _usernameController;
  late final TextEditingController _bioController;

  late String _selectedFaculty;
  late String _selectedProgram;
  late String _selectedYear;
  late String _selectedAvatar;
  late String _selectedCoverPreset;
  String? _customProfileImagePath;
  String? _coverImagePath;
  late bool _isPrivate;
  bool _isSaving = false;

  static const List<String> _faculties = [
    'Faculty of Information Technology',
    'Faculty of Engineering',
    'Faculty of Economics and Business',
    'Faculty of Law',
    'Faculty of Medicine',
    'Faculty of Psychology',
    'Faculty of Communication Sciences',
    'Faculty of Art and Design',
  ];

  static const List<String> _programs = [
    'Informatics',
    'Information Systems',
    'Electrical Engineering',
    'Industrial Engineering',
    'Civil Engineering',
    'Management',
    'Accounting',
    'Law',
    'Psychology',
    'Communication Science',
    'Visual Communication Design',
    'Interior Design',
  ];

  static const List<String> _years = ['2022', '2023', '2024', '2025', '2026'];

  @override
  void initState() {
    super.initState();
    final user = ref.read(authProvider) ?? buildFallbackDemoUser();
    final privacy = ref.read(socialProfileProvider).privacy;

    _nameController = TextEditingController(text: user.fullName);
    _usernameController = TextEditingController(text: user.effectiveUsername);
    _bioController = TextEditingController(text: user.bio);

    _selectedFaculty =
        _faculties.contains(user.faculty) ? user.faculty : _faculties.first;
    _selectedProgram =
        _programs.contains(user.studyProgram) ? user.studyProgram : _programs.first;
    _selectedYear =
        _years.contains(user.entryYear) ? user.entryYear : _years.last;
    _selectedAvatar = user.avatar.isNotEmpty
        ? user.avatar
        : AppConstants.pinkAvatarPath;
    _selectedCoverPreset = user.coverPreset;
    _customProfileImagePath = user.customProfileImagePath;
    _coverImagePath = user.coverImagePath;
    _isPrivate = privacy.isPrivateAccount || user.isPrivate;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _usernameController.dispose();
    _bioController.dispose();
    super.dispose();
  }

  Future<void> _pickImage({required bool isCover}) async {
    try {
      final XFile? file = await _imagePicker.pickImage(
        source: ImageSource.gallery,
        maxWidth: isCover ? 1400 : 800,
        imageQuality: 85,
      );
      if (file == null || !mounted) return;
      setState(() {
        if (isCover) {
          _coverImagePath = file.path;
        } else {
          _customProfileImagePath = file.path;
        }
      });
    } catch (_) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Gallery picker is unavailable on this device.'),
          backgroundColor: AppColors.error,
        ),
      );
    }
  }

  Future<void> _saveProfile() async {
    FocusScope.of(context).unfocus();
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isSaving = true;
    });

    final baseUser = ref.read(authProvider) ?? buildFallbackDemoUser();
    final cleanedUsername = _usernameController.text
        .trim()
        .replaceFirst(RegExp(r'^@+'), '')
        .toLowerCase();

    final updatedUser = baseUser.copyWith(
      fullName: _nameController.text.trim(),
      username: cleanedUsername,
      bio: _bioController.text.trim(),
      faculty: _selectedFaculty,
      studyProgram: _selectedProgram,
      entryYear: _selectedYear,
      avatar: _selectedAvatar,
      coverPreset: _selectedCoverPreset,
      coverImagePath: _coverImagePath,
      clearCoverImagePath: _coverImagePath == null,
      customProfileImagePath: _customProfileImagePath,
      clearCustomProfileImagePath: _customProfileImagePath == null,
      isPrivate: _isPrivate,
    );

    await ref.read(authProvider.notifier).updateProfile(updatedUser);
    await ref.read(socialProfileProvider.notifier).updatePrivacySettings(
          isPrivateAccount: _isPrivate,
        );

    if (!mounted) return;
    setState(() {
      _isSaving = false;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Profile updated successfully!'),
        backgroundColor: AppColors.success,
      ),
    );
    Navigator.pop(context, true);
  }

  Widget _buildDropdown({
    required String label,
    required String value,
    required List<String> items,
    required ValueChanged<String?> onChanged,
  }) {
    final validValue = items.contains(value) ? value : items.first;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            color: AppColors.textDark,
            fontWeight: FontWeight.w600,
            fontSize: 14,
          ),
        ),
        const SizedBox(height: 8),
        DropdownButtonFormField<String>(
          initialValue: validValue,
          isExpanded: true,
          decoration: InputDecoration(
            filled: true,
            fillColor: AppColors.white,
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 14,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(15),
              borderSide: const BorderSide(color: AppColors.border),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(15),
              borderSide: const BorderSide(color: AppColors.border),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(15),
              borderSide: const BorderSide(color: AppColors.pink, width: 1.6),
            ),
          ),
          items: items
              .map(
                (item) => DropdownMenuItem<String>(
                  value: item,
                  child: Text(
                    item,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(fontSize: 13.5),
                  ),
                ),
              )
              .toList(),
          onChanged: onChanged,
        ),
      ],
    );
  }

  Widget _buildCoverSection() {
    final selectedTheme = CoverPresetTheme.resolve(_selectedCoverPreset);

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Expanded(
                child: Text(
                  'Cover Photo',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14.5,
                    color: AppColors.burgundy,
                  ),
                ),
              ),
              TextButton.icon(
                onPressed: () => _pickImage(isCover: true),
                icon: const Icon(Icons.photo_library_outlined, size: 17),
                label: const Text('Upload'),
              ),
              if (_coverImagePath != null)
                TextButton(
                  onPressed: () {
                    setState(() {
                      _coverImagePath = null;
                    });
                  },
                  child: const Text(
                    'Reset',
                    style: TextStyle(color: AppColors.error),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 8),
          Container(
            height: 110,
            width: double.infinity,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              gradient: LinearGradient(
                colors: selectedTheme.gradientColors,
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: _coverImagePath != null
                ? ClipRRect(
                    borderRadius: BorderRadius.circular(16),
                    child: buildAdaptiveFileImage(
                      _coverImagePath!,
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) => const SizedBox.shrink(),
                    ),
                  )
                : Align(
                    alignment: Alignment.bottomLeft,
                    child: Padding(
                      padding: const EdgeInsets.all(12),
                      child: Text(
                        selectedTheme.label,
                        style: const TextStyle(
                          color: AppColors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 13,
                        ),
                      ),
                    ),
                  ),
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: CoverPresetTheme.presets.map((preset) {
              final isSelected =
                  _coverImagePath == null && _selectedCoverPreset == preset.id;
              return GestureDetector(
                onTap: () {
                  setState(() {
                    _coverImagePath = null;
                    _selectedCoverPreset = preset.id;
                  });
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(colors: preset.gradientColors),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: isSelected
                          ? AppColors.textDark
                          : Colors.transparent,
                      width: 2,
                    ),
                  ),
                  child: Text(
                    preset.label,
                    style: const TextStyle(
                      color: AppColors.white,
                      fontSize: 11.5,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildPhotoSection() {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Expanded(
                child: Text(
                  'Profile Picture',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14.5,
                    color: AppColors.burgundy,
                  ),
                ),
              ),
              TextButton.icon(
                onPressed: () => _pickImage(isCover: false),
                icon: const Icon(Icons.add_a_photo_outlined, size: 17),
                label: const Text('Gallery'),
              ),
              if (_customProfileImagePath != null)
                TextButton(
                  onPressed: () {
                    setState(() {
                      _customProfileImagePath = null;
                    });
                  },
                  child: const Text(
                    'Use Otter',
                    style: TextStyle(color: AppColors.burgundy),
                  ),
                ),
            ],
          ),
          if (_customProfileImagePath != null) ...[
            const SizedBox(height: 8),
            Center(
              child: ClipOval(
                child: SizedBox(
                  width: 96,
                  height: 96,
                  child: buildAdaptiveFileImage(
                    _customProfileImagePath!,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => Image.asset(
                      _selectedAvatar,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 8),
          ] else
            AvatarSelector(
              selectedAvatar: _selectedAvatar,
              onChanged: (avatar) {
                setState(() {
                  _selectedAvatar = avatar;
                });
              },
            ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        title: const Text(
          'Edit Profile',
          style: TextStyle(
            color: AppColors.burgundy,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(18),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _buildCoverSection(),
                const SizedBox(height: 16),
                _buildPhotoSection(),
                const SizedBox(height: 18),
                AuthTextField(
                  label: 'Full Name',
                  hint: 'Enter your full name',
                  prefixIcon: Icons.person_outline,
                  controller: _nameController,
                  validator: (value) {
                    if (value == null || value.trim().length < 3) {
                      return 'Full name must be at least 3 characters';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                AuthTextField(
                  label: 'Username',
                  hint: 'e.g. felicia.angeline',
                  prefixIcon: Icons.alternate_email_rounded,
                  controller: _usernameController,
                  validator: (value) {
                    final cleaned =
                        (value ?? '').trim().replaceFirst(RegExp(r'^@+'), '');
                    if (cleaned.length < 3) {
                      return 'Username must be at least 3 characters';
                    }
                    if (!RegExp(r'^[a-zA-Z0-9._]+$').hasMatch(cleaned)) {
                      return 'Use letters, numbers, dots, or underscores only';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Bio',
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        color: AppColors.textDark,
                        fontSize: 14,
                      ),
                    ),
                    const SizedBox(height: 8),
                    TextFormField(
                      controller: _bioController,
                      maxLines: 3,
                      maxLength: 160,
                      decoration: InputDecoration(
                        hintText: 'Share your major, interests, or campus role',
                        filled: true,
                        fillColor: AppColors.white,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15),
                          borderSide: const BorderSide(color: AppColors.border),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15),
                          borderSide: const BorderSide(color: AppColors.border),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15),
                          borderSide: const BorderSide(
                            color: AppColors.pink,
                            width: 1.6,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                _buildDropdown(
                  label: 'Faculty',
                  value: _selectedFaculty,
                  items: _faculties,
                  onChanged: (value) {
                    if (value != null) {
                      setState(() => _selectedFaculty = value);
                    }
                  },
                ),
                const SizedBox(height: 14),
                _buildDropdown(
                  label: 'Study Program',
                  value: _selectedProgram,
                  items: _programs,
                  onChanged: (value) {
                    if (value != null) {
                      setState(() => _selectedProgram = value);
                    }
                  },
                ),
                const SizedBox(height: 14),
                _buildDropdown(
                  label: 'Entry Year (Angkatan)',
                  value: _selectedYear,
                  items: _years,
                  onChanged: (value) {
                    if (value != null) {
                      setState(() => _selectedYear = value);
                    }
                  },
                ),
                const SizedBox(height: 16),
                Material(
                  color: AppColors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                    side: const BorderSide(color: AppColors.border),
                  ),
                  child: SwitchListTile(
                    activeThumbColor: AppColors.pink,
                    value: _isPrivate,
                    onChanged: (val) => setState(() => _isPrivate = val),
                    title: const Text(
                      'Private Profile',
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 14,
                        color: AppColors.textDark,
                      ),
                    ),
                    subtitle: const Text(
                      'Hide posts and full NIM from non-friends',
                      style: TextStyle(
                        fontSize: 12,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                PrimaryButton(
                  text: 'Save Changes',
                  icon: Icons.check_rounded,
                  isLoading: _isSaving,
                  onPressed: _isSaving ? null : _saveProfile,
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
