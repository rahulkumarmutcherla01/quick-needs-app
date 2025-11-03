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
    return FamilyMember(
      id: json['id'],
      firstName: json['first_name'],
      lastName: json['last_name'],
      email: json['email'],
      role: UserRole.values.firstWhere((e) => e.toString() == 'UserRole.${json['UserFamily']['role']}'),
    );
  }

  @override
  List<Object?> get props => [id, firstName, lastName, email, role];
}
