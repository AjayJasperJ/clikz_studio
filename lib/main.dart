import 'package:clikz_studio/app.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'features/auth/auth_provider.dart';
import 'core/services/firebase_service.dart';

void main() async {
  await FirebaseService.initialize();
  runApp(
    MultiProvider(
      providers: [ChangeNotifierProvider(create: (_) => AuthCredentialProvider())],
      child: const AppEngine(),
    ),
  );
}
