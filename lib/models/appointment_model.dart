class AppointmentModel {
  final String id;
  final String doctorId;
  final String doctorName;
  final String doctorSpecialty;
  final String patientName;
  final String patientPhone;
  final String appointmentDate;
  final String appointmentTime;
  final String status; // Pending, Confirmed, Completed, Cancelled
  final double fee;

  AppointmentModel({
    required this.id,
    required this.doctorId,
    required this.doctorName,
    required this.doctorSpecialty,
    required this.patientName,
    required this.patientPhone,
    required this.appointmentDate,
    required this.appointmentTime,
    required this.status,
    required this.fee,
  });

  factory AppointmentModel.fromJson(Map<String, dynamic> json) {
    return AppointmentModel(
      id: json['id'] ?? '',
      doctorId: json['doctorId'] ?? '',
      doctorName: json['doctorName'] ?? '',
      doctorSpecialty: json['doctorSpecialty'] ?? '',
      patientName: json['patientName'] ?? '',
      patientPhone: json['patientPhone'] ?? '',
      appointmentDate: json['appointmentDate'] ?? '',
      appointmentTime: json['appointmentTime'] ?? '',
      status: json['status'] ?? 'Pending',
      fee: (json['fee'] ?? 0.0).toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'doctorId': doctorId,
      'doctorName': doctorName,
      'doctorSpecialty': doctorSpecialty,
      'patientName': patientName,
      'patientPhone': patientPhone,
      'appointmentDate': appointmentDate,
      'appointmentTime': appointmentTime,
      'status': status,
      'fee': fee,
    };
  }
}
