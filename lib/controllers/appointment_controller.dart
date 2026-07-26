import 'package:flutter/material.dart';
import '../models/appointment_model.dart';
import '../services/api_service.dart';

class AppointmentController extends ChangeNotifier {
  List<AppointmentModel> _appointments = [];
  bool _isLoading = false;

  List<AppointmentModel> get appointments => _appointments;
  bool get isLoading => _isLoading;

  AppointmentController() {
    fetchAppointments();
  }

  void fetchAppointments() {
    _isLoading = true;
    notifyListeners();

    _appointments = ApiService.getSampleAppointments();

    _isLoading = false;
    notifyListeners();
  }

  bool bookAppointment({
    required String doctorId,
    required String doctorName,
    required String doctorSpecialty,
    required String patientName,
    required String patientPhone,
    required String date,
    required String time,
    required double fee,
  }) {
    final newAppointment = AppointmentModel(
      id: 'apt_${DateTime.now().millisecondsSinceEpoch}',
      doctorId: doctorId,
      doctorName: doctorName,
      doctorSpecialty: doctorSpecialty,
      patientName: patientName,
      patientPhone: patientPhone,
      appointmentDate: date,
      appointmentTime: time,
      status: 'Confirmed',
      fee: fee,
    );

    _appointments.insert(0, newAppointment);
    notifyListeners();
    return true;
  }
}
