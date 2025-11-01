class Medication {
  final String id;
  final String familyId;
  final String userId;
  final String medicineName;
  final String dosage;
  final String instructions;

  Medication({
    required this.id,
    required this.familyId,
    required this.userId,
    required this.medicineName,
    required this.dosage,
    required this.instructions,
  });

  factory Medication.fromJson(Map<String, dynamic> json) {
    return Medication(
      id: json['id'],
      familyId: json['family_id'],
      userId: json['user_id'],
      medicineName: json['medicine_name'],
      dosage: json['dosage'],
      instructions: json['instructions'],
    );
  }
}
