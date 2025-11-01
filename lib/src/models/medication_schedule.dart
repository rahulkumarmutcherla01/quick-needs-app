class MedicationSchedule {
  final String id;
  final String medicationId;
  final List<String> timesOfDay;
  final String startDate;
  final String endDate;

  MedicationSchedule({
    required this.id,
    required this.medicationId,
    required this.timesOfDay,
    required this.startDate,
    required this.endDate,
  });

  factory MedicationSchedule.fromJson(Map<String, dynamic> json) {
    return MedicationSchedule(
      id: json['id'],
      medicationId: json['medication_id'],
      timesOfDay: List<String>.from(json['times_of_day']),
      startDate: json['start_date'],
      endDate: json['end_date'],
    );
  }
}
