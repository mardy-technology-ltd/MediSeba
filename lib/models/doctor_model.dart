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
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      degree: json['degree'] ?? '',
      specialty: json['specialty'] ?? '',
      hospital: json['hospital'] ?? '',
      rating: (json['rating'] ?? 0.0).toDouble(),
      totalReviews: json['totalReviews'] ?? 0,
      experienceYears: json['experienceYears'] ?? 0,
      consultationFee: (json['consultationFee'] ?? 0.0).toDouble(),
      imageUrl: json['imageUrl'] ?? '',
      isAvailableToday: json['isAvailableToday'] ?? true,
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
