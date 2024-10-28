import 'package:flutter/material.dart';
import 'package:timetable_generation_application/constants/app_texts.dart';

import '../widgets/custom_appbar.dart';

class CourceScreen extends StatelessWidget {
  const CourceScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return  const Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(180),
        child: SappBar(height: 200, title: AppTexts.courseScreenTitle)
      ),
      body: Center(
        child: Text('Cources'),
      ),
    );
  }
}