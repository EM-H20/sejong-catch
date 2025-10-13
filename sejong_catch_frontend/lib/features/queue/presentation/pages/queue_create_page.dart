import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

/// 🎪 큐 생성 페이지 - 운영자 전용
///
/// UI만 담당하는 깔끔한 페이지 (Login 패턴 적용!)
class QueueCreatePage extends ConsumerWidget {
  const QueueCreatePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('큐 생성'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.add_circle_outline, size: 64, color: Color(0xFFDC143C)),
            const SizedBox(height: 16),
            const Text(
              '큐 생성 페이지',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              '치킨부스, 주점, 게임존 등 큐를 만들어요',
              style: TextStyle(fontSize: 14, color: Colors.grey[600]),
            ),
            const SizedBox(height: 24),
            const Text(
              '🔧 운영자 기능 구현 예정!',
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () => context.pop(),
              child: const Text('뒤로 가기'),
            ),
          ],
        ),
      ),
    );
  }
}
