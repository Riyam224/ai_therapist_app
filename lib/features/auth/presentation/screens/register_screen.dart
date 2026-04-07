import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:lottie/lottie.dart';
import '../../../../core/routing/app_routes.dart';
import '../../../../core/styling/app_colors.dart';
import '../cubit/auth_cubit.dart';
import '../cubit/auth_state.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  static const _primaryColor = AppColors.primary;
  static const _secondaryColor = Color(0xFF2D6A4F);
  static const _secondaryText = AppColors.lightSecondaryText;
  static const _cardBorder = AppColors.lightBorder;
  static const _textPrimary = AppColors.lightOnBackground;
  static const _textHint = Color(0xFFD4B5A0);
  static const _mintBg = Color(0xFFC8EDD8);
  static const _errorColor = Color(0xFFE24B4A);

  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscurePassword = true;
  double _passwordStrength = 0;
  String _passwordStrengthLabel = '';

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _onPasswordChanged(String value) {
    double strength = 0;
    String label = '';
    if (value.isEmpty) {
      strength = 0;
      label = '';
    } else if (value.length < 6) {
      strength = 0.33;
      label = 'Too short';
    } else if (value.length < 10) {
      strength = 0.66;
      label = 'Getting there';
    } else {
      strength = 1.0;
      label = 'Strong';
    }
    setState(() {
      _passwordStrength = strength;
      _passwordStrengthLabel = label;
    });
  }

  Color get _strengthColor {
    if (_passwordStrength <= 0.33) return _errorColor;
    if (_passwordStrength <= 0.66) return const Color(0xFFEF9F27);
    return _secondaryColor;
  }

  InputDecoration _fieldDecoration({
    required String label,
    required String hint,
    Widget? suffixIcon,
  }) {
    return InputDecoration(
      label: Text(
        label,
        style: const TextStyle(
          color: _secondaryColor,
          fontSize: 12,
          fontWeight: FontWeight.w500,
        ),
      ),
      hintText: hint,
      hintStyle: const TextStyle(color: _textHint),
      filled: true,
      fillColor: Colors.white,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: const BorderSide(color: _cardBorder, width: 1.5),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: const BorderSide(color: _secondaryColor, width: 2),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: const BorderSide(color: _errorColor, width: 2),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: const BorderSide(color: _errorColor, width: 2),
      ),
      suffixIcon: suffixIcon,
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthCubit, AuthState>(
      listener: (context, state) {
        if (state is AuthAuthenticated) {
          context.go(AppRoutes.home);
        } else if (state is AuthError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.message),
              backgroundColor: _primaryColor,
              behavior: SnackBarBehavior.floating,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          );
        }
      },
      child: Scaffold(
        backgroundColor: AppColors.lightBackground,
        body: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 52),
                // Plant avatar — mint background
                Center(
                  child: Container(
                    width: 88,
                    height: 88,
                    decoration: const BoxDecoration(
                      color: _mintBg,
                      shape: BoxShape.circle,
                    ),
                    child: Lottie.asset(
                      'assets/lottie/plant.json',
                      width: 52,
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
                const SizedBox(height: 28),
                const Text(
                  'Start your journey',
                  style: TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.w600,
                    color: _textPrimary,
                  ),
                ),
                const SizedBox(height: 6),
                const Text(
                  'Luna is ready to listen 🌱',
                  style: TextStyle(fontSize: 14, color: _secondaryText),
                ),
                const SizedBox(height: 32),
                // Full name field
                TextField(
                  controller: _nameController,
                  keyboardType: TextInputType.name,
                  textInputAction: TextInputAction.next,
                  textCapitalization: TextCapitalization.words,
                  decoration: _fieldDecoration(
                    label: 'Full name',
                    hint: 'Your name',
                  ),
                ),
                const SizedBox(height: 16),
                // Email field
                TextField(
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  textInputAction: TextInputAction.next,
                  decoration: _fieldDecoration(
                    label: 'Email',
                    hint: 'your@email.com',
                  ),
                ),
                const SizedBox(height: 16),
                // Password field
                TextField(
                  controller: _passwordController,
                  obscureText: _obscurePassword,
                  textInputAction: TextInputAction.done,
                  onChanged: _onPasswordChanged,
                  decoration: _fieldDecoration(
                    label: 'Password',
                    hint: '••••••••',
                    suffixIcon: IconButton(
                      icon: Icon(
                        _obscurePassword
                            ? Icons.visibility_off_outlined
                            : Icons.visibility_outlined,
                        color: _secondaryText,
                      ),
                      onPressed: () => setState(
                        () => _obscurePassword = !_obscurePassword,
                      ),
                    ),
                  ),
                ),
                // Password strength indicator
                if (_passwordStrength > 0) ...[
                  const SizedBox(height: 8),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(2),
                    child: LinearProgressIndicator(
                      value: _passwordStrength,
                      minHeight: 3,
                      backgroundColor: _cardBorder,
                      valueColor: AlwaysStoppedAnimation(_strengthColor),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    _passwordStrengthLabel,
                    style: TextStyle(fontSize: 11, color: _strengthColor),
                  ),
                ],
                const SizedBox(height: 24),
                // CTA button
                BlocBuilder<AuthCubit, AuthState>(
                  builder: (context, state) {
                    final isLoading = state is AuthLoading;
                    return SizedBox(
                      width: double.infinity,
                      height: 56,
                      child: ElevatedButton(
                        onPressed: isLoading
                            ? null
                            : () => context.read<AuthCubit>().register(
                                  email: _emailController.text.trim(),
                                  password: _passwordController.text,
                                  name: _nameController.text.trim(),
                                ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: _secondaryColor,
                          foregroundColor: Colors.white,
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                        ),
                        child: isLoading
                            ? Lottie.asset(
                                'assets/lottie/plant_sprout.json',
                                width: 24,
                                height: 24,
                                repeat: true,
                              )
                            : const Text(
                                'Begin growing',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                      ),
                    );
                  },
                ),
                const SizedBox(height: 16),
                // Divider
                Row(
                  children: [
                    Expanded(
                      child: Divider(color: _cardBorder, thickness: 1),
                    ),
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 12),
                      child: Text(
                        'or',
                        style: TextStyle(color: _secondaryText, fontSize: 12),
                      ),
                    ),
                    Expanded(
                      child: Divider(color: _cardBorder, thickness: 1),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                // Google button
                SizedBox(
                  width: double.infinity,
                  height: 52,
                  child: OutlinedButton.icon(
                    onPressed: () => context.read<AuthCubit>().signInWithGoogle(),
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(color: _cardBorder, width: 1.5),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                      foregroundColor: _textPrimary,
                    ),
                    icon: const _GoogleIcon(),
                    label: const Text(
                      'Sign up with Google',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                // Sign in link
                Center(
                  child: GestureDetector(
                    onTap: () => context.go(AppRoutes.loginScreen),
                    child: RichText(
                      text: const TextSpan(
                        children: [
                          TextSpan(
                            text: 'Already have an account? ',
                            style: TextStyle(
                              color: _secondaryText,
                              fontSize: 13,
                            ),
                          ),
                          TextSpan(
                            text: 'Sign in',
                            style: TextStyle(
                              color: _primaryColor,
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 24),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _GoogleIcon extends StatelessWidget {
  const _GoogleIcon();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 20,
      height: 20,
      alignment: Alignment.center,
      child: const Text(
        'G',
        style: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
          color: Color(0xFF4285F4),
        ),
      ),
    );
  }
}
