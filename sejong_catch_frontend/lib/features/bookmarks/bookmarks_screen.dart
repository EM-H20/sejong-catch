import 'package:flutter/material.dart';
import '../../core/core.dart';

class BookmarksScreen extends StatelessWidget {
  const BookmarksScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('북마크'),
        backgroundColor: AppColors.surface(context),
      ),
      body: const Center(
        child: Text('북마크 화면 (구현 예정)'),
      ),
    );
  }
}