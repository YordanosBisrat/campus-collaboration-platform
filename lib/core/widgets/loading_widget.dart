import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../constants/app_sizes.dart';

// ── Full-page loading overlay ─────────────────────────────────────────────────

/// Displays a centered spinner for full-screen loading states.
/// Usage: replace body with LoadingWidget() or wrap with it.
class LoadingWidget extends StatelessWidget {
  final String? message;

  const LoadingWidget({super.key, this.message});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const CircularProgressIndicator(color: AppColors.primary),
          if (message != null) ...[
            const SizedBox(height: AppSizes.p16),
            Text(
              message!,
              style: const TextStyle(
                fontSize: 14,
                color: AppColors.textSecondary,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ],
      ),
    );
  }
}

// ── Inline button-sized spinner ───────────────────────────────────────────────

/// A small spinner sized like a button — use inside cards or rows.
class InlineLoader extends StatelessWidget {
  final double size;
  final Color color;

  const InlineLoader({
    super.key,
    this.size = 20,
    this.color = AppColors.primary,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: CircularProgressIndicator(strokeWidth: 2.5, color: color),
    );
  }
}

// ── Skeleton shimmer card ─────────────────────────────────────────────────────

/// A shimmer placeholder card for list screens while data loads.
class ShimmerCard extends StatefulWidget {
  final double height;

  const ShimmerCard({super.key, this.height = 100});

  @override
  State<ShimmerCard> createState() => _ShimmerCardState();
}

class _ShimmerCardState extends State<ShimmerCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;
  late Animation<double> _anim;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    )..repeat(reverse: true);
    _anim = Tween<double>(
      begin: 0.4,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _ctrl, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _anim,
      builder: (_, _) => Opacity(
        opacity: _anim.value,
        child: Container(
          height: widget.height,
          margin: const EdgeInsets.only(bottom: AppSizes.p12),
          decoration: BoxDecoration(
            color: AppColors.shimmerBase,
            borderRadius: BorderRadius.circular(AppSizes.radiusMedium),
          ),
          padding: const EdgeInsets.all(AppSizes.p16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Title placeholder
              Container(
                height: 14,
                width: 180,
                decoration: BoxDecoration(
                  color: AppColors.shimmerHighlight,
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
              const SizedBox(height: AppSizes.p8),
              // Subtitle placeholder
              Container(
                height: 12,
                width: 120,
                decoration: BoxDecoration(
                  color: AppColors.shimmerHighlight,
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
              const Spacer(),
              // Button placeholder
              Container(
                height: 30,
                width: 100,
                decoration: BoxDecoration(
                  color: AppColors.shimmerHighlight,
                  borderRadius: BorderRadius.circular(AppSizes.radiusSmall),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// A list of [ShimmerCard]s for use while a list screen is loading.
class ShimmerList extends StatelessWidget {
  final int count;
  final double cardHeight;

  const ShimmerList({super.key, this.count = 4, this.cardHeight = 110});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.all(AppSizes.p16),
      physics: const NeverScrollableScrollPhysics(),
      itemCount: count,
      itemBuilder: (_, _) => ShimmerCard(height: cardHeight),
    );
  }
}
