class UserModel {
  final String uid;
  final String name;
  final String phone;
  final String division;
  final String district;
  final String upazila;
  final String union;
  final String? referId;
  final DateTime createdAt;

  UserModel({
    required this.uid,
    required this.name,
    required this.phone,
    required this.division,
    required this.district,
    required this.upazila,
    required this.union,
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
      upazila: data['upazila'] ?? '',
      union: data['union'] ?? '',
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
      'upazila': upazila,
      'union': union,
      'referId': referId,
      'createdAt': createdAt.toIso8601String(),
    };
  }
}
