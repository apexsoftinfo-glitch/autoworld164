import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'app/app.dart';
import 'core/config/api_keys.dart';
import 'core/config/app_config.dart';
import 'core/config/revenuecat_config.dart';
import 'core/di/injection.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  if (AppConfig.hasSupabaseKeys) {
    await Supabase.initialize(
      url: ApiKeys.supabaseUrl,
      anonKey: ApiKeys.supabaseAnonKey,
    );
  }

  await configureRevenueCat();
  await configureDependencies();
  runApp(
    App(
      hasSupabaseKeys: AppConfig.hasSupabaseKeys,
    ),
  );
}
