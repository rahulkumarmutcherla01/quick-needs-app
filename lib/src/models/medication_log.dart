class MedicationLog {
  final String id;
  final String medicationScheduleId;
  final String userId;
  final DateTime takenAt;

  MedicationLog({
    required this.id,
    required this.medicationScheduleId,
    required this.userId,
    required this.takenAt,
  });

  factory MedicationLog.fromJson(Map<String, dynamic> json) {
    return MedicationLog(
      id: json['id'],
      medicationScheduleId: json['medication_schedule_id'],
      userId: json['user_id'],
      takenAt: DateTime.parse(json['taken_at']),
    );
  }
}
