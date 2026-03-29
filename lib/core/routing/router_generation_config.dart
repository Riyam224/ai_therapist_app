import 'package:ai_therapist_app/core/routing/app_routes.dart';
import 'package:ai_therapist_app/core/navigation/main_shell_screen.dart';
import 'package:go_router/go_router.dart';
import '../../features/home/presentation/screens/home_screen.dart';
import '../../features/journal/presentation/screens/journal_history_screen.dart';
import '../../features/profile/presentation/screens/profile_screen.dart';
import '../../features/response/presentation/screens/response_ai_screen.dart';

class RouterGenerationConfig {
  static GoRouter goRouter = GoRouter(
    initialLocation: AppRoutes.home,
    routes: [
      // Main app shell with bottom navigation
      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) {
          return MainShellScreen(navigationShell: navigationShell);
        },
        branches: [
          // Home Branch
          StatefulShellBranch(
            routes: [
              GoRoute(
                name: AppRoutes.home,
                path: AppRoutes.home,
                builder: (context, state) => const HomeScreen(),
              ),
            ],
          ),
          // Journal Branch
          StatefulShellBranch(
            routes: [
              GoRoute(
                name: AppRoutes.journal,
                path: AppRoutes.journal,
                builder: (context, state) => const JournalHistoryScreen(),
              ),
            ],
          ),
          // Profile Branch
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

      // Standalone routes (outside bottom navigation)
      GoRoute(
        name: AppRoutes.response,
        path: AppRoutes.response,
        builder: (context, state) {
          // Get parameters from navigation
          final extra = state.extra as Map<String, dynamic>?;
          final emojiPath = extra?['emojiPath'] as String?;
          final thoughts = extra?['thoughts'] as String?;

          return ResponseAiScreen(
            emojiImagePath: emojiPath,
            thoughts:
                thoughts ??
                'I feel very overwhelmed with everything lately and I don\'t know what to do',
          );
        },
      ),

      // Auth routes (commented out for now)
      // GoRoute(
      //   name: AppRoutes.loginScreen,
      //   path: AppRoutes.loginScreen,
      //   builder: (context, state) => BlocProvider(
      //     create: (context) => sl<AuthCubit>(),
      //     child: const LoginScreen(),
      //   ),
      // ),
      // GoRoute(
      //   name: AppRoutes.registerScreen,
      //   path: AppRoutes.registerScreen,
      //   builder: (context, state) => const RegisterScreen(),
      // ),
    ],
  );
}
