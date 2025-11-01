import 'user.dart';

class Family {
  final String id;
  final String familyName;
  final String? familySurname;
  final String? city;
  final String familyCode;
  final DateTime createdAt;
  final DateTime updatedAt;
  final List<User>? members;

  Family({
    required this.id,
    required this.familyName,
    this.familySurname,
    this.city,
    required this.familyCode,
    required this.createdAt,
    required this.updatedAt,
    this.members,
  });

  factory Family.fromJson(Map<String, dynamic> json) {
    return Family(
      id: json['id'],
      familyName: json['family_name'],
      familySurname: json['family_surname'],
      city: json['city'],
      familyCode: json['family_code'],
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
      members: json['members'] != null
          ? (json['members'] as List).map((i) => User.fromJson(i)).toList()
          : null,
    );
  }
}
