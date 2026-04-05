import 'package:ai_therapist_app/core/injection/injection.dart';
import 'package:ai_therapist_app/core/routing/app_routes.dart';
import 'package:ai_therapist_app/core/navigation/main_shell_screen.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../features/auth/presentation/cubit/auth_cubit.dart';
import '../../features/auth/presentation/cubit/auth_state.dart';
import '../../features/auth/presentation/screens/login_screen.dart';
import '../../features/auth/presentation/screens/register_screen.dart';
import '../../features/auth/presentation/screens/splash_screen.dart';
import '../../features/home/presentation/cubit/mood_cubit.dart';
import '../../features/home/presentation/cubit/mood_state.dart';
import '../../features/home/presentation/screens/home_screen.dart';
import '../../features/journal/presentation/screens/journal_history_screen.dart';
import '../../features/profile/presentation/screens/profile_screen.dart';
import '../../features/response/presentation/screens/response_ai_screen.dart';

class RouterGenerationConfig {
  static GoRouter goRouter = GoRouter(
    initialLocation: AppRoutes.splash,
    routes: [
      // Splash
      GoRoute(
        name: AppRoutes.splash,
        path: AppRoutes.splash,
        builder: (context, state) => const SplashScreen(),
      ),

      // Auth
      GoRoute(
        name: AppRoutes.loginScreen,
        path: AppRoutes.loginScreen,
        builder: (context, state) => BlocProvider(
          create: (_) => sl<AuthCubit>(),
          child: const LoginScreen(),
        ),
      ),
      GoRoute(
        name: AppRoutes.registerScreen,
        path: AppRoutes.registerScreen,
        builder: (context, state) => BlocProvider(
          create: (_) => sl<AuthCubit>(),
          child: const RegisterScreen(),
        ),
      ),

      // Main app shell with bottom navigation
      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) {
          final moodCubit = sl<MoodCubit>();
          if (moodCubit.state is MoodInitial) moodCubit.getHistory();
          return MultiBlocProvider(
            providers: [
              BlocProvider.value(value: moodCubit),
              BlocProvider(create: (_) => sl<AuthCubit>()),
            ],
            child: BlocListener<AuthCubit, AuthState>(
              listener: (ctx, authState) {
                if (authState is AuthUnauthenticated) {
                  ctx.go(AppRoutes.loginScreen);
                }
              },
              child: MainShellScreen(navigationShell: navigationShell),
            ),
          );
        },
        branches: [
          StatefulShellBranch(
            routes: [
              GoRoute(
                name: AppRoutes.home,
                path: AppRoutes.home,
                builder: (context, state) => const HomeScreen(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                name: AppRoutes.journal,
                path: AppRoutes.journal,
                builder: (context, state) => const JournalHistoryScreen(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                name: AppRoutes.profile,
                path: AppRoutes.profile,
                builder: (context, state) => const ProfileScreen(),
              ),
            ],
          ),
        ],
      ),

      // Response screen — standalone, provides its own MoodCubit
      GoRoute(
        name: AppRoutes.response,
        path: AppRoutes.response,
        builder: (context, state) {
          final extra = state.extra as Map<String, dynamic>?;
          final emojiPath = extra?['emojiPath'] as String?;
          final emojiUnicode = extra?['emojiUnicode'] as String?;
          final thoughts = extra?['thoughts'] as String? ?? '';

          return BlocProvider.value(
            value: sl<MoodCubit>(),
            child: ResponseAiScreen(
              emojiImagePath: emojiPath,
              emojiUnicode: emojiUnicode,
              thoughts: thoughts,
            ),
          );
        },
      ),
    ],
  );
}
