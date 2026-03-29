import 'package:ai_therapist_app/core/injection/injection.dart';
import 'package:ai_therapist_app/core/routing/app_routes.dart';
import 'package:ai_therapist_app/core/navigation/main_shell_screen.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../features/home/presentation/cubit/mood_cubit.dart';
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

          return BlocProvider(
            create: (_) => sl<MoodCubit>(),
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
