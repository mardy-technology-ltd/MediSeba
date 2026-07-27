class UserModel {
  final String uid;
  final String name;
  final String phone;
  final String division;
  final String district;
  final String thana;
  final String village;
  final String birthYear;
  final String? referId;
  final DateTime createdAt;

  UserModel({
    required this.uid,
    required this.name,
    required this.phone,
    required this.division,
    required this.district,
    required this.thana,
    required this.village,
    required this.birthYear,
    this.referId,
    required this.createdAt,
  });

  factory UserModel.fromMap(Map<String, dynamic> data, String documentId) {
    return UserModel(
      uid: documentId,
      name: data['name'] ?? '',
      phone: data['phone'] ?? '',
      division: data['division'] ?? '',
      district: data['district'] ?? '',
      thana: data['thana'] ?? '',
      village: data['village'] ?? '',
      birthYear: data['birthYear'] ?? '',
      referId: data['referId'],
      createdAt: data['createdAt'] != null 
          ? DateTime.parse(data['createdAt'].toString()) 
          : DateTime.now(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'phone': phone,
      'division': division,
      'district': district,
      'thana': thana,
      'village': village,
      'birthYear': birthYear,
      'referId': referId,
      'createdAt': createdAt.toIso8601String(),
    };
  }
}
