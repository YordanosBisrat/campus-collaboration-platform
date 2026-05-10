import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/constants/app_sizes.dart';
import '../../../../core/widgets/custom_button.dart';

class SuccessConfirmationScreen extends StatefulWidget {
  final String title;
  final String message;
  final String buttonText;
  final VoidCallback onButtonPressed;

  const SuccessConfirmationScreen({
    super.key,
    this.title = 'Your request has been\nsent successfully',
    this.message =
        'The user will contact you soon to coordinate further details.',
    this.buttonText = 'Go Back to Home',
    required this.onButtonPressed,
  });

  @override
  State<SuccessConfirmationScreen> createState() =>
      _SuccessConfirmationScreenState();
}

class _SuccessConfirmationScreenState extends State<SuccessConfirmationScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );

    _scaleAnimation = CurvedAnimation(
      parent: _controller,
      curve: Curves.elasticOut,
    );

    _fadeAnimation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeIn,
    );

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(AppSizes.p24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Spacer(),

              // ── Animated checkmark ─────────────────────────
              ScaleTransition(
                scale: _scaleAnimation,
                child: Container(
                  width: 100,
                  height: 100,
                  decoration: BoxDecoration(
                    color: AppColors.successLight,
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: AppColors.success.withValues(alpha: 0.3),
                      width: 6,
                    ),
                  ),
                  child: const Icon(
                    Icons.check_rounded,
                    color: AppColors.success,
                    size: 52,
                  ),
                ),
              ),

              const SizedBox(height: AppSizes.p32),

              // ── Title ──────────────────────────────────────
              FadeTransition(
                opacity: _fadeAnimation,
                child: Text(
                  widget.title,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    color: AppColors.textPrimary,
                    fontWeight: FontWeight.bold,
                    fontSize: 22,
                    height: 1.4,
                  ),
                ),
              ),

              const SizedBox(height: AppSizes.p16),

              // ── Message ────────────────────────────────────
              FadeTransition(
                opacity: _fadeAnimation,
                child: Text(
                  widget.message,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    color: AppColors.textSecondary,
                    fontSize: 15,
                    height: 1.5,
                  ),
                ),
              ),

              const Spacer(),

              // ── Button ─────────────────────────────────────
              FadeTransition(
                opacity: _fadeAnimation,
                child: CustomButton(
                  text: widget.buttonText,
                  onPressed: widget.onButtonPressed,
                ),
              ),

              const SizedBox(height: AppSizes.p24),
            ],
          ),
        ),
      ),
    );
  }
}