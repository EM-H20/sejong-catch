/// Nucleus UI 기반 세종캐치 Core 라이브러리
/// 테마, 위젯, 유틸리티 등 모든 핵심 기능을 한 곳에서 import할 수 있는 통합 인덱스
///
/// 사용법:
/// ```dart
/// import 'package:sejong_catch_frontend/core/core.dart';
///
/// // 이제 모든 핵심 기능을 사용할 수 있습니다
/// AppTheme.lightTheme()
/// AppButton(text: "클릭", onPressed: () {})
/// AppColors.primary
/// ```
library;

// ============================================================================
// THEME - 색상, 타이포그래피, 테마 시스템
// ============================================================================
export 'theme/app_colors.dart';
export 'theme/app_text_styles.dart';
export 'theme/app_theme.dart';

// ============================================================================
// WIDGETS - 모든 UI 컴포넌트들
// ============================================================================
export 'widgets/widgets.dart';
