class MedicineModel {
  final int id;
  final String brandName;
  final String genericName;
  final String dosageForm;
  final String strength;
  final String manufacturer;

  MedicineModel({
    required this.id,
    required this.brandName,
    required this.genericName,
    required this.dosageForm,
    required this.strength,
    required this.manufacturer,
  });

  factory MedicineModel.fromJson(Map<String, dynamic> json) {
    return MedicineModel(
      id: json['id'] is int ? json['id'] : int.tryParse(json['id'].toString()) ?? 0,
      brandName: (json['brand_name'] ?? '').toString().trim(),
      genericName: (json['generic_name'] ?? '').toString().trim(),
      dosageForm: (json['dosage_form'] ?? '').toString().trim(),
      strength: (json['strength'] ?? '').toString().trim(),
      manufacturer: (json['manufacturer'] ?? '').toString().trim(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'brand_name': brandName,
      'generic_name': genericName,
      'dosage_form': dosageForm,
      'strength': strength,
      'manufacturer': manufacturer,
    };
  }
}
