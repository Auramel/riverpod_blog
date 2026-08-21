class User {
  final int id;
  final String login;
  final String fullName;
  final DateTime birthDate;
  final bool isBanned;
  final bool isDeleted;

  const User({
    required this.id,
    required this.login,
    required this.fullName,
    required this.birthDate,
    required this.isBanned,
    required this.isDeleted,
  });
}
