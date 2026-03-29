import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/styling/app_colors.dart';
import '../../../../core/styling/app_assets.dart';

/// Luna avatar with lavender border and flower image
class LunaAvatarWidget extends StatelessWidget {
  const LunaAvatarWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 100.w,
      height: 100.h,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(
          color: AppColors.lavender.withValues(alpha: 0.4),
          width: 3.w,
        ),
      ),
      child: Container(
        decoration: const BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.white,
        ),
        child: Center(
          child: Image.asset(
            AppAssets.greetingMorning,
            width: 50.w,
            height: 50.h,
            fit: BoxFit.contain,
          ),
        ),
      ),
    );
  }
}
