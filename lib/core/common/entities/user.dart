class User {
  // Use a UUID for user ID in a real application for better security and uniqueness.
  // Here, using an int for simplicity.
  final int id;
  final String email;
  final String name;
  final bool isVerifed;

  User({
    required this.id,
    required this.email,
    required this.name,
    required this.isVerifed,
  });
}
