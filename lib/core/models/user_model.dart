// lib/core/models/user_model.dart
// User model for Firestore

class UserModel {
  final String id;
  final String name;
  final String email;
  final String role;
  final String? profilePhotoUrl;

  UserModel({
    required this.id,
    required this.name,
    required this.email,
    required this.role,
    this.profilePhotoUrl,
  });

  // TODO: Add fromMap/toMap for Firestore
}
