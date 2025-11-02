import 'package:equatable/equatable.dart';

class User extends Equatable {
  final String id;
  final String email;
  final String firstName;
  final String? lastName;
  final String? phoneNumber;
  final String? familyId;

  const User({
    required this.id,
    required this.email,
    required this.firstName,
    this.lastName,
    this.phoneNumber,
    this.familyId,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      email: json['email'],
      firstName: json['first_name'],
      lastName: json['last_name'],
      phoneNumber: json['phone_number'],
      familyId: json['family_id'],
    );
  }

  @override
  List<Object?> get props => [id, email, firstName, lastName, phoneNumber, familyId];
}
