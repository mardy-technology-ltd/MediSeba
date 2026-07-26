import 'package:flutter/material.dart';
import '../models/medical_service_model.dart';
import '../models/doctor_model.dart';
import '../services/api_service.dart';

class HomeController extends ChangeNotifier {
  List<MedicalServiceModel> _services = [];
  List<DoctorModel> _topDoctors = [];
  bool _isLoading = false;

  List<MedicalServiceModel> get services => _services;
  List<DoctorModel> get topDoctors => _topDoctors;
  bool get isLoading => _isLoading;

  HomeController() {
    loadHomeData();
  }

  void loadHomeData() {
    _isLoading = true;
    notifyListeners();

    // Load Services
    _services = [
      MedicalServiceModel(
        id: '1',
        title: 'ডাক্তার অ্যাপয়েন্টমেন্ট',
        description: 'সহজেই স্পেশালিস্ট ডাক্তার খুঁজুন',
        icon: Icons.calendar_month_rounded,
        color: const Color(0xFF0F766E),
      ),
      MedicalServiceModel(
        id: '2',
        title: 'ভিডিও কনসালটেশন',
        description: 'ঘরে বসেই লাইভ চিকিৎসা সেবা',
        icon: Icons.video_call_rounded,
        color: const Color(0xFF0284C7),
      ),
      MedicalServiceModel(
        id: '3',
        title: 'অ্যাম্বুলেন্স সার্ভিস',
        description: 'জরুরি ২৪/৭ অ্যাম্বুলেন্স সাপোর্ট',
        icon: Icons.airport_shuttle_rounded,
        color: const Color(0xFFE11D48),
      ),
      MedicalServiceModel(
        id: '4',
        title: 'ডায়াগনস্টিক টেস্ট',
        description: 'হোম ও ল্যাব টেস্ট বুকিং',
        icon: Icons.biotech_rounded,
        color: const Color(0xFFD97706),
      ),
    ];

    // Load Top Doctors
    _topDoctors = ApiService.getSampleDoctors().take(3).toList();

    _isLoading = false;
    notifyListeners();
  }
}
