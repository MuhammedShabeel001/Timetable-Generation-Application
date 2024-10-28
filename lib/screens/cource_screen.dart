import 'package:flutter/material.dart';

import '../widgets/custom_appbar.dart';

class CourceScreen extends StatelessWidget {
  const CourceScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return  const Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(180),
        child: SappBar(height: 200, title: 'Cource')
      ),
      body: Center(
        child: Text('Cources'),
      ),
    );
  }
}