class DoctorAvailabilityModel {
  final int id;
  final String uuid;
  final int doctorId;
  final String availableDate;
  final String startTime;
  final String endTime;
  final int slotDuration;
  final int maxPatients;
  final bool isAvailable;
  final String? note;

  const DoctorAvailabilityModel({
    required this.id,
    required this.uuid,
    required this.doctorId,
    required this.availableDate,
    required this.startTime,
    required this.endTime,
    required this.slotDuration,
    required this.maxPatients,
    required this.isAvailable,
    this.note,
  });

  factory DoctorAvailabilityModel.fromJson(Map<String, dynamic> json) {
    return DoctorAvailabilityModel(
      id: json['id'] is int ? json['id'] as int : int.tryParse(json['id'].toString()) ?? 0,
      uuid: json['uuid']?.toString() ?? '',
      doctorId: json['doctor_id'] is int
          ? json['doctor_id'] as int
          : int.tryParse(json['doctor_id'].toString()) ?? 0,
      availableDate: json['available_date']?.toString() ?? '',
      startTime: json['start_time']?.toString() ?? '',
      endTime: json['end_time']?.toString() ?? '',
      slotDuration: json['slot_duration'] is int
          ? json['slot_duration'] as int
          : int.tryParse(json['slot_duration'].toString()) ?? 0,
      maxPatients: json['max_patients'] is int
          ? json['max_patients'] as int
          : int.tryParse(json['max_patients'].toString()) ?? 0,
      isAvailable: json['is_available'] == true || json['is_available'].toString() == '1',
      note: json['note']?.toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'uuid': uuid,
      'doctor_id': doctorId,
      'available_date': availableDate,
      'start_time': startTime,
      'end_time': endTime,
      'slot_duration': slotDuration,
      'max_patients': maxPatients,
      'is_available': isAvailable,
      'note': note,
    };
  }
}
