import 'package:equatable/equatable.dart';

enum UserRole { ADMIN, MEMBER }

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
    return User(
      id: json['id'],
      email: json['email'],
      firstName: json['first_name'],
      lastName: json['last_name'],
      phoneNumber: json['phone_number'],
      familyId: json['family_id'],
      // The role is not provided by the auth endpoints, so it will be null here.
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
  List<Object?> get props => [id, email, firstName, lastName, phoneNumber, familyId, role];
}
