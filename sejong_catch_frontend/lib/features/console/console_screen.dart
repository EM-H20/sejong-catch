import 'package:flutter/material.dart';
import '../../core/core.dart';

class ConsoleScreen extends StatelessWidget {
  const ConsoleScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('관리자 콘솔'),
        backgroundColor: AppColors.surface(context),
      ),
      body: const Center(
        child: Text('관리자 콘솔 (구현 예정)'),
      ),
    );
  }
}