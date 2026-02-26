import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';

class HRScreen extends StatelessWidget {
  const HRScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Human Resources', style: TextStyle(fontFamily: 'Sora', fontWeight: FontWeight.bold)),
      ),
      body: const Center(child: Text('HR Module Content')),
    );
  }
}
