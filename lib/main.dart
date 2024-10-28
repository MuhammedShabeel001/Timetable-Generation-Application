import 'package:flutter/material.dart';
import 'package:timetable_generation_application/constants/app_routes.dart';
import 'package:timetable_generation_application/constants/route_manager.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'Timetable Generator',
      themeMode: ThemeMode.system,
      debugShowCheckedModeBanner: false,
      initialRoute: AppRoutes.home,
      onGenerateRoute: RouteManager.generateRoute,
    );
  }
}
