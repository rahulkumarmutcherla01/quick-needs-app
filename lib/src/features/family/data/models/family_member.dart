import 'package:equatable/equatable.dart';

class FamilyMember extends Equatable {
  final String id;
  final String firstName;
  final String? lastName;
  final String email;

  const FamilyMember({
    required this.id,
    required this.firstName,
    this.lastName,
    required this.email,
  });

  factory FamilyMember.fromJson(Map<String, dynamic> json) {
    return FamilyMember(
      id: json['id'],
      firstName: json['first_name'],
      lastName: json['last_name'],
      email: json['email'],
    );
  }

  @override
  List<Object?> get props => [id, firstName, lastName, email];
}
