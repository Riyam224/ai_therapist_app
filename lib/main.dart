import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'core/cubits/theme_cubit.dart';
import 'core/injection/injection.dart';
import 'core/routing/router_generation_config.dart';
import 'core/styling/app_theme.dart';
import 'features/home/data/datasources/mood_local_datasource.dart';
import 'features/quotes/data/datasources/saved_quotes_local_datasource.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  await Hive.openBox<String>(MoodLocalDatasource.boxName);
  await Hive.openBox<String>(SavedQuotesLocalDatasource.boxName);
  await Hive.openBox<bool>('settings');
  // load .env first
  await dotenv.load(fileName: '.env');
  await Supabase.initialize(
    url: dotenv.env['SUPABASE_URL']!,
    anonKey: dotenv.env['SUPABASE_ANON_KEY']!,
  );
  setupInjection();

  Supabase.instance.client.auth.onAuthStateChange.listen((data) {
    // Only navigate for initial session check and explicit sign-in/sign-out.
    // Ignoring tokenRefreshed / userUpdated / passwordRecovery prevents the
    // router from calling go('/home') and silently popping active screens
    // (e.g. the AI response screen) whenever Supabase refreshes the JWT.
    const navigableEvents = {
      AuthChangeEvent.initialSession,
      AuthChangeEvent.signedIn,
      AuthChangeEvent.signedOut,
    };
    if (!navigableEvents.contains(data.event)) return;

    final session = data.session;
    if (session != null) {
      RouterGenerationConfig.goRouter.go('/home');
    } else {
      RouterGenerationConfig.goRouter.go('/loginScreen');
    }
  });

  runApp(const LunaSpace());
}

class LunaSpace extends StatelessWidget {
  const LunaSpace({super.key});

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
