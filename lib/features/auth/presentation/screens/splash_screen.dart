import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lottie/lottie.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../../core/routing/app_routes.dart';
import '../../../../core/styling/app_colors.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _navigate();
  }

  Future<void> _navigate() async {
    await Future.delayed(const Duration(seconds: 4));
    if (!mounted) return;
    final user = Supabase.instance.client.auth.currentUser;
    if (user != null) {
      context.go(AppRoutes.home);
    } else {
      context.go(AppRoutes.loginScreen);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.lightBackground,
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Lottie.asset(
                'assets/lottie/plant.json',
                width: 160,
                fit: BoxFit.contain,
              ),
              const SizedBox(height: 24),
              const Text(
                'LunaTree',
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.w600,
                  color: AppColors.lightOnBackground,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'Your gentle companion',
                style: TextStyle(
                  fontSize: 15,
                  color: AppColors.lightSecondaryText,
                ),
              ),
              const SizedBox(height: 48),
              Lottie.asset(
                'assets/lottie/plant_sprout.json',
                width: 28,
                height: 28,
                fit: BoxFit.contain,
                repeat: true,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
