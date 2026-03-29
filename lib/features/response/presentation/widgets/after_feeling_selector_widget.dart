import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/routing/app_routes.dart';
import '../../../../core/styling/app_assets.dart';
import '../../../../core/styling/app_colors.dart';
import '../../../../core/styling/app_fonts.dart';
import '../../../../core/styling/theme_text_styles.dart';
import '../../../../core/constants/app_spacing.dart';
import 'package:go_router/go_router.dart';

/// After-feeling selector with celebration or encouragement overlay
class AfterFeelingSelectorWidget extends StatefulWidget {
  const AfterFeelingSelectorWidget({super.key});

  @override
  State<AfterFeelingSelectorWidget> createState() =>
      _AfterFeelingSelectorWidgetState();
}

class _AfterFeelingSelectorWidgetState
    extends State<AfterFeelingSelectorWidget> {
  int? _selectedIndex;

  // Index 3 = negative (Still sad) — rest are positive
  static const int _negativeIndex = 3;

  static const List<({String asset, String label})> _feelings = [
    (asset: AppAssets.emojiRelaxed,  label: 'Calm'),
    (asset: AppAssets.emojiGrateful, label: 'Loved'),
    (asset: AppAssets.moodOkay,      label: 'Better'),
    (asset: AppAssets.moodAwful,     label: 'Still sad'),
  ];

  void _onSelect(int index) {
    final wasAlreadySelected = _selectedIndex == index;
    setState(() {
      _selectedIndex = wasAlreadySelected ? null : index;
    });

    if (wasAlreadySelected) return;

    if (index == _negativeIndex) {
      _showEncouragementMessage();
    } else {
      _showCelebrationOverlay();
    }
  }

  // ── Celebration overlay (positive mood) ─────────────────────────────────────
  void _showCelebrationOverlay() {
    final overlay = Overlay.of(context);
    late OverlayEntry entry;

    entry = OverlayEntry(
      builder: (_) => _CelebrationOverlay(
        onDone: () => entry.remove(),
      ),
    );

    overlay.insert(entry);
  }

  // ── Encouragement message (negative mood) ────────────────────────────────────
  void _showEncouragementMessage() {
    final overlay = Overlay.of(context);
    late OverlayEntry entry;

    entry = OverlayEntry(
      builder: (_) => _EncouragementOverlay(
        onTalkAgain: () {
          entry.remove();
          context.go(AppRoutes.home);
        },
        onDismiss: () => entry.remove(),
      ),
    );

    overlay.insert(entry);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(AppSpacing.space2Xl),
      decoration: BoxDecoration(
        color: AppColors.cardBackground,
        borderRadius: BorderRadius.circular(20.r),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'How are you feeling after this?',
            style: ThemeTextStyles.titleSmall(context).copyWith(
              color: AppColors.primary,
            ),
          ),
          SizedBox(height: AppSpacing.spaceLg),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: List.generate(
              _feelings.length,
              (index) => _EmojiOption(
                asset: _feelings[index].asset,
                label: _feelings[index].label,
                isSelected: _selectedIndex == index,
                onTap: () => _onSelect(index),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ── Floating celebration particles ───────────────────────────────────────────

class _CelebrationOverlay extends StatefulWidget {
  final VoidCallback onDone;
  const _CelebrationOverlay({required this.onDone});

  @override
  State<_CelebrationOverlay> createState() => _CelebrationOverlayState();
}

class _CelebrationOverlayState extends State<_CelebrationOverlay>
    with TickerProviderStateMixin {
  late final AnimationController _controller;
  final List<_Particle> _particles = [];
  final Random _rng = Random();

  static const List<String> _celebrationEmojis = ['✨', '💜', '🌸', '⭐', '💫', '🎉'];

  @override
  void initState() {
    super.initState();

    // Spawn 12 particles at random horizontal positions
    for (int i = 0; i < 12; i++) {
      _particles.add(_Particle(
        emoji: _celebrationEmojis[_rng.nextInt(_celebrationEmojis.length)],
        x: _rng.nextDouble(),
        delay: _rng.nextDouble() * 0.4,
        size: 20 + _rng.nextDouble() * 20,
        drift: (_rng.nextDouble() - 0.5) * 0.15,
      ));
    }

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1800),
    )..forward().whenComplete(widget.onDone);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return IgnorePointer(
      child: AnimatedBuilder(
        animation: _controller,
        builder: (_, _) => Stack(
          children: _particles.map((p) {
            final t = ((_controller.value - p.delay) / (1 - p.delay)).clamp(0.0, 1.0);
            final opacity = t < 0.7 ? 1.0 : (1.0 - t) / 0.3;
            final y = size.height * 0.85 - (size.height * 0.75 * t);
            final x = size.width * p.x + (size.width * p.drift * t);

            return Positioned(
              left: x,
              top: y,
              child: Opacity(
                opacity: opacity.clamp(0.0, 1.0),
                child: Text(
                  p.emoji,
                  style: TextStyle(
                    // fontFamilyFallback ensures emoji render via the system
                    // emoji font (Apple Color Emoji / Noto) since Urbanist
                    // does not include emoji glyphs
                    fontFamilyFallback: const [
                      'Apple Color Emoji',
                      'Noto Color Emoji',
                      'Segoe UI Emoji',
                    ],
                    fontSize: p.size.sp,
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }
}

class _Particle {
  final String emoji;
  final double x;       // 0–1 horizontal position
  final double delay;   // 0–0.4 start delay
  final double size;    // font size
  final double drift;   // horizontal drift

  const _Particle({
    required this.emoji,
    required this.x,
    required this.delay,
    required this.size,
    required this.drift,
  });
}

// ── Floating encouragement message ───────────────────────────────────────────

class _EncouragementOverlay extends StatefulWidget {
  final VoidCallback onTalkAgain;
  final VoidCallback onDismiss;

  const _EncouragementOverlay({
    required this.onTalkAgain,
    required this.onDismiss,
  });

  @override
  State<_EncouragementOverlay> createState() => _EncouragementOverlayState();
}

class _EncouragementOverlayState extends State<_EncouragementOverlay>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<Offset> _slide;
  late final Animation<double> _fade;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 350),
    );
    _slide = Tween<Offset>(
      begin: const Offset(0, 0.15),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));
    _fade = CurvedAnimation(parent: _controller, curve: Curves.easeOut);

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _dismiss() async {
    await _controller.reverse();
    widget.onDismiss();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _dismiss,
      behavior: HitTestBehavior.opaque,
      child: Material(
        color: Colors.black.withValues(alpha: 0.35),
        child: Center(
          child: FadeTransition(
            opacity: _fade,
            child: SlideTransition(
              position: _slide,
              child: Container(
                margin: EdgeInsets.symmetric(horizontal: 32.w),
                padding: EdgeInsets.all(28.w),
                decoration: BoxDecoration(
                  color: AppColors.whiteBackground,
                  borderRadius: BorderRadius.circular(24.r),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.08),
                      blurRadius: 24,
                      offset: const Offset(0, 8),
                    ),
                  ],
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Emoji image
                    Image.asset(
                      AppAssets.emojiCalm,
                      width: 64.w,
                      height: 64.h,
                    ),
                    SizedBox(height: 16.h),

                    // Title
                    Text(
                      'Take a deep breath 🌬️',
                      style: ThemeTextStyles.titleLarge(context),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: 10.h),

                    // Message
                    Text(
                      'It\'s okay to still feel this way. Luna is always here whenever you need to talk again.',
                      style: ThemeTextStyles.bodySmall(context).copyWith(height: 1.5),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: 24.h),

                    // Talk again button
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: widget.onTalkAgain,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primary,
                          foregroundColor: AppColors.whiteTextColor,
                          elevation: 0,
                          padding: EdgeInsets.symmetric(vertical: 14.h),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14.r),
                          ),
                        ),
                        child: Text(
                          'Talk to Luna again ✨',
                          style: ThemeTextStyles.labelMedium(context).copyWith(
                            color: AppColors.whiteTextColor,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 10.h),

                    // Dismiss
                    TextButton(
                      onPressed: _dismiss,
                      child: Text(
                        'I\'ll be okay',
                        style: ThemeTextStyles.bodySmall(context),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// ── Emoji option button ───────────────────────────────────────────────────────

class _EmojiOption extends StatelessWidget {
  final String asset;
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _EmojiOption({
    required this.asset,
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        curve: Curves.easeInOut,
        width: 64.w,
        height: 72.h,
        decoration: BoxDecoration(
          color: isSelected
              ? AppColors.primary.withValues(alpha: 0.1)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(16.r),
          border: Border.all(
            color: isSelected ? AppColors.primary : Colors.transparent,
            width: 2,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              asset,
              width: 36.w,
              height: 36.h,
              fit: BoxFit.contain,
            ),
            SizedBox(height: 4.h),
            Text(
              label,
              style: TextStyle(
                fontFamily: AppFonts.mainFontName,
                fontSize: 10.sp,
                color: isSelected
                    ? AppColors.primary
                    : AppColors.secondaryTextColor,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
