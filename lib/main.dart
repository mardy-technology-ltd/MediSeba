import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'services/cache_service.dart';
import 'app.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await CacheService.init();
  runApp(const MediSebaApp());
}
