class GeoDivision {
  final int id;
  final String name;
  final String bnName;

  GeoDivision({required this.id, required this.name, required this.bnName});

  factory GeoDivision.fromJson(Map<String, dynamic> json) {
    return GeoDivision(
      id: int.parse(json['id'].toString()),
      name: json['name'] ?? '',
      bnName: json['bn_name'] ?? '',
    );
  }
}

class GeoDistrict {
  final int id;
  final int divisionId;
  final String name;
  final String bnName;

  GeoDistrict({
    required this.id,
    required this.divisionId,
    required this.name,
    required this.bnName,
  });

  factory GeoDistrict.fromJson(Map<String, dynamic> json) {
    return GeoDistrict(
      id: int.parse(json['id'].toString()),
      divisionId: int.parse(json['division_id'].toString()),
      name: json['name'] ?? '',
      bnName: json['bn_name'] ?? '',
    );
  }
}

class GeoUpazila {
  final int id;
  final int districtId;
  final String name;
  final String bnName;

  GeoUpazila({
    required this.id,
    required this.districtId,
    required this.name,
    required this.bnName,
  });

  factory GeoUpazila.fromJson(Map<String, dynamic> json) {
    return GeoUpazila(
      id: int.parse(json['id'].toString()),
      districtId: int.parse(json['district_id'].toString()),
      name: json['name'] ?? '',
      bnName: json['bn_name'] ?? '',
    );
  }
}

class GeoUnion {
  final int id;
  final int upazilaId;
  final String name;
  final String bnName;

  GeoUnion({
    required this.id,
    required this.upazilaId,
    required this.name,
    required this.bnName,
  });

  factory GeoUnion.fromJson(Map<String, dynamic> json) {
    return GeoUnion(
      id: int.parse(json['id'].toString()),
      upazilaId: int.parse(json['upazila_id'].toString()),
      name: json['name'] ?? '',
      bnName: json['bn_name'] ?? '',
    );
  }
}
