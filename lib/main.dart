import 'package:clikz_studio/app.dart';
import 'package:flutter/material.dart';
import 'core/services/firebase_service.dart';

void main() async {
  await FirebaseService.initialize();
  runApp(const AppEngine());
}
