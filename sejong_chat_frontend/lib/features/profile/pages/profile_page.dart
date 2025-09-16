import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../domain/controllers/auth_controller.dart';
import '../../../domain/controllers/app_controller.dart';

/// 프로필 화면
///
/// 사용자 정보, 설정, 로그아웃 등을 관리하는 화면입니다.
class ProfilePage extends ConsumerWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authControllerProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('프로필'),
      ),
      body: authState.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stackTrace) => Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error_outline, size: 48),
              const SizedBox(height: 16),
              const Text('오류가 발생했습니다'),
              const SizedBox(height: 8),
              ElevatedButton(
                onPressed: () => ref.invalidate(authControllerProvider),
                child: const Text('다시 시도'),
              ),
            ],
          ),
        ),
        data: (auth) => SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              // 사용자 프로필 섹션
              _buildProfileHeader(auth),
              const SizedBox(height: 24),

              // 설정 메뉴
              _buildSettingsMenu(context, ref, auth),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProfileHeader(auth) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // 프로필 이미지
            const CircleAvatar(
              radius: 40,
              child: Icon(Icons.person, size: 40),
            ),
            const SizedBox(height: 16),

            // 사용자 정보
            if (auth.isAuthenticated) ...[
              Text(
                auth.user?.displayName ?? '사용자',
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                auth.user?.email ?? '',
                style: const TextStyle(
                  fontSize: 14,
                  color: Colors.grey,
                ),
              ),
            ] else ...[
              const Text(
                '게스트 사용자',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 4),
              const Text(
                '로그인하면 더 많은 기능을 이용할 수 있어요',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildSettingsMenu(BuildContext context, WidgetRef ref, auth) {
    return Card(
      child: Column(
        children: [
          ListTile(
            leading: const Icon(Icons.info),
            title: const Text('앱 정보'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () {},
          ),
          if (auth.isAuthenticated) ...[
            const Divider(height: 1),
            ListTile(
              leading: const Icon(Icons.logout, color: Colors.red),
              title: const Text(
                '로그아웃',
                style: TextStyle(color: Colors.red),
              ),
              onTap: () => _showLogoutDialog(context, ref),
            ),
          ],
        ],
      ),
    );
  }

  Future<void> _showLogoutDialog(BuildContext context, WidgetRef ref) async {
    final result = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('로그아웃'),
        content: const Text('정말 로그아웃하시겠습니까?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('취소'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('로그아웃'),
          ),
        ],
      ),
    );

    if (result == true) {
      await ref.read(authControllerProvider.notifier).logout();
    }
  }
}