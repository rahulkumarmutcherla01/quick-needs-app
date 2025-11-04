import 'package:equatable/equatable.dart';
import 'package:project/src/features/family/data/models/family_member.dart';

class User extends Equatable {
  final String id;
  final String email;
  final String firstName;
  final String? lastName;
  final String? phoneNumber;
  final String? familyId;
  final UserRole? role;

  const User({
    required this.id,
    required this.email,
    required this.firstName,
    this.lastName,
    this.phoneNumber,
    this.familyId,
    this.role,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    UserRole? role;
    if (json['user_family'] != null && json['user_family']['role'] != null) {
      try {
        role = UserRole.values
            .byName((json['user_family']['role'] as String).toUpperCase());
      } catch (e) {
        // Handle cases where the role string doesn't match enum values
        role = null;
      }
    }

    return User(
      id: json['id'],
      email: json['email'],
      firstName: json['first_name'],
      lastName: json['last_name'],
      phoneNumber: json['phone_number'],
      familyId: json['family_id'],
      role: role,
    );
  }

  User copyWith({
    String? id,
    String? email,
    String? firstName,
    String? lastName,
    String? phoneNumber,
    String? familyId,
    UserRole? role,
  }) {
    return User(
      id: id ?? this.id,
      email: email ?? this.email,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      familyId: familyId ?? this.familyId,
      role: role ?? this.role,
    );
  }

  @override
  List<Object?> get props =>
      [id, email, firstName, lastName, phoneNumber, familyId, role];
}
