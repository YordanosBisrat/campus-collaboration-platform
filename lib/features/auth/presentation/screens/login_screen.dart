import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/constants/app_sizes.dart';
import '../../../../core/widgets/custom_button.dart';
import '../../../../core/widgets/custom_text_field.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  bool _isLoading = false;
  String? _emailError;
  String? _passwordError;
  bool _hasSubmissionError = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _onLogin() {
    setState(() {
      _emailError = null;
      _passwordError = null;
      _hasSubmissionError = false;
    });

    bool hasError = false;
    final email = _emailController.text.trim();
    final password = _passwordController.text;

    if (email.isEmpty ||
        (!email.contains('@university') && !email.contains('.edu'))) {
      setState(
        () => _emailError = 'Please enter a valid university email address',
      );
      hasError = true;
    }

    if (password.length < 8) {
      setState(() => _passwordError = 'Password must be at least 8 characters');
      hasError = true;
    }

    if (hasError) {
      setState(() => _hasSubmissionError = true);
      return;
    }

    setState(() => _isLoading = true);

    // TODO: Replace with real auth logic
    Future.delayed(const Duration(seconds: 1), () {
      if (!mounted) return;
      setState(() => _isLoading = false);
      context.go('/home');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: AppSizes.p24),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center, // ← centered
              children: [
                const SizedBox(height: AppSizes.p32),

                // ── NU Logo ──────────────────────────────────────────
                const Text(
                  'NU',
                  style: TextStyle(
                    color: Color(0xFFFF9A9E),
                    fontFamily: 'HoltwoodOneSC',
                    fontWeight: FontWeight.w400,
                    fontSize: 56, // ← bigger
                    letterSpacing: -0.5,
                  ),
                ),

                const SizedBox(height: AppSizes.p24),

                // ── Heading (centered) ───────────────────────────────
                const Text(
                  'Welcome Back',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: AppSizes.p4),
                const Text(
                  'Sign in to continue to Campus App',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 14,
                    color: AppColors.textSecondary,
                  ),
                ),

                const SizedBox(height: AppSizes.p24),

                // ── Error banner ─────────────────────────────────────
                if (_hasSubmissionError)
                  Container(
                    width: double.infinity,
                    margin: const EdgeInsets.only(bottom: AppSizes.p16),
                    padding: const EdgeInsets.all(AppSizes.p12),
                    decoration: BoxDecoration(
                      color: AppColors.errorLight,
                      borderRadius: BorderRadius.circular(AppSizes.radiusSmall),
                      border: Border.all(
                        color: AppColors.error.withOpacity(0.3),
                      ),
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Icon(
                          Icons.error_outline,
                          color: AppColors.error,
                          size: 18,
                        ),
                        const SizedBox(width: AppSizes.p8),
                        const Expanded(
                          child: Text(
                            'There were errors with your submission. Please correct them below.',
                            style: TextStyle(
                              color: AppColors.error,
                              fontSize: 13,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                // ── Email / Username ─────────────────────────────────
                Align(
                  alignment: Alignment.centerLeft,
                  child: CustomTextField(
                    label: 'Email or Username',
                    hintText: 'student@university.edu',
                    prefixIcon: Icons.mail_outline,
                    controller: _emailController,
                    keyboardType: TextInputType.emailAddress,
                    errorText: _emailError,
                  ),
                ),

                // ── Password ─────────────────────────────────────────
                Align(
                  alignment: Alignment.centerLeft,
                  child: CustomTextField(
                    label: 'Password',
                    hintText: '••••••••',
                    prefixIcon: Icons.lock_outline,
                    isPassword: true,
                    controller: _passwordController,
                    errorText: _passwordError,
                  ),
                ),

                // ── Forgot Password ──────────────────────────────────
                Align(
                  alignment: Alignment.centerRight,
                  child: GestureDetector(
                    onTap: () => context.push('/forgot'),
                    child: const Text(
                      'Forgot Password?',
                      style: TextStyle(
                        color: AppColors.primary,
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: AppSizes.p24),

                // ── Login button ─────────────────────────────────────
                CustomButton(
                  text: 'Login',
                  onPressed: _onLogin,
                  isLoading: _isLoading,
                ),

                const SizedBox(height: AppSizes.p16),

                // ── Sign up link ─────────────────────────────────────
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      "Don't have an account? ",
                      style: TextStyle(
                        color: AppColors.textSecondary,
                        fontSize: 14,
                      ),
                    ),
                    GestureDetector(
                      onTap: () => context.push('/signup'),
                      child: const Text(
                        'Sign Up',
                        style: TextStyle(
                          color: AppColors.primary,
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: AppSizes.p32),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
