import 'package:flutter/material.dart';
import '../../core/core.dart';

class SearchScreen extends StatelessWidget {
  const SearchScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('검색'),
        backgroundColor: AppColors.surface(context),
      ),
      body: const Center(
        child: Text('검색 화면 (구현 예정)'),
      ),
    );
  }
}