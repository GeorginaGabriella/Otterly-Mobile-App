import 'package:flutter/material.dart';
import '../../core/app_colors.dart';
import '../../widgets/auth_text_field.dart';
import '../../widgets/password_field.dart';
import '../../widgets/avatar_selector.dart';
import '../../widgets/primary_button.dart';
import '../../widgets/otter_logo_widget.dart';
import '../../widgets/social_background.dart';
import '../../services/auth_service.dart';
import 'login_screen.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();

  final _nameController = TextEditingController();
  final _nimController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  final AuthService _authService = AuthService();

  String? _selectedFaculty;
  String? _selectedProgram;
  String? _selectedYear;

  String _selectedAvatar = 'assets/images/otter_pink.png';

  bool _acceptedTerms = false;
  bool _isLoading = false;

  final List<String> _faculties = [
    'Faculty of Information Technology',
    'Faculty of Engineering',
    'Faculty of Economics and Business',
    'Faculty of Law',
    'Faculty of Medicine',
    'Faculty of Psychology',
    'Faculty of Communication Sciences',
    'Faculty of Art and Design',
  ];

  final List<String> _programs = [
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

  final List<String> _years = [
    '2022',
    '2023',
    '2024',
    '2025',
    '2026',
  ];

  @override
  void dispose() {
    _nameController.dispose();
    _nimController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();

    super.dispose();
  }

  // Reusable dropdown widget
  Widget _buildDropdown({
    required String label,
    required String hint,
    required String? value,
    required List<String> items,
    required ValueChanged<String?> onChanged,
  }) {
    // Prevent initialValue from referencing an item
    // that does not exist in the dropdown list.
    final validValue = items.contains(value) ? value : null;

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

        const SizedBox(height: 9),

        DropdownButtonFormField<String>(
          initialValue: validValue,
          isExpanded: true,

          decoration: InputDecoration(
            hintText: hint,
            filled: true,
            fillColor: AppColors.white,

            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 16,
            ),

            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(15),
              borderSide: const BorderSide(
                color: AppColors.border,
              ),
            ),

            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(15),
              borderSide: const BorderSide(
                color: AppColors.border,
              ),
            ),

            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(15),
              borderSide: const BorderSide(
                color: AppColors.pink,
                width: 1.8,
              ),
            ),
          ),

          items: items.toSet().map((item) {
            return DropdownMenuItem<String>(
              value: item,
              child: Text(
                item,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontSize: 13,
                ),
              ),
            );
          }).toList(),

          onChanged: onChanged,

          validator: (selectedValue) {
            if (selectedValue == null ||
                selectedValue.isEmpty) {
              return 'Please select $label';
            }

            return null;
          },
        ),
      ],
    );
  }

  // Terms and Conditions dialog
  Future<void> _showTerms() async {
    await showDialog<void>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          backgroundColor: AppColors.background,

          title: const Text(
            'Terms & Conditions',
            style: TextStyle(
              color: AppColors.burgundy,
              fontWeight: FontWeight.bold,
            ),
          ),

          content: const SingleChildScrollView(
            child: Text(
              'Welcome to Otter.ly!\n\n'
              '1. Otter.ly is a student community platform.\n\n'
              '2. Users must provide accurate registration information.\n\n'
              '3. Users must respect other members of the community.\n\n'
              '4. Do not share harmful, misleading, or inappropriate content.\n\n'
              '5. Protect your account credentials and personal information.\n\n'
              '6. Use the application responsibly and respectfully.',
              style: TextStyle(
                height: 1.6,
                color: AppColors.textDark,
              ),
            ),
          ),

          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(dialogContext);
              },
              child: const Text(
                'Close',
                style: TextStyle(
                  color: AppColors.burgundy,
                ),
              ),
            ),

            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.pink,
                foregroundColor: AppColors.white,
              ),

              onPressed: () {
                setState(() {
                  _acceptedTerms = true;
                });

                Navigator.pop(dialogContext);
              },

              child: const Text('I Agree'),
            ),
          ],
        );
      },
    );
  }

  // Register account
  Future<void> _submitForm() async {
    FocusScope.of(context).unfocus();

    if (!_formKey.currentState!.validate()) {
      return;
    }

    if (!_acceptedTerms) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Please accept Terms & Conditions.',
          ),
        ),
      );

      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final error = await _authService.register(
        fullName: _nameController.text.trim(),
        nim: _nimController.text.trim(),
        email: _emailController.text.trim(),
        password: _passwordController.text,
        faculty: _selectedFaculty!,
        studyProgram: _selectedProgram!,
        entryYear: _selectedYear!,
        avatar: _selectedAvatar,
      );

      if (!mounted) return;

      setState(() {
        _isLoading = false;
      });

      if (error != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(error),
          ),
        );

        return;
      }

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Account created successfully!',
          ),
          backgroundColor: AppColors.success,
        ),
      );

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => const LoginScreen(),
        ),
      );
    } catch (e) {
      if (!mounted) return;

      setState(() {
        _isLoading = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Something went wrong: $e',
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SocialBackground(
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(
              horizontal: 24,
              vertical: 20,
            ),

            child: Form(
              key: _formKey,

              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [

                  // HEADER
                  Center(
                    child: Column(
                      children: [
                        const OtterLogoWidget(
                          logoSize: 85,
                          showSlogan: false,
                        ),

                        const SizedBox(height: 20),

                        const Text(
                          'Create Your Account',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 27,
                            fontWeight: FontWeight.bold,
                            color: AppColors.burgundy,
                          ),
                        ),

                        const SizedBox(height: 8),

                        const Text(
                          'Join the Otter.ly student community!',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: AppColors.textSecondary,
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 32),

                  // PERSONAL INFORMATION
                  const Text(
                    'PERSONAL INFORMATION',
                    style: TextStyle(
                      color: AppColors.burgundy,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1.2,
                      fontSize: 12,
                    ),
                  ),

                  const SizedBox(height: 18),

                  AuthTextField(
                    label: 'Full Name',
                    hint: 'Enter your full name',
                    prefixIcon: Icons.person_outline,
                    controller: _nameController,

                    validator: (value) {
                      if (value == null ||
                          value.trim().isEmpty) {
                        return 'Full name is required';
                      }

                      if (value.trim().length < 3) {
                        return 'Name must contain at least 3 characters';
                      }

                      return null;
                    },
                  ),

                  const SizedBox(height: 20),

                  AuthTextField(
                    label: 'Student ID (NIM)',
                    hint: 'Enter your student ID',
                    prefixIcon: Icons.badge_outlined,
                    controller: _nimController,
                    keyboardType: TextInputType.number,

                    validator: (value) {
                      if (value == null ||
                          value.trim().isEmpty) {
                        return 'NIM is required';
                      }

                      if (!RegExp(r'^\d{9}$')
                          .hasMatch(value.trim())) {
                        return 'Enter a valid 9-digit NIM';
                      }

                      return null;
                    },
                  ),

                  const SizedBox(height: 20),

                  AuthTextField(
                    label: 'Email Address',
                    hint: 'Enter your email',
                    prefixIcon: Icons.email_outlined,
                    controller: _emailController,
                    keyboardType: TextInputType.emailAddress,

                    validator: (value) {
                      if (value == null ||
                          value.trim().isEmpty) {
                        return 'Email is required';
                      }

                      if (!RegExp(
                        r'^[^@\s]+@[^@\s]+\.[^@\s]+$',
                      ).hasMatch(value.trim())) {
                        return 'Enter a valid email address';
                      }

                      return null;
                    },
                  ),

                  const SizedBox(height: 28),

                  // ACADEMIC INFORMATION
                  const Text(
                    'ACADEMIC INFORMATION',
                    style: TextStyle(
                      color: AppColors.burgundy,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1.2,
                      fontSize: 12,
                    ),
                  ),

                  const SizedBox(height: 18),

                  // FACULTY
                  _buildDropdown(
                    label: 'Faculty',
                    hint: 'Select your faculty',
                    value: _selectedFaculty,
                    items: _faculties,

                    onChanged: (value) {
                      setState(() {
                        _selectedFaculty = value;
                        _selectedProgram = null;
                      });
                    },
                  ),

                  const SizedBox(height: 20),

                  // STUDY PROGRAM
                  _buildDropdown(
                    label: 'Study Program',
                    hint: 'Select your study program',
                    value: _selectedProgram,
                    items: _programs,

                    onChanged: (value) {
                      setState(() {
                        _selectedProgram = value;
                      });
                    },
                  ),

                  const SizedBox(height: 20),

                  // ENTRY YEAR
                  _buildDropdown(
                    label: 'Entry Year',
                    hint: 'Select your entry year',
                    value: _selectedYear,
                    items: _years,

                    onChanged: (value) {
                      setState(() {
                        _selectedYear = value;
                      });
                    },
                  ),

                  const SizedBox(height: 28),

                  // ACCOUNT SECURITY
                  const Text(
                    'ACCOUNT SECURITY',
                    style: TextStyle(
                      color: AppColors.burgundy,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1.2,
                      fontSize: 12,
                    ),
                  ),

                  const SizedBox(height: 18),

                  PasswordField(
                    label: 'Password',
                    controller: _passwordController,

                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Password is required';
                      }

                      if (value.length < 8) {
                        return 'Password must be at least 8 characters';
                      }

                      return null;
                    },
                  ),

                  const SizedBox(height: 20),

                  PasswordField(
                    label: 'Confirm Password',
                    controller: _confirmPasswordController,

                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please confirm your password';
                      }

                      if (value != _passwordController.text) {
                        return 'Passwords do not match';
                      }

                      return null;
                    },
                  ),

                  const SizedBox(height: 28),

                  // AVATAR
                  const Text(
                    'YOUR OTTER AVATAR',
                    style: TextStyle(
                      color: AppColors.burgundy,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1.2,
                      fontSize: 12,
                    ),
                  ),

                  const SizedBox(height: 18),

                  AvatarSelector(
                    selectedAvatar: _selectedAvatar,

                    onChanged: (avatar) {
                      setState(() {
                        _selectedAvatar = avatar;
                      });
                    },
                  ),

                  const SizedBox(height: 25),

                  // TERMS AND CONDITIONS
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Checkbox(
                        value: _acceptedTerms,
                        activeColor: AppColors.pink,

                        onChanged: (value) {
                          setState(() {
                            _acceptedTerms = value ?? false;
                          });
                        },
                      ),

                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.only(
                            top: 12,
                          ),

                          child: Wrap(
                            children: [
                              const Text(
                                'I agree to the ',
                                style: TextStyle(
                                  fontSize: 13,
                                  color: AppColors.textDark,
                                ),
                              ),

                              GestureDetector(
                                onTap: _showTerms,

                                child: const Text(
                                  'Terms & Conditions',
                                  style: TextStyle(
                                    fontSize: 13,
                                    color: AppColors.burgundy,
                                    fontWeight: FontWeight.bold,
                                    decoration: TextDecoration.underline,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 22),

                  // CREATE ACCOUNT BUTTON
                  PrimaryButton(
                    text: 'Create Account',
                    icon: Icons.person_add_alt_1,
                    isLoading: _isLoading,
                    onPressed: _isLoading ? null : _submitForm,
                  ),

                  const SizedBox(height: 22),

                  // LOGIN LINK
                  Center(
                    child: Wrap(
                      alignment: WrapAlignment.center,
                      children: [
                        const Text(
                          'Already have an account? ',
                          style: TextStyle(
                            color: AppColors.textSecondary,
                          ),
                        ),

                        GestureDetector(
                          onTap: () {
                            if (_isLoading) return;

                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                builder: (_) => const LoginScreen(),
                              ),
                            );
                          },

                          child: const Text(
                            'Login',
                            style: TextStyle(
                              color: AppColors.burgundy,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 30),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
