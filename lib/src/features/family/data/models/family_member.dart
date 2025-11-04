import 'package:equatable/equatable.dart';

enum UserRole { ADMIN, MEMBER }

class FamilyMember extends Equatable {
  final String id;
  final String firstName;
  final String? lastName;
  final String email;
  final UserRole role;

  const FamilyMember({
    required this.id,
    required this.firstName,
    this.lastName,
    required this.email,
    required this.role,
  });

  factory FamilyMember.fromJson(Map<String, dynamic> json) {
    UserRole role = UserRole.MEMBER;
    if (json['UserFamily'] != null && json['UserFamily']['role'] != null) {
      try {
        role = UserRole.values
            .byName((json['UserFamily']['role'] as String).toUpperCase());
      } catch (e) {
        // Handle cases where the role string doesn't match enum values
        role = UserRole.MEMBER;
      }
    }

    return FamilyMember(
      id: json['id'],
      firstName: json['first_name'],
      lastName: json['last_name'],
      email: json['email'],
      role: role,
    );
  }

  FamilyMember copyWith({
    String? id,
    String? firstName,
    String? lastName,
    String? email,
    UserRole? role,
  }) {
    return FamilyMember(
      id: id ?? this.id,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      email: email ?? this.email,
      role: role ?? this.role,
    );
  }

  @override
  List<Object?> get props => [id, firstName, lastName, email, role];
}
