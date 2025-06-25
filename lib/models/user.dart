import 'package:cloud_firestore/cloud_firestore.dart'; // ← LETAKKAN DI SINI

class AppUser {
  final String id;
  final String email;
  final String role;
  final DateTime createdAt;

  AppUser({
    required this.id,
    required this.email,
    required this.role,
    required this.createdAt,
  });

  factory AppUser.fromFirestore(String id, Map<String, dynamic> data) {
    return AppUser(
      id: id,
      email: data['email'] ?? '',
      role: data['role'] ?? 'kasir',
      createdAt: (data['createdAt'] as Timestamp).toDate(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'email': email,
      'role': role,
      'createdAt': Timestamp.fromDate(createdAt),
    };
  }

  bool get isAdmin => role == 'admin';
}