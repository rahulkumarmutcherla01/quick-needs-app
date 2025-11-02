import 'package:equatable/equatable.dart';

class Family extends Equatable {
  final String id;
  final String familyName;
  final String? familySurname;
  final String? city;
  final String familyCode;

  const Family({
    required this.id,
    required this.familyName,
    this.familySurname,
    this.city,
    required this.familyCode,
  });

  factory Family.fromJson(Map<String, dynamic> json) {
    return Family(
      id: json['id'],
      familyName: json['family_name'],
      familySurname: json['family_surname'],
      city: json['city'],
      familyCode: json['family_code'],
    );
  }

  @override
  List<Object?> get props => [id, familyName, familySurname, city, familyCode];
}
