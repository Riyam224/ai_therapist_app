import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'core/app.dart';
import 'core/cubits/theme_cubit.dart';
import 'core/injection/injection.dart';
import 'core/routing/app_routes.dart';
import 'core/routing/router_generation_config.dart';
import 'features/home/data/datasources/mood_local_datasource.dart';
import 'features/quotes/data/datasources/saved_quotes_local_datasource.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Hive.initFlutter();
  await Hive.openBox<String>(MoodLocalDatasource.boxName);
  await Hive.openBox<String>(SavedQuotesLocalDatasource.boxName);
  await Hive.openBox<bool>(ThemeCubit.boxName);

  await dotenv.load(fileName: '.env');
  await Supabase.initialize(
    url: dotenv.env['SUPABASE_URL']!,
    anonKey: dotenv.env['SUPABASE_ANON_KEY']!,
  );

  setupInjection();

  Supabase.instance.client.auth.onAuthStateChange.listen((data) {
    // ✅ removed initialSession — splash screen handles that
    // Only react to explicit user actions (sign in / sign out)
    const navigableEvents = {
      AuthChangeEvent.signedIn,
      AuthChangeEvent.signedOut,
    };
    if (!navigableEvents.contains(data.event)) return;

    final session = data.session;

    // Don't navigate if currently on splash — let splash finish
    final config = RouterGenerationConfig
        .goRouter.routerDelegate.currentConfiguration;
    if (config.isEmpty) return; // deep link opened app before router initialized

    final currentLocation = config.last.matchedLocation;
    if (currentLocation == AppRoutes.splash) return;

    if (session != null) {
      RouterGenerationConfig.goRouter.go(AppRoutes.home);
    } else {
      RouterGenerationConfig.goRouter.go(AppRoutes.loginScreen);
    }
  });

  runApp(const App());
}
