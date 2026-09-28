class Caregiver {
  final String uid;
  final String userId;
  final String name;
  final String email;
  final String phone;
  final String relationship;
  final bool isPrimary;
  final bool active;
  final DateTime createdAt;

  Caregiver({
    required this.uid,
    required this.userId,
    required this.name,
    required this.email,
    required this.phone,
    required this.relationship,
    this.isPrimary = false,
    this.active = true,
    DateTime? createdAt,
  }) : createdAt = createdAt ?? DateTime.now();
}
