import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'core/cubits/theme_cubit.dart';
import 'core/routing/router_generation_config.dart';
import 'core/styling/app_theme.dart';

void main() {
  runApp(const MindEase());
}

class MindEase extends StatelessWidget {
  const MindEase({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ThemeCubit(),
      child: ScreenUtilInit(
        designSize: const Size(390, 844),
        minTextAdapt: true,
        splitScreenMode: true,
        builder: (context, child) {
          return BlocBuilder<ThemeCubit, ThemeMode>(
            builder: (context, themeMode) {
              return MaterialApp.router(
                debugShowCheckedModeBanner: false,
                title: 'AI Therapist',
                theme: AppTheme.light,
                darkTheme: AppTheme.dark,
                themeMode: themeMode,
                routerConfig: RouterGenerationConfig.goRouter,
              );
            },
          );
        },
      ),
    );
  }
}