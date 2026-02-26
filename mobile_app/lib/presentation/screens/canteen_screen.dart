import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';

class CanteenScreen extends StatelessWidget {
  const CanteenScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Canteen POS', style: TextStyle(fontFamily: 'Sora', fontWeight: FontWeight.bold)),
      ),
      body: const Center(child: Text('Canteen Module Content')),
    );
  }
}
