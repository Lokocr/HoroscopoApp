import 'dart:io';

class AdHelper {
  static String get bannerAdUnitId {
    if (Platform.isAndroid) {
      return "ca-app-pub-5452229565855763/2639790728";
    }
    // Proximamente iOS.
    else {
      throw new UnsupportedError("Unsuported platform");
    }
  }

  // static String get nativeAdUnitId {
  //   if (Platform.isAndroid) {
  //     return "ca-app-pub-3940256099942544/2247696110";
  //   }
  //   // Proximamente iOS.
  //   else {
  //     throw new UnsupportedError("Unsuported platform");
  //   }
  // }
}
