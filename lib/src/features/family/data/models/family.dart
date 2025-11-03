import 'package:equatable/equatable.dart';
import 'package:project/src/features/family/data/models/family_member.dart';

class Family extends Equatable {
  final String id;
  final String familyName;
  final String? familySurname;
  final String? city;
  final String familyCode;
  final String? createdByUserId;
  final List<FamilyMember>? members;

  const Family({
    required this.id,
    required this.familyName,
    this.familySurname,
    this.city,
    required this.familyCode,
    this.createdByUserId,
    this.members,
  });

  factory Family.fromJson(Map<String, dynamic> json) {
    return Family(
      id: json['id'],
      familyName: json['family_name'],
      familySurname: json['family_surname'],
      city: json['city'],
      familyCode: json['family_code'],
      createdByUserId: json['created_by_user_id'],
      members: json['members'] != null
          ? (json['members'] as List)
              .map((member) => FamilyMember.fromJson(member))
              .toList()
          : null,
    );
  }

  @override
  List<Object?> get props => [id, familyName, familySurname, city, familyCode, createdByUserId, members];
}
