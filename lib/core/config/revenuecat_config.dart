import 'package:flutter/foundation.dart';
import 'package:purchases_flutter/purchases_flutter.dart';

import 'app_config.dart';

abstract class RevenueCatConfig {
  static bool isEnabled = false;
}

Future<bool> configureRevenueCat() async {
  if (AppConfig.isRevenueCatSupportedPlatform) {
    final rcApiKey = AppConfig.currentRevenueCatApiKey;
    if (rcApiKey.isNotEmpty) {
      await Purchases.configure(PurchasesConfiguration(rcApiKey));
      RevenueCatConfig.isEnabled = true;
      return true;
    }
  }
  debugPrint(
    '⚠️ [RC] RevenueCat disabled (web=$kIsWeb, platform=$defaultTargetPlatform, emptyApiKey=${AppConfig.currentRevenueCatApiKey.isEmpty})',
  );
  return false;
}
