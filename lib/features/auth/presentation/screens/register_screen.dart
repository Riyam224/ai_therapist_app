import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/routing/app_routes.dart';
import '../../../../core/styling/theme_extensions.dart';
import '../cubit/auth_cubit.dart';
import '../cubit/auth_state.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
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

  Color _strengthColor(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    if (_passwordStrength <= 0.33) return cs.error;
    if (_passwordStrength <= 0.66) return const Color(0xFFEF9F27);
    return cs.primary;
  }

  InputDecoration _fieldDecoration({
    required BuildContext context,
    required String label,
    required String hint,
    Widget? suffixIcon,
  }) {
    final cs = Theme.of(context).colorScheme;
    final extra = context.extra;
    return InputDecoration(
      label: Text(
        label,
        style: TextStyle(
          color: extra.primaryColor,
          fontSize: 12,
          fontWeight: FontWeight.w500,
        ),
      ),
      hintText: hint,
      hintStyle: TextStyle(color: extra.secondaryTextColor),
      filled: true,
      fillColor: cs.surface,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: BorderSide(color: cs.outline, width: 1.5),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: BorderSide(color: cs.primary, width: 2),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: BorderSide(color: cs.error, width: 2),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: BorderSide(color: cs.error, width: 2),
      ),
      suffixIcon: suffixIcon,
    );
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final extra = context.extra;
    final textPrimary = extra.primaryTextColor!;
    final secondaryText = extra.secondaryTextColor!;
    final primaryColor = extra.primaryColor!;
    final borderColor = cs.outline;

    return BlocListener<AuthCubit, AuthState>(
      listener: (context, state) {
        if (state is AuthAuthenticated) {
          context.go(AppRoutes.home);
        } else if (state is AuthError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.message),
              backgroundColor: primaryColor,
              behavior: SnackBarBehavior.floating,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          );
        }
      },
      child: Scaffold(
        body: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 52),
                // Plant avatar
                Center(
                  child: Container(
                    width: 88,
                    height: 88,
                    decoration: BoxDecoration(
                      color: cs.primaryContainer,
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
                Text(
                  'Start your journey',
                  style: TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.w600,
                    color: textPrimary,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  'Luna is ready to listen 🌱',
                  style: TextStyle(fontSize: 14, color: secondaryText),
                ),
                const SizedBox(height: 32),
                // Full name field
                TextField(
                  controller: _nameController,
                  keyboardType: TextInputType.name,
                  textInputAction: TextInputAction.next,
                  textCapitalization: TextCapitalization.words,
                  style: TextStyle(color: textPrimary),
                  decoration: _fieldDecoration(
                    context: context,
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
                  style: TextStyle(color: textPrimary),
                  decoration: _fieldDecoration(
                    context: context,
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
                  style: TextStyle(color: textPrimary),
                  decoration: _fieldDecoration(
                    context: context,
                    label: 'Password',
                    hint: '••••••••',
                    suffixIcon: IconButton(
                      icon: Icon(
                        _obscurePassword
                            ? Icons.visibility_off_outlined
                            : Icons.visibility_outlined,
                        color: secondaryText,
                      ),
                      onPressed: () =>
                          setState(() => _obscurePassword = !_obscurePassword),
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
                      backgroundColor: borderColor,
                      valueColor:
                          AlwaysStoppedAnimation(_strengthColor(context)),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    _passwordStrengthLabel,
                    style: TextStyle(
                        fontSize: 11, color: _strengthColor(context)),
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
                          backgroundColor: primaryColor,
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
                    Expanded(child: Divider(color: borderColor, thickness: 1)),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      child: Text(
                        'or',
                        style: TextStyle(color: secondaryText, fontSize: 12),
                      ),
                    ),
                    Expanded(child: Divider(color: borderColor, thickness: 1)),
                  ],
                ),
                const SizedBox(height: 16),
                // Google button
                SizedBox(
                  width: double.infinity,
                  height: 52,
                  child: OutlinedButton.icon(
                    onPressed: () =>
                        context.read<AuthCubit>().signInWithGoogle(),
                    style: OutlinedButton.styleFrom(
                      side: BorderSide(color: borderColor, width: 1.5),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                      foregroundColor: textPrimary,
                    ),
                    icon: const _GoogleIcon(),
                    label: const Text(
                      'Sign up with Google',
                      style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                // Sign in link
                Center(
                  child: GestureDetector(
                    onTap: () => context.go(AppRoutes.loginScreen),
                    child: RichText(
                      text: TextSpan(
                        children: [
                          TextSpan(
                            text: 'Already have an account? ',
                            style: TextStyle(color: secondaryText, fontSize: 13),
                          ),
                          TextSpan(
                            text: 'Sign in',
                            style: TextStyle(
                              color: primaryColor,
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
