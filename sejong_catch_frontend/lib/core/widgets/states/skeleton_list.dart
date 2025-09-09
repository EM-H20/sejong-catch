import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shimmer/shimmer.dart';
import '../../config/app_config.dart';
import '../../theme/app_colors.dart';

class SkeletonList extends StatelessWidget {
  final int itemCount;
  final bool isCompact;

  const SkeletonList({
    super.key,
    this.itemCount = AppConfig.skeletonItemCount,
    this.isCompact = false,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: itemCount,
      padding: EdgeInsets.symmetric(vertical: 8.h),
      itemBuilder: (context, index) => SkeletonCard(isCompact: isCompact),
    );
  }
}

class SkeletonCard extends StatelessWidget {
  final bool isCompact;

  const SkeletonCard({
    super.key,
    this.isCompact = false,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(horizontal: 16.w, vertical: 6.h),
      child: Shimmer.fromColors(
        baseColor: AppColors.skeletonBase,
        highlightColor: AppColors.skeletonHighlight,
        child: Padding(
          padding: EdgeInsets.all(16.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header with source info
              _buildSkeletonHeader(),
              
              SizedBox(height: 12.h),
              
              // Title lines
              _buildSkeletonTitle(),
              
              SizedBox(height: 8.h),
              
              // Metadata line
              _buildSkeletonMetadata(),
              
              // Summary (if not compact)
              if (!isCompact) ...[
                SizedBox(height: 12.h),
                _buildSkeletonSummary(),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSkeletonHeader() {
    return Row(
      children: [
        // Source logo placeholder
        Container(
          width: 24.w,
          height: 24.w,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(4.r),
          ),
        ),
        
        SizedBox(width: 8.w),
        
        // Source name
        Container(
          width: 80.w,
          height: 12.h,
          color: Colors.white,
        ),
        
        SizedBox(width: 8.w),
        
        // Trust badge
        Container(
          width: 40.w,
          height: 18.h,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(9.r),
          ),
        ),
        
        const Spacer(),
        
        // Bookmark icon
        Container(
          width: 20.w,
          height: 20.w,
          color: Colors.white,
        ),
      ],
    );
  }

  Widget _buildSkeletonTitle() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // First title line
        Container(
          width: double.infinity,
          height: 18.h,
          color: Colors.white,
        ),
        
        SizedBox(height: 6.h),
        
        // Second title line (partial width)
        Container(
          width: 0.7.sw,
          height: 18.h,
          color: Colors.white,
        ),
      ],
    );
  }

  Widget _buildSkeletonMetadata() {
    return Row(
      children: [
        // Category
        Container(
          width: 60.w,
          height: 12.h,
          color: Colors.white,
        ),
        
        SizedBox(width: 16.w),
        
        // Deadline/time
        Container(
          width: 40.w,
          height: 12.h,
          color: Colors.white,
        ),
      ],
    );
  }

  Widget _buildSkeletonSummary() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // First summary line
        Container(
          width: double.infinity,
          height: 14.h,
          color: Colors.white,
        ),
        
        SizedBox(height: 4.h),
        
        // Second summary line (partial)
        Container(
          width: 0.8.sw,
          height: 14.h,
          color: Colors.white,
        ),
      ],
    );
  }
}

/// Skeleton for grid layouts
class SkeletonGrid extends StatelessWidget {
  final int itemCount;
  final int crossAxisCount;

  const SkeletonGrid({
    super.key,
    this.itemCount = AppConfig.skeletonItemCount * 2,
    this.crossAxisCount = 2,
  });

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: crossAxisCount,
        childAspectRatio: 0.8,
        crossAxisSpacing: 12.w,
        mainAxisSpacing: 12.h,
      ),
      padding: EdgeInsets.all(16.w),
      itemCount: itemCount,
      itemBuilder: (context, index) => const SkeletonGridItem(),
    );
  }
}

class SkeletonGridItem extends StatelessWidget {
  const SkeletonGridItem({super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Shimmer.fromColors(
        baseColor: AppColors.skeletonBase,
        highlightColor: AppColors.skeletonHighlight,
        child: Padding(
          padding: EdgeInsets.all(12.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Image placeholder
              Container(
                width: double.infinity,
                height: 80.h,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(6.r),
                ),
              ),
              
              SizedBox(height: 8.h),
              
              // Title
              Container(
                width: double.infinity,
                height: 14.h,
                color: Colors.white,
              ),
              
              SizedBox(height: 4.h),
              
              // Subtitle
              Container(
                width: 0.7.sw,
                height: 12.h,
                color: Colors.white,
              ),
              
              const Spacer(),
              
              // Footer
              Container(
                width: 0.5.sw,
                height: 10.h,
                color: Colors.white,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Skeleton for individual lines of text
class SkeletonText extends StatelessWidget {
  final double width;
  final double height;

  const SkeletonText({
    super.key,
    this.width = double.infinity,
    this.height = 16,
  });

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: AppColors.skeletonBase,
      highlightColor: AppColors.skeletonHighlight,
      child: Container(
        width: width,
        height: height.h,
        color: Colors.white,
      ),
    );
  }
}