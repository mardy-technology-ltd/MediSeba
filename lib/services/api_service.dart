import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/doctor_model.dart';
import '../models/appointment_model.dart';

class ApiService {
  static const String doctorsEndpoint = 'https://mediseba-api.loca.lt/api/v1/doctors?bypass-tunnel-reminder=true';

  static Future<List<DoctorModel>> getDoctors() async {
    try {
      final response = await http.get(
        Uri.parse(doctorsEndpoint),
        headers: {
          'bypass-tunnel-reminder': 'true',
          'Bypass-Tunnel-Reminder': 'true',
          'Accept': 'application/json',
          'User-Agent': 'MediSebaApp/1.0',
        },
      ).timeout(const Duration(seconds: 15));

      if (response.statusCode == 200) {
        final Map<String, dynamic> body = jsonDecode(response.body);
        if (body['success'] == true && body['data'] is List) {
          final List<dynamic> list = body['data'];
          return list.map((item) => DoctorModel.fromJson(item as Map<String, dynamic>)).toList();
        }
      }
      throw Exception('HTTP ${response.statusCode}: ${response.body}');
    } catch (e) {
      print('ApiService.getDoctors exception: $e');
      rethrow;
    }
  }

  // Mock Data for Doctors
  static List<DoctorModel> getSampleDoctors() {
    return [
      DoctorModel(
        id: 'doc_1',
        name: 'ডাঃ মোহাম্মাদ আরিফ রহমান',
        degree: 'MBBS, FCPS (Medicine), MD (Cardiology)',
        specialty: 'মেডিসিন (Medicine)',
        hospital: 'ঢাকা মেডিকেল কলেজ ও হাসপাতাল',
        rating: 4.9,
        totalReviews: 128,
        experienceYears: 12,
        consultationFee: 800,
        imageUrl: 'https://img.freepik.com/free-photo/doctor-offering-medical-teleconsultation_23-2149329007.jpg',
        isAvailableToday: true,
      ),
      DoctorModel(
        id: 'doc_2',
        name: 'ডাঃ ফারজানা আক্তার',
        degree: 'MBBS, MS (Gynecology & Obstetrics)',
        specialty: 'গাইনি ও স্ত্রী রোগ (Gynecology)',
        hospital: 'স্কয়ার হাসপাতাল, ঢাকা',
        rating: 4.8,
        totalReviews: 95,
        experienceYears: 9,
        consultationFee: 700,
        imageUrl: 'https://img.freepik.com/free-photo/female-doctor-hospital-with-stethoscope_23-2148827766.jpg',
        isAvailableToday: true,
      ),
      DoctorModel(
        id: 'doc_3',
        name: 'ডাঃ তামিম হাসান',
        degree: 'MBBS, DCH, MD (Pediatrics)',
        specialty: 'শিশু রোগ (Pediatrics)',
        hospital: 'বঙ্গবন্ধু শেখ মুজিব মেডিকেল বিশ্ববিদ্যালয়',
        rating: 4.7,
        totalReviews: 74,
        experienceYears: 8,
        consultationFee: 600,
        imageUrl: 'https://img.freepik.com/free-photo/young-handsome-physician-medical-robe-with-stethoscope_1303-17818.jpg',
        isAvailableToday: false,
      ),
      DoctorModel(
        id: 'doc_4',
        name: 'ডাঃ সায়মা পারভীন',
        degree: 'MBBS, DDV (Dermatology)',
        specialty: 'চর্ম ও যৌন (Dermatology)',
        hospital: 'পপুলার ডায়াগনস্টিক সেন্টার',
        rating: 4.9,
        totalReviews: 140,
        experienceYears: 14,
        consultationFee: 1000,
        imageUrl: 'https://img.freepik.com/free-photo/pleased-young-female-doctor-wearing-medical-robe-stethoscope-around-neck-standing-with-crossed-arms_409827-254.jpg',
        isAvailableToday: true,
      ),
      DoctorModel(
        id: 'doc_5',
        name: 'ডাঃ তানভীর আহমেদ',
        degree: 'MBBS, MS (Orthopedics)',
        specialty: 'অর্থোপেডিক্স (Orthopedics)',
        hospital: 'ল্যাবএইড হাসপাতাল, ধানমন্ডি',
        rating: 4.6,
        totalReviews: 62,
        experienceYears: 10,
        consultationFee: 800,
        imageUrl: 'https://img.freepik.com/free-photo/doctor-with-stethoscope-hospital_23-2148827775.jpg',
        isAvailableToday: true,
      ),
    ];
  }

  static List<AppointmentModel> getSampleAppointments() {
    return [
      AppointmentModel(
        id: 'apt_101',
        doctorId: 'doc_1',
        doctorName: 'ডাঃ মোহাম্মাদ আরিফ রহমান',
        doctorSpecialty: 'মেডিসিন (Medicine)',
        patientName: 'আহমেদ হাসান',
        patientPhone: '01712345678',
        appointmentDate: '2026-07-28',
        appointmentTime: '05:30 PM',
        status: 'Confirmed',
        fee: 800,
      ),
      AppointmentModel(
        id: 'apt_102',
        doctorId: 'doc_2',
        doctorName: 'ডাঃ ফারজানা আক্তার',
        doctorSpecialty: 'গাইনি ও স্ত্রী রোগ (Gynecology)',
        patientName: 'সুলতানা বেগম',
        patientPhone: '01898765432',
        appointmentDate: '2026-07-30',
        appointmentTime: '07:00 PM',
        status: 'Pending',
        fee: 700,
      ),
    ];
  }
}
