class StudentVerificationService {
  bool validateFormat({
    required String nim,
    required String email,
  }) {
    final validNim = RegExp(r'^\d{9}$').hasMatch(nim);

    final validEmail = RegExp(
      r'^[^@\s]+@[^@\s]+\.[^@\s]+$',
    ).hasMatch(email);

    return validNim && validEmail;
  }

  bool matchesRegistration({
    required String nim,
    required String email,
    required String registeredNim,
    required String registeredEmail,
  }) {
    return nim.trim() == registeredNim.trim() &&
        email.trim().toLowerCase() ==
            registeredEmail.trim().toLowerCase();
  }
}
