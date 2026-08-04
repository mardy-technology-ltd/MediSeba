class DoctorModel {
  final String id;
  final String name;
  final String degree;
  final String specialty;
  final String hospital;
  final double rating;
  final int totalReviews;
  final int experienceYears;
  final double consultationFee;
  final String imageUrl;
  final bool isAvailableToday;

  DoctorModel({
    required this.id,
    required this.name,
    required this.degree,
    required this.specialty,
    required this.hospital,
    required this.rating,
    required this.totalReviews,
    required this.experienceYears,
    required this.consultationFee,
    required this.imageUrl,
    this.isAvailableToday = true,
  });

  factory DoctorModel.fromJson(Map<String, dynamic> json) {
    return DoctorModel(
      id: json['uuid']?.toString() ?? json['id']?.toString() ?? json['slug']?.toString() ?? '',
      name: json['name']?.toString() ?? '',
      degree: json['qualification']?.toString() ?? json['degree']?.toString() ?? '',
      specialty: json['speciality']?.toString() ?? json['specialty']?.toString() ?? '',
      hospital: json['hospital']?.toString() ?? '',
      rating: double.tryParse(json['rating']?.toString() ?? '') ?? 4.8,
      totalReviews: json['rating_count'] is int
          ? json['rating_count']
          : (int.tryParse(json['rating_count']?.toString() ?? json['totalReviews']?.toString() ?? '') ?? 45),
      experienceYears: json['experience_years'] is int
          ? json['experience_years']
          : (json['experience'] is int
              ? json['experience']
              : (int.tryParse(json['experience_years']?.toString() ?? json['experience']?.toString() ?? json['experienceYears']?.toString() ?? '') ?? 5)),
      consultationFee: double.tryParse(json['consultation_fee']?.toString() ?? json['fee']?.toString() ?? json['consultationFee']?.toString() ?? '') ?? 800.0,
      imageUrl: json['avatar_url']?.toString() ?? json['image']?.toString() ?? json['imageUrl']?.toString() ?? '',
      isAvailableToday: json['is_available_today'] ?? json['available'] ?? json['isAvailableToday'] ?? true,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'degree': degree,
      'specialty': specialty,
      'hospital': hospital,
      'rating': rating,
      'totalReviews': totalReviews,
      'experienceYears': experienceYears,
      'consultationFee': consultationFee,
      'imageUrl': imageUrl,
      'isAvailableToday': isAvailableToday,
    };
  }
}
