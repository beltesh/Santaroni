// Deliberately permissive: catches typos like missing "@" or domain without
// rejecting unusual but valid addresses. The SMTP server is the final judge.
final _emailPattern = RegExp(r'^[^\s@]+@[^\s@]+\.[^\s@]+$');

bool isValidEmail(String email) => _emailPattern.hasMatch(email.trim());

/// Form used to compare addresses for duplicates.
String normalizeEmail(String email) => email.trim().toLowerCase();
