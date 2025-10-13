import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

/// 📋 줄서기 페이지 - 축제/행사 큐 관리
///
/// CLAUDE.md 원칙:
/// ✅ UI만 담당하는 깔끔한 페이지 (Profile 패턴 적용!)
/// ✅ 실시간 큐 목록 + 내 순번
/// ✅ 운영자는 FAB으로 큐 생성
class QueuePage extends ConsumerStatefulWidget {
  const QueuePage({super.key});

  @override
  ConsumerState<QueuePage> createState() => _QueuePageState();
}

class _QueuePageState extends ConsumerState<QueuePage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(context),
      body: _buildBody(context),
      floatingActionButton: _buildFAB(context),
    );
  }

  /// 🔝 앱바
  PreferredSizeWidget _buildAppBar(BuildContext context) {
    return AppBar(
      title: const Text('줄서기'),
      backgroundColor: Colors.transparent,
      elevation: 0,
      bottom: TabBar(
        controller: _tabController,
        indicatorColor: const Color(0xFFDC143C),
        labelColor: const Color(0xFFDC143C),
        unselectedLabelColor: const Color(0xFF6B7280),
        tabs: const [
          Tab(text: '전체 큐'),
          Tab(text: '내 대기열'),
        ],
      ),
    );
  }

  /// 📄 메인 컨텐츠
  Widget _buildBody(BuildContext context) {
    return TabBarView(
      controller: _tabController,
      children: [
        _buildAllQueuesTab(),
        _buildMyQueuesTab(),
      ],
    );
  }

  /// 📋 전체 큐 탭
  Widget _buildAllQueuesTab() {
    // 임시 더미 데이터
    final dummyQueues = [
      {
        'id': 'q1',
        'name': '🍗 치킨부스',
        'type': 'food',
        'status': 'active',
        'waiting': 12,
        'currentNumber': 5,
        'avgWaitTime': 15,
      },
      {
        'id': 'q2',
        'name': '🍺 주점',
        'type': 'drink',
        'status': 'active',
        'waiting': 8,
        'currentNumber': 3,
        'avgWaitTime': 10,
      },
      {
        'id': 'q3',
        'name': '🎮 게임존',
        'type': 'game',
        'status': 'paused',
        'waiting': 5,
        'currentNumber': 2,
        'avgWaitTime': 20,
      },
      {
        'id': 'q4',
        'name': '📸 포토존',
        'type': 'photo',
        'status': 'full',
        'waiting': 30,
        'currentNumber': 15,
        'avgWaitTime': 5,
      },
    ];

    if (dummyQueues.isEmpty) {
      return _buildEmptyState('운영 중인 큐가 없어요', '축제 기간에 다시 확인해보세요! 🎪');
    }

    return ListView.separated(
      padding: EdgeInsets.all(16.w),
      itemCount: dummyQueues.length,
      separatorBuilder: (context, index) => SizedBox(height: 12.h),
      itemBuilder: (context, index) {
        return _buildQueueCard(dummyQueues[index]);
      },
    );
  }

  /// 📇 큐 카드
  Widget _buildQueueCard(Map<String, dynamic> queue) {
    final status = queue['status'] as String;
    final isActive = status == 'active';
    final isPaused = status == 'paused';

    Color statusColor;
    String statusText;
    if (isActive) {
      statusColor = const Color(0xFF10B981);
      statusText = '운영중';
    } else if (isPaused) {
      statusColor = const Color(0xFFF59E0B);
      statusText = '일시정지';
    } else {
      statusColor = const Color(0xFFEF4444);
      statusText = '마감';
    }

    return GestureDetector(
      onTap: () {
        if (isActive) {
          _showJoinQueueDialog(queue);
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('${queue['name']}은(는) 현재 $statusText 상태예요')),
          );
        }
      },
      child: Container(
        padding: EdgeInsets.all(16.w),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12.r),
          border: Border.all(color: const Color(0xFFE5E7EB)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 헤더 (이름 + 상태)
            Row(
              children: [
                Text(
                  queue['name'] as String,
                  style: TextStyle(
                    fontSize: 18.sp,
                    fontWeight: FontWeight.w600,
                    color: const Color(0xFF1F2937),
                  ),
                ),
                const Spacer(),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
                  decoration: BoxDecoration(
                    color: statusColor.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                  child: Text(
                    statusText,
                    style: TextStyle(
                      fontSize: 12.sp,
                      fontWeight: FontWeight.w600,
                      color: statusColor,
                    ),
                  ),
                ),
              ],
            ),

            SizedBox(height: 12.h),

            // 통계 정보
            Row(
              children: [
                _buildStatItem(
                  Icons.people,
                  '대기',
                  '${queue['waiting']}명',
                  const Color(0xFF3B82F6),
                ),
                SizedBox(width: 16.w),
                _buildStatItem(
                  Icons.timer,
                  '예상 대기',
                  '${queue['avgWaitTime']}분',
                  const Color(0xFF8B5CF6),
                ),
                SizedBox(width: 16.w),
                _buildStatItem(
                  Icons.confirmation_number,
                  '현재 번호',
                  '#${queue['currentNumber']}',
                  const Color(0xFFDC143C),
                ),
              ],
            ),

            if (isActive) ...[
              SizedBox(height: 12.h),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => _showJoinQueueDialog(queue),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFDC143C),
                    padding: EdgeInsets.symmetric(vertical: 12.h),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.r),
                    ),
                  ),
                  child: Text(
                    '줄서기',
                    style: TextStyle(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  /// 📊 통계 아이템
  Widget _buildStatItem(IconData icon, String label, String value, Color color) {
    return Row(
      children: [
        Icon(icon, size: 16.sp, color: color),
        SizedBox(width: 4.w),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: TextStyle(
                fontSize: 11.sp,
                color: const Color(0xFF6B7280),
              ),
            ),
            Text(
              value,
              style: TextStyle(
                fontSize: 13.sp,
                fontWeight: FontWeight.w600,
                color: const Color(0xFF1F2937),
              ),
            ),
          ],
        ),
      ],
    );
  }

  /// 📋 내 대기열 탭
  Widget _buildMyQueuesTab() {
    // 임시 더미 데이터 (내가 참여한 큐)
    final myQueues = [
      {
        'id': 'mq1',
        'name': '🍗 치킨부스',
        'myNumber': 8,
        'currentNumber': 5,
        'peopleAhead': 3,
        'estimatedWait': 15,
      },
    ];

    if (myQueues.isEmpty) {
      return _buildEmptyState('참여 중인 큐가 없어요', '전체 큐 탭에서 줄을 서보세요!');
    }

    return ListView.separated(
      padding: EdgeInsets.all(16.w),
      itemCount: myQueues.length,
      separatorBuilder: (context, index) => SizedBox(height: 12.h),
      itemBuilder: (context, index) {
        return _buildMyQueueCard(myQueues[index]);
      },
    );
  }

  /// 🎫 내 큐 카드
  Widget _buildMyQueueCard(Map<String, dynamic> myQueue) {
    return Container(
      padding: EdgeInsets.all(20.w),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFFDC143C), Color(0xFFB0102F)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFFDC143C).withValues(alpha: 0.3),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          // 큐 이름
          Text(
            myQueue['name'] as String,
            style: TextStyle(
              fontSize: 20.sp,
              fontWeight: FontWeight.w700,
              color: Colors.white,
            ),
          ),

          SizedBox(height: 20.h),

          // 내 번호 (크게)
          Container(
            padding: EdgeInsets.all(24.w),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(16.r),
            ),
            child: Column(
              children: [
                Text(
                  '내 번호',
                  style: TextStyle(
                    fontSize: 14.sp,
                    color: Colors.white.withValues(alpha: 0.9),
                  ),
                ),
                SizedBox(height: 8.h),
                Text(
                  '#${myQueue['myNumber']}',
                  style: TextStyle(
                    fontSize: 48.sp,
                    fontWeight: FontWeight.w800,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),

          SizedBox(height: 20.h),

          // 대기 정보
          Container(
            padding: EdgeInsets.all(16.w),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(12.r),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Column(
                  children: [
                    Text(
                      '현재 번호',
                      style: TextStyle(
                        fontSize: 12.sp,
                        color: Colors.white.withValues(alpha: 0.8),
                      ),
                    ),
                    SizedBox(height: 4.h),
                    Text(
                      '#${myQueue['currentNumber']}',
                      style: TextStyle(
                        fontSize: 20.sp,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
                Container(
                  width: 1,
                  height: 40.h,
                  color: Colors.white.withValues(alpha: 0.3),
                ),
                Column(
                  children: [
                    Text(
                      '내 앞 대기',
                      style: TextStyle(
                        fontSize: 12.sp,
                        color: Colors.white.withValues(alpha: 0.8),
                      ),
                    ),
                    SizedBox(height: 4.h),
                    Text(
                      '${myQueue['peopleAhead']}명',
                      style: TextStyle(
                        fontSize: 20.sp,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
                Container(
                  width: 1,
                  height: 40.h,
                  color: Colors.white.withValues(alpha: 0.3),
                ),
                Column(
                  children: [
                    Text(
                      '예상 대기',
                      style: TextStyle(
                        fontSize: 12.sp,
                        color: Colors.white.withValues(alpha: 0.8),
                      ),
                    ),
                    SizedBox(height: 4.h),
                    Text(
                      '${myQueue['estimatedWait']}분',
                      style: TextStyle(
                        fontSize: 20.sp,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          SizedBox(height: 16.h),

          // 포기 버튼
          TextButton(
            onPressed: () => _showCancelDialog(myQueue),
            child: Text(
              '줄서기 포기',
              style: TextStyle(
                fontSize: 14.sp,
                color: Colors.white.withValues(alpha: 0.8),
                decoration: TextDecoration.underline,
                decorationColor: Colors.white.withValues(alpha: 0.8),
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// 📭 빈 상태
  Widget _buildEmptyState(String title, String subtitle) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.queue,
            size: 64.sp,
            color: const Color(0xFF9CA3AF),
          ),
          SizedBox(height: 16.h),
          Text(
            title,
            style: TextStyle(
              fontSize: 18.sp,
              fontWeight: FontWeight.w600,
              color: const Color(0xFF374151),
            ),
          ),
          SizedBox(height: 8.h),
          Text(
            subtitle,
            style: TextStyle(
              fontSize: 14.sp,
              color: const Color(0xFF6B7280),
            ),
          ),
        ],
      ),
    );
  }

  /// ➕ FAB (운영자 전용)
  Widget _buildFAB(BuildContext context) {
    // 임시: 실제로는 권한 체크 (role >= Operator)
    const isOperator = true;

    return FloatingActionButton.extended(
      onPressed: () {
        context.push('/queue/create');
      },
      backgroundColor: const Color(0xFFDC143C),
      icon: const Icon(Icons.add, color: Colors.white),
      label: Text(
        '큐 생성',
        style: TextStyle(
          fontSize: 14.sp,
          fontWeight: FontWeight.w600,
          color: Colors.white,
        ),
      ),
    );
  }

  /// 💬 줄서기 다이얼로그
  void _showJoinQueueDialog(Map<String, dynamic> queue) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('${queue['name']} 줄서기'),
        content: Text(
          '현재 ${queue['waiting']}명이 대기 중이에요.\n'
          '예상 대기시간은 약 ${queue['avgWaitTime']}분입니다.\n\n'
          '줄을 서시겠어요?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('취소'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              setState(() {
                _tabController.animateTo(1); // 내 대기열 탭으로 이동
              });
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('${queue['name']} 줄서기 완료! 순번을 확인하세요 🎉'),
                  backgroundColor: const Color(0xFFDC143C),
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFDC143C),
            ),
            child: const Text('줄서기', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  /// ❌ 포기 다이얼로그
  void _showCancelDialog(Map<String, dynamic> myQueue) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('줄서기 포기'),
        content: Text('${myQueue['name']} 줄서기를 포기하시겠어요?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('아니요'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('줄서기를 포기했어요')),
              );
            },
            child: Text(
              '포기',
              style: TextStyle(color: Colors.red[600]),
            ),
          ),
        ],
      ),
    );
  }
}
