import 'package:flutter/foundation.dart';

import 'api_keys.dart';

abstract final class AppConfig {
  static bool get hasSupabaseKeys =>
      ApiKeys.supabaseUrl.trim().isNotEmpty &&
      ApiKeys.supabaseAnonKey.trim().isNotEmpty;

  static bool get isRevenueCatSupportedPlatform =>
      !kIsWeb &&
      (defaultTargetPlatform == TargetPlatform.iOS ||
          defaultTargetPlatform == TargetPlatform.android);

  static String get currentRevenueCatApiKey {
    if (!isRevenueCatSupportedPlatform) return '';

    return switch (defaultTargetPlatform) {
      TargetPlatform.iOS => ApiKeys.revenueCatAppleApiKey.trim(),
      TargetPlatform.android => ApiKeys.revenueCatGoogleApiKey.trim(),
      _ => '',
    };
  }

  static bool get hasRevenueCatKeys =>
      currentRevenueCatApiKey.isNotEmpty;

  static String get maskedSupabaseUrl {
    if (!hasSupabaseKeys) return '';
    if (ApiKeys.supabaseUrl.length <= 24) return ApiKeys.supabaseUrl;

    return '${ApiKeys.supabaseUrl.substring(0, 24)}...';
  }

  static String get maskedRevenueCatApiKey {
    if (!hasRevenueCatKeys) return '';
    if (currentRevenueCatApiKey.length <= 8) {
      return currentRevenueCatApiKey;
    }

    return '${currentRevenueCatApiKey.substring(0, 4)}...${currentRevenueCatApiKey.substring(currentRevenueCatApiKey.length - 4)}';
  }
}
