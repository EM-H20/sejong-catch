import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sejong_catch_frontend/core/theme/app_colors.dart';

/// 📋 줄서기 페이지 - 축제/행사 큐 관리
///
/// CLAUDE.md 원칙:
/// ✅ UI만 담당하는 깔끔한 페이지 (Feed/Search 패턴 적용!)
/// ✅ 실시간 큐 목록 + 내 순번
/// ✅ 운영자는 FAB으로 큐 생성 (바텀시트로 통합!)
/// ✅ 모든 UI가 한 파일에 통합됨
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
      appBar: _buildAppBar(),
      body: _buildBody(),
      floatingActionButton: _buildFAB(),
    );
  }

  /// 🔝 앱바
  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      title: Row(
        children: [
          Text(
            '세종 캐치',
            style: TextStyle(
              fontSize: 20.sp,
              fontWeight: FontWeight.w700,
              color: const Color(0xFFDC143C),
            ),
          ),
          SizedBox(width: 6.w),
          Text(
            '줄서기',
            style: TextStyle(
              fontSize: 20.sp,
              fontWeight: FontWeight.w600,
              color: const Color(0xFF1F2937),
            ),
          ),
        ],
      ),
      backgroundColor: Colors.white,
      elevation: 0,
      bottom: TabBar(
        controller: _tabController,
        indicatorColor: const Color(0xFFDC143C),
        labelColor: const Color(0xFFDC143C),
        unselectedLabelColor: const Color(0xFF6B7280),
        labelStyle: TextStyle(fontSize: 15.sp, fontWeight: FontWeight.w600),
        unselectedLabelStyle: TextStyle(
          fontSize: 15.sp,
          fontWeight: FontWeight.w500,
        ),
        tabs: const [
          Tab(text: '전체 큐'),
          Tab(text: '내 대기열'),
        ],
      ),
    );
  }

  /// 📄 메인 컨텐츠
  Widget _buildBody() {
    return TabBarView(
      controller: _tabController,
      children: [_buildAllQueuesTab(), _buildMyQueuesTab()],
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
      padding: EdgeInsets.all(18.w),
      itemCount: dummyQueues.length,
      separatorBuilder: (context, index) => SizedBox(height: 16.h),
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
          borderRadius: BorderRadius.circular(16.r),
          border: Border.all(color: const Color(0xFFE5E7EB)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 8,
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
                    fontWeight: FontWeight.w700,
                    color: const Color(0xFF1F2937),
                  ),
                ),
                const Spacer(),
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: 12.w,
                    vertical: 6.h,
                  ),
                  decoration: BoxDecoration(
                    color: statusColor.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(12.r),
                    border: Border.all(
                      color: statusColor.withValues(alpha: 0.3),
                    ),
                  ),
                  child: Text(
                    statusText,
                    style: TextStyle(
                      fontSize: 12.sp,
                      fontWeight: FontWeight.w700,
                      color: statusColor,
                    ),
                  ),
                ),
              ],
            ),

            SizedBox(height: 16.h),

            // 통계 정보
            Row(
              children: [
                _buildStatItem(
                  Icons.people_outline,
                  '대기',
                  '${queue['waiting']}명',
                  const Color(0xFF3B82F6),
                ),
                SizedBox(width: 20.w),
                _buildStatItem(
                  Icons.timer_outlined,
                  '예상',
                  '${queue['avgWaitTime']}분',
                  const Color(0xFF8B5CF6),
                ),
                SizedBox(width: 20.w),
                _buildStatItem(
                  Icons.confirmation_number_outlined,
                  '현재',
                  '#${queue['currentNumber']}',
                  const Color(0xFFDC143C),
                ),
              ],
            ),

            if (isActive) ...[
              SizedBox(height: 16.h),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => _showJoinQueueDialog(queue),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFDC143C),
                    padding: EdgeInsets.symmetric(vertical: 14.h),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                    elevation: 0,
                  ),
                  child: Text(
                    '줄서기',
                    style: TextStyle(
                      fontSize: 15.sp,
                      fontWeight: FontWeight.w700,
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
  Widget _buildStatItem(
    IconData icon,
    String label,
    String value,
    Color color,
  ) {
    return Expanded(
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 10.h),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.08),
          borderRadius: BorderRadius.circular(10.r),
        ),
        child: Column(
          children: [
            Icon(icon, size: 20.sp, color: color),
            SizedBox(height: 4.h),
            Text(
              label,
              style: TextStyle(
                fontSize: 11.sp,
                color: const Color(0xFF6B7280),
                fontWeight: FontWeight.w500,
              ),
            ),
            SizedBox(height: 2.h),
            Text(
              value,
              style: TextStyle(
                fontSize: 14.sp,
                fontWeight: FontWeight.w700,
                color: const Color(0xFF1F2937),
              ),
            ),
          ],
        ),
      ),
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
      padding: EdgeInsets.all(18.w),
      itemCount: myQueues.length,
      separatorBuilder: (context, index) => SizedBox(height: 16.h),
      itemBuilder: (context, index) {
        return _buildMyQueueCard(myQueues[index]);
      },
    );
  }

  /// 🎫 내 큐 카드
  Widget _buildMyQueueCard(Map<String, dynamic> myQueue) {
    return Container(
      padding: EdgeInsets.all(24.w),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFFDC143C), Color(0xFFB0102F)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20.r),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFFDC143C).withValues(alpha: 0.4),
            blurRadius: 12,
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
              fontSize: 22.sp,
              fontWeight: FontWeight.w800,
              color: Colors.white,
            ),
          ),

          SizedBox(height: 24.h),

          // 내 번호 (크게)
          Container(
            padding: EdgeInsets.all(28.w),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(20.r),
              border: Border.all(
                color: Colors.white.withValues(alpha: 0.3),
                width: 2,
              ),
            ),
            child: Column(
              children: [
                Text(
                  '내 번호',
                  style: TextStyle(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w600,
                    color: Colors.white.withValues(alpha: 0.9),
                    letterSpacing: 1.2,
                  ),
                ),
                SizedBox(height: 12.h),
                Text(
                  '#${myQueue['myNumber']}',
                  style: TextStyle(
                    fontSize: 56.sp,
                    fontWeight: FontWeight.w900,
                    color: Colors.white,
                    height: 1.0,
                  ),
                ),
              ],
            ),
          ),

          SizedBox(height: 24.h),

          // 대기 정보
          Container(
            padding: EdgeInsets.all(18.w),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(16.r),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildMyQueueStat('현재 번호', '#${myQueue['currentNumber']}'),
                Container(
                  width: 1.5,
                  height: 48.h,
                  color: Colors.white.withValues(alpha: 0.3),
                ),
                _buildMyQueueStat('내 앞 대기', '${myQueue['peopleAhead']}명'),
                Container(
                  width: 1.5,
                  height: 48.h,
                  color: Colors.white.withValues(alpha: 0.3),
                ),
                _buildMyQueueStat('예상 대기', '${myQueue['estimatedWait']}분'),
              ],
            ),
          ),

          SizedBox(height: 20.h),

          // 포기 버튼
          TextButton.icon(
            onPressed: () => _showCancelDialog(myQueue),
            icon: Icon(
              Icons.close,
              size: 16.sp,
              color: Colors.white.withValues(alpha: 0.9),
            ),
            label: Text(
              '줄서기 포기',
              style: TextStyle(
                fontSize: 14.sp,
                fontWeight: FontWeight.w600,
                color: Colors.white.withValues(alpha: 0.9),
                decoration: TextDecoration.underline,
                decorationColor: Colors.white.withValues(alpha: 0.9),
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// 📊 내 큐 통계 아이템
  Widget _buildMyQueueStat(String label, String value) {
    return Column(
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 12.sp,
            fontWeight: FontWeight.w500,
            color: Colors.white.withValues(alpha: 0.8),
          ),
        ),
        SizedBox(height: 6.h),
        Text(
          value,
          style: TextStyle(
            fontSize: 20.sp,
            fontWeight: FontWeight.w800,
            color: Colors.white,
          ),
        ),
      ],
    );
  }

  /// 📭 빈 상태
  Widget _buildEmptyState(String title, String subtitle) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.queue_outlined,
            size: 80.sp,
            color: const Color(0xFF9CA3AF),
          ),
          SizedBox(height: 20.h),
          Text(
            title,
            style: TextStyle(
              fontSize: 20.sp,
              fontWeight: FontWeight.w700,
              color: const Color(0xFF374151),
            ),
          ),
          SizedBox(height: 8.h),
          Text(
            subtitle,
            style: TextStyle(fontSize: 14.sp, color: const Color(0xFF6B7280)),
          ),
        ],
      ),
    );
  }

  /// ➕ FAB (운영자 전용 - 큐 생성)
  Widget _buildFAB() {
    // 임시: 실제로는 권한 체크 (role >= Operator)
    // const isOperator = true;
    // if (!isOperator) return const SizedBox.shrink();

    return FloatingActionButton(
      onPressed: _showCreateQueueBottomSheet,
      backgroundColor: AppColors.textSecondary, // 회색 계열 (#6B7280)
      elevation: 4,
      child: Icon(Icons.add, size: 28.sp, color: AppColors.white),
    );
  }

  /// 🎪 큐 생성 바텀시트
  void _showCreateQueueBottomSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        padding: EdgeInsets.only(
          left: 24.w,
          right: 24.w,
          top: 24.h,
          bottom: MediaQuery.of(context).viewInsets.bottom + 24.h,
        ),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24.r)),
        ),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 헤더
              Row(
                children: [
                  Icon(
                    Icons.add_circle_outline,
                    size: 28.sp,
                    color: const Color(0xFFDC143C),
                  ),
                  SizedBox(width: 12.w),
                  Text(
                    '큐 생성',
                    style: TextStyle(
                      fontSize: 22.sp,
                      fontWeight: FontWeight.w700,
                      color: const Color(0xFF1F2937),
                    ),
                  ),
                  const Spacer(),
                  IconButton(
                    icon: Icon(Icons.close, size: 24.sp),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),

              SizedBox(height: 24.h),

              // 큐 이름
              Text(
                '큐 이름',
                style: TextStyle(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w600,
                  color: const Color(0xFF374151),
                ),
              ),
              SizedBox(height: 8.h),
              TextField(
                decoration: InputDecoration(
                  hintText: '예: 치킨부스, 주점, 게임존',
                  hintStyle: TextStyle(
                    fontSize: 14.sp,
                    color: const Color(0xFF9CA3AF),
                  ),
                  filled: true,
                  fillColor: const Color(0xFFF9FAFB),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12.r),
                    borderSide: const BorderSide(color: Color(0xFFE5E7EB)),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12.r),
                    borderSide: const BorderSide(color: Color(0xFFE5E7EB)),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12.r),
                    borderSide: const BorderSide(
                      color: Color(0xFFDC143C),
                      width: 2,
                    ),
                  ),
                  contentPadding: EdgeInsets.symmetric(
                    horizontal: 16.w,
                    vertical: 14.h,
                  ),
                ),
              ),

              SizedBox(height: 20.h),

              // 큐 타입
              Text(
                '큐 타입',
                style: TextStyle(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w600,
                  color: const Color(0xFF374151),
                ),
              ),
              SizedBox(height: 12.h),
              Wrap(
                spacing: 8.w,
                runSpacing: 8.h,
                children: [
                  _buildQueueTypeChip('🍗 음식', 'food'),
                  _buildQueueTypeChip('🍺 주점', 'drink'),
                  _buildQueueTypeChip('🎮 게임', 'game'),
                  _buildQueueTypeChip('📸 포토', 'photo'),
                  _buildQueueTypeChip('🎪 기타', 'other'),
                ],
              ),

              SizedBox(height: 20.h),

              // 예상 대기 시간
              Text(
                '1인당 예상 소요 시간',
                style: TextStyle(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w600,
                  color: const Color(0xFF374151),
                ),
              ),
              SizedBox(height: 8.h),
              TextField(
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  hintText: '예: 5',
                  hintStyle: TextStyle(
                    fontSize: 14.sp,
                    color: const Color(0xFF9CA3AF),
                  ),
                  suffixText: '분',
                  suffixStyle: TextStyle(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w600,
                    color: const Color(0xFF6B7280),
                  ),
                  filled: true,
                  fillColor: const Color(0xFFF9FAFB),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12.r),
                    borderSide: const BorderSide(color: Color(0xFFE5E7EB)),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12.r),
                    borderSide: const BorderSide(color: Color(0xFFE5E7EB)),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12.r),
                    borderSide: const BorderSide(
                      color: Color(0xFFDC143C),
                      width: 2,
                    ),
                  ),
                  contentPadding: EdgeInsets.symmetric(
                    horizontal: 16.w,
                    vertical: 14.h,
                  ),
                ),
              ),

              SizedBox(height: 28.h),

              // 생성 버튼
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('큐가 생성되었어요! 🎉'),
                        backgroundColor: Color(0xFFDC143C),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFDC143C),
                    padding: EdgeInsets.symmetric(vertical: 16.h),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                    elevation: 0,
                  ),
                  child: Text(
                    '큐 생성하기',
                    style: TextStyle(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),

              SizedBox(height: 8.h),
            ],
          ),
        ),
      ),
    );
  }

  /// 🏷️ 큐 타입 칩
  Widget _buildQueueTypeChip(String label, String type) {
    // 임시 상태 (실제로는 StatefulWidget으로 선택 상태 관리)
    final isSelected = type == 'food';

    return GestureDetector(
      onTap: () {
        // 선택 상태 변경 로직
      },
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFFDC143C) : const Color(0xFFF9FAFB),
          borderRadius: BorderRadius.circular(20.r),
          border: Border.all(
            color: isSelected
                ? const Color(0xFFDC143C)
                : const Color(0xFFE5E7EB),
            width: 1.5,
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 14.sp,
            fontWeight: FontWeight.w600,
            color: isSelected ? Colors.white : const Color(0xFF374151),
          ),
        ),
      ),
    );
  }

  /// 💬 줄서기 다이얼로그
  void _showJoinQueueDialog(Map<String, dynamic> queue) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16.r),
        ),
        title: Text(
          '${queue['name']} 줄서기',
          style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.w700),
        ),
        content: Text(
          '현재 ${queue['waiting']}명이 대기 중이에요.\n'
          '예상 대기시간은 약 ${queue['avgWaitTime']}분입니다.\n\n'
          '줄을 서시겠어요?',
          style: TextStyle(
            fontSize: 14.sp,
            color: const Color(0xFF6B7280),
            height: 1.5,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              '취소',
              style: TextStyle(
                fontSize: 14.sp,
                fontWeight: FontWeight.w600,
                color: const Color(0xFF6B7280),
              ),
            ),
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
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8.r),
              ),
              elevation: 0,
            ),
            child: Text(
              '줄서기',
              style: TextStyle(
                fontSize: 14.sp,
                fontWeight: FontWeight.w700,
                color: Colors.white,
              ),
            ),
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
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16.r),
        ),
        title: Text(
          '줄서기 포기',
          style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.w700),
        ),
        content: Text(
          '${myQueue['name']} 줄서기를 포기하시겠어요?\n다시 줄을 서려면 처음부터 대기해야 해요.',
          style: TextStyle(
            fontSize: 14.sp,
            color: const Color(0xFF6B7280),
            height: 1.5,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              '아니요',
              style: TextStyle(
                fontSize: 14.sp,
                fontWeight: FontWeight.w600,
                color: const Color(0xFF6B7280),
              ),
            ),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              setState(() {
                _tabController.animateTo(0); // 전체 큐 탭으로 이동
              });
              ScaffoldMessenger.of(
                context,
              ).showSnackBar(const SnackBar(content: Text('줄서기를 포기했어요')));
            },
            child: Text(
              '포기',
              style: TextStyle(
                fontSize: 14.sp,
                fontWeight: FontWeight.w700,
                color: const Color(0xFFEF4444),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
