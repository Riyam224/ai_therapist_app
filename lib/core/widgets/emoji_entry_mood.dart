import 'package:ai_therapist_app/core/constants/app_sizes.dart';
import 'package:ai_therapist_app/core/styling/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

class EmojiEntryMood extends StatefulWidget {
  final String emojiAsset;
  final VoidCallback? onTap;
  final bool isSelected;
  final Color? moodColor;

  const EmojiEntryMood({
    super.key,
    required this.emojiAsset,
    this.onTap,
    this.isSelected = false,
    this.moodColor,
  });

  @override
  State<EmojiEntryMood> createState() => _EmojiEntryMoodState();
}

class _EmojiEntryMoodState extends State<EmojiEntryMood>
    with TickerProviderStateMixin {
  late final AnimationController _scaleController;
  late final AnimationController _rippleController;
  late final Animation<double> _scaleAnim;

  bool get _isSvg => widget.emojiAsset.endsWith('.svg');

  @override
  void initState() {
    super.initState();

    _scaleController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
    _scaleAnim = Tween<double>(begin: 1.0, end: 1.22).animate(
      CurvedAnimation(parent: _scaleController, curve: Curves.elasticOut),
    );

    _rippleController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );

    if (widget.isSelected) _scaleController.forward();
  }

  @override
  void didUpdateWidget(EmojiEntryMood old) {
    super.didUpdateWidget(old);
    if (widget.isSelected && !old.isSelected) {
      _scaleController.forward(from: 0);
      _rippleController.forward(from: 0);
    } else if (!widget.isSelected && old.isSelected) {
      _scaleController.reverse();
    }
  }

  @override
  void dispose() {
    _scaleController.dispose();
    _rippleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final color = widget.moodColor ?? AppColors.primary;

    return GestureDetector(
      onTap: widget.onTap,
      child: AnimatedBuilder(
        animation: Listenable.merge([_scaleAnim, _rippleController]),
        builder: (context, child) {
          return CustomPaint(
            painter: _RipplePainter(
              progress: _rippleController.value,
              color: color,
              size: AppSizes.emojiButtonSize,
            ),
            child: Transform.scale(
              scale: _scaleAnim.value,
              child: child,
            ),
          );
        },
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          curve: Curves.easeInOut,
          width: AppSizes.emojiButtonSize,
          height: AppSizes.emojiButtonSize,
          decoration: BoxDecoration(
            color: widget.isSelected
                ? color.withValues(alpha: 0.15)
                : color.withValues(alpha: 0.08),
            borderRadius: BorderRadius.circular(AppSizes.borderRadiusCircle),
            border: widget.isSelected
                ? Border.all(color: color, width: 2.w)
                : null,
          ),
          child: Center(
            child: _isSvg
                ? SvgPicture.asset(
                    widget.emojiAsset,
                    width: AppSizes.iconLg,
                    height: AppSizes.iconLg,
                    fit: BoxFit.contain,
                    colorFilter: ColorFilter.mode(
                      widget.isSelected
                          ? color
                          : color.withValues(alpha: 0.75),
                      BlendMode.srcIn,
                    ),
                  )
                : Image.asset(
                    widget.emojiAsset,
                    width: AppSizes.iconLg,
                    height: AppSizes.iconLg,
                    fit: BoxFit.contain,
                  ),
          ),
        ),
      ),
    );
  }
}

class _RipplePainter extends CustomPainter {
  final double progress;
  final Color color;
  final double size;

  _RipplePainter({
    required this.progress,
    required this.color,
    required this.size,
  });

  @override
  void paint(Canvas canvas, Size canvasSize) {
    if (progress == 0.0) return;

    final center = Offset(canvasSize.width / 2, canvasSize.height / 2);
    final baseRadius = size / 2;
    final radius = baseRadius + baseRadius * 0.7 * progress;
    final opacity = (1.0 - progress) * 0.45;

    final paint = Paint()
      ..color = color.withValues(alpha: opacity)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.5;

    canvas.drawCircle(center, radius, paint);
  }

  @override
  bool shouldRepaint(_RipplePainter old) => old.progress != progress;
}
