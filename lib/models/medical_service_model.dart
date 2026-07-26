import 'package:flutter/material.dart';

class MedicalServiceModel {
  final String id;
  final String title;
  final String description;
  final IconData icon;
  final Color color;

  MedicalServiceModel({
    required this.id,
    required this.title,
    required this.description,
    required this.icon,
    required this.color,
  });
}
